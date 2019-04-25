function Export-Data
{
<#
	.SYNOPSIS
		Export the gathered data to cache.
	
	.DESCRIPTION
		Export the gathered data to cache.
	
	.PARAMETER TargetName
		Target name filter of what to export.
	
	.EXAMPLE
		PS C:\> Export-Data
	
		Export all gathered data to cache.
#>
	[CmdletBinding()]
	param (
		[string]
		$TargetName = '*'
	)
	
	begin
	{
		$activeSource = Get-PSFConfigValue -FullName 'Monitoring.Source.Data.Active'
		$sourceItem = $script:dataSources[$activeSource]
		if (-not $sourceItem)
		{
			Stop-PSFFunction -String 'Import-Data.SourceNotFound' -StringValues $activeSource -EnableException $true -Cmdlet $PSCmdlet
		}
	}
	process
	{
		$ExecutionContext.InvokeCommand.InvokeScript($true, $sourceItem.ExportScript, $null, $TargetName)
	}
}
