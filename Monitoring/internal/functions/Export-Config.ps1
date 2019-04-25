function Export-Config
{
<#
	.SYNOPSIS
		Persists configuration data controlling the module's execution.
	
	.DESCRIPTION
		Persists configuration data controlling the module's execution.
	
	.PARAMETER Type
		What kind of configuration data to export:
		- All : Everything (default)
		- Target : Configuration information about targets to service
		- Limit : The limits to use for determining alert states
	
	.PARAMETER TargetName
		Filter what targets should be affected.
		By default, all targets are exported.
	
	.EXAMPLE
		PS C:\> Export-Config
	
		Export all configuration data regarding all targets and limits.
#>
	[CmdletBinding()]
	Param (
		[ValidateSet('All', 'Target', 'Limit')]
		[string]
		$Type = 'All',
		
		[string]
		$TargetName = '*'
	)
	
	begin
	{
		$activeSource = Get-PSFConfigValue -FullName 'Monitoring.Source.Config.Active'
		$sourceItem = $script:configSources[$activeSource]
		if (-not $sourceItem)
		{
			Stop-PSFFunction -String 'Import-Config.SourceNotFound' -StringValues $activeSource -EnableException $true -Cmdlet $PSCmdlet
		}
	}
	process
	{
		$params = $Type, $TargetName
		$ExecutionContext.InvokeCommand.InvokeScript($true, $sourceItem.ExportScript, $null, $params)
	}
}
