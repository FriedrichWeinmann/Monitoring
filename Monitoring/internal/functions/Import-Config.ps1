function Import-Config
{
<#
	.SYNOPSIS
		Imports configuration data from cache.
	
	.DESCRIPTION
		Imports configuration data from cache.
	
	.PARAMETER Type
		What kind of configuration data to import:
		- All : Everything (default)
		- Target : Configuration information about targets to service
		- Limit : The limits to use for determining alert states
	
	.PARAMETER TargetName
		Filter what targets should be affected.
		By default, all targets are imported.
	
	.EXAMPLE
		PS C:\> Import-Config
	
		Imports all configuration data
#>
	[CmdletBinding()]
	param (
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
		$ExecutionContext.InvokeCommand.InvokeScript($true, $sourceItem.ImportScript, $null, $params)
	}
}
