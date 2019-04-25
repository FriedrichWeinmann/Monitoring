function Invoke-MonCheck
{
<#
	.SYNOPSIS
		Command that gathers data as configured.
	
	.DESCRIPTION
		The main data gathering command.
		Schedule this command as a scheduled task after setting up the targets, connection capabilities and checks.
	
	.PARAMETER Tag
		The tags to scan for.
	
	.PARAMETER TargetName
		The targets to scan.
	
	.PARAMETER Name
		The name of the checks to execute.
	
	.EXAMPLE
		PS C:\> Invoke-MonCheck
	
		Executes all checks.
#>
	[CmdletBinding()]
	param (
		[string[]]
		$Tag = '*',
		
		[string[]]
		$TargetName = '*',
		
		[string[]]
		$Name = '*'
	)
	
	begin
	{
		Import-Config
		
		#region Auto Import Management Packs
		if (-not $script:triedAutoImport)
		{
			$script:triedAutoImport = $true
			
			#region Import Registered Management Pack Modules
			foreach ($moduleName in (Get-PSFConfigValue -FullName 'Monitoring.ManagementPack.Import'))
			{
				try
				{
					Write-PSFMessage -String 'Import.ManagementPack.Import' -StringValues $moduleName -ModuleName Monitoring
					Import-Module -Name $moduleName -Scope Global -ErrorAction Stop
				}
				catch
				{
					Write-PSFMessage -Level Warning -String 'Import.ManagementPack.Import.Failed' -StringValues $moduleName -ModuleName Monitoring
				}
			}
			#endregion Import Registered Management Pack Modules
			
			#region Import all detected Management Packs if enabled
			if (Get-PSFConfigValue -FullName 'Monitoring.ManagementPack.AutoLoad')
			{
				$psd1Files = Get-Item "C:\Program Files\WindowsPowerShell\Modules\*\*\*.psd1"
				$allManagementPackModules = foreach ($psd1File in $psd1Files)
				{
					$data = Import-PowerShellDataFile -Path $psd1File.FullName -ErrorAction Ignore
					if (-not $data) { continue }
					if (-not ($data.PrivateData.PSData.Tags -eq 'MonitoringManagementPack')) { continue }
					$data['FileName'] = $psd1File.BaseName
					$data['Path'] = $psd1File.FullName
					$data['ModuleVersion'] = [version]$data['ModuleVersion']
					[pscustomobject]$data
				}
				$toImport = $allManagementPackModules | Group-Object FileName | ForEach-Object {
					$_.Group | Sort-Object ModuleVersion -Descending | Select-Object -First 1 -ExpandProperty Path
				}
				foreach ($moduleManifest in $toImport)
				{
					try
					{
						Write-PSFMessage -String 'Import.ManagementPack.Import' -StringValues $moduleManifest -ModuleName Monitoring
						Import-Module $moduleManifest -Scope Global -ErrorAction Stop
					}
					catch
					{
						Write-PSFMessage -Level Warning -String 'Import.ManagementPack.Import.Failed' -StringValues $moduleManifest -ModuleName Monitoring
					}
				}
			}
			#endregion Import all detected Management Packs if enabled
		}
		#endregion Auto Import Management Packs
		
		Start-WorkloadManager
	}
	process
	{
		$checks = Get-MonCheck -Tag $Tag -Name $Name
		$targets = Get-MonTarget -Name $TargetName -Tag $Tag
		
		foreach ($targetItem in $targets)
		{
			$workload = [pscustomobject]@{
				PSTypeName = 'Monitoring.Workload'
				Target	   = $targetItem
				Checks	   = ($checks | Where-Object { Test-Overlap -ReferenceObject $targetItem -DifferenceObject $_ -Property Tag -Operator Like })
			}
			if (-not $workload.Checks) { continue }
			
			Add-Workload -WorkloadPackage $workload
		}
		
		Receive-Workload
	}
	end
	{
		Stop-WorkloadManager
	}
}
