function Add-Workload
{
<#
	.SYNOPSIS
		Start a worker agent for gathering data from monitored targets.
	
	.DESCRIPTION
		Creates a new runspaces and adds it to the worker agent pool.
		Then adds a tracking item for tracking results with Receive-Workload.
	
	.PARAMETER WorkloadPackage
		A workload package, containing target and the related checks.
	
	.EXAMPLE
		PS C:\> Add-Workload -WorkloadPackage $workload
	
		Start a worker agent for gathering data from the monitored target specified in the workload package.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		$WorkloadPackage
	)
	
	begin
	{
		#region Main Invocation Scriptblock
		$scriptBlock = {
			param (
				$WorkLoad
			)
			
			$result = [pscustomobject]@{
				PSTypeName = 'Monitoring.CheckResult'
				Success    = $true
				Target	   = $WorkLoad.Target
				Checks	   = $WorkLoad.Checks
				Connected  = $false
				Results    = @{ }
				Errors	   = @()
				ErrorChecks = @()
			}
			
			#region Establish Connections
			try
			{
				$connections = Connect-MonTarget -Name $WorkLoad.Target.Name -ErrorAction Stop
				$result.Connected = $true
			}
			catch
			{
				$result.Errors += $_
				$result.Success = $false
				return $result
			}
			#endregion Establish Connections
			
			#region Execute Scans
			foreach ($check in $WorkLoad.Checks)
			{
				try
				{
					$result.Results[$check.Name] = @{
						Timestamp = (Get-Date)
						Result    = ($check.Check.Invoke($WorkLoad.Target.Name, $connections) | Write-Output)
						Message   = ''
					}
				}
				catch
				{
					$result.Results[$check.Name] = @{
						Timestamp = (Get-Date)
						Result    = $null
						Message   = $_.Exception.Message
					}
					$result.Errors += $_
					$result.ErrorChecks += $check
					$result.Success = $false
				}
			}
			#endregion Execute Scans
			
			#region Disconnect
			foreach ($capability in $WorkLoad.Target.Capability)
			{
				Disconnect-MonTarget -Capability $capability -Connection $connections -TargetName $WorkLoad.Target.Name -ErrorAction SilentlyContinue
			}
			#endregion Disconnect
			
			$result
		}
		#endregion Main Invocation Scriptblock
	}
	process
	{
		$powershell = [PowerShell]::Create().AddScript($scriptBlock).AddArgument($WorkloadPackage)
		$powershell.RunspacePool = $script:runspacePool
		$script:runspaces += [pscustomobject]@{
			Workload = $WorkloadPackage
			Runspace = $powerShell.BeginInvoke()
			PowerShell = $powerShell
			StartTime = (Get-Date)
			Received = $false
		}
	}
}
