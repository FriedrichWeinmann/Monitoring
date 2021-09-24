function Import-Data
{
<#
	.SYNOPSIS
		Gathers target data from disk.
	
	.DESCRIPTION
		Gathers target data from disk.
	
	.PARAMETER TargetName
		The target for which to retrieve data.
		Defaults to all items.
		target data is stored on disk under base64-encoded filename for compatibility reasons.
	
	.EXAMPLE
		PS C:\> Import-Data
	
		Imports all cached data.
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
		$null = $ExecutionContext.InvokeCommand.InvokeScript($true, $sourceItem.ImportScript, $null, $TargetName)
	}
}
