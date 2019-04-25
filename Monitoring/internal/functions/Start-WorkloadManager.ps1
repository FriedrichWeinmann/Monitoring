function Start-WorkloadManager
{
<#
	.SYNOPSIS
		Generates a clean runspace pool for operating data gathering workloads.
	
	.DESCRIPTION
		Generates a clean runspace pool for operating data gathering workloads.
	
	.EXAMPLE
		PS C:\> Start-WorkloadManager
	
		Generates a clean runspace pool for operating data gathering workloads.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	[CmdletBinding()]
	Param (
	
	)
	
	begin
	{
		# Dispose of old runspace pools in case execution was interrupted
		if ($script:runspacePool -and -not $script:runspacePool.IsDisposed) { $script:runspacePool.Dispose() }
	}
	process
	{
		# Create a runspace pool with the same instance of the module imported
		$initialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
		$null = $initialSessionState.ImportPSModule("$($script:ModuleRoot)\Monitoring.psd1")
		$script:runspacePool = [RunspaceFactory]::CreateRunspacePool($initialSessionState)
		$null = $script:runspacePool.SetMinRunspaces(1)
		$null = $script:runspacePool.SetMaxRunspaces((Get-PSFConfigValue -FullName 'Monitoring.Runspace.MaxWorkerCount'))
		$script:runspacePool.Open()
		
		# Declare runtime variable storing the worker agent information
		$script:runspaces = @()
		
		# In-Memory Result Cache. For debugging purposes only.
		$script:lastCheckResults = @()
	}
}
