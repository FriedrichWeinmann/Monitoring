function Get-MonDataSource
{
<#
	.SYNOPSIS
		Returns the registered data sources.
	
	.DESCRIPTION
		Returns the registered data sources.
	
	.PARAMETER Name
		The name of the source to return.
	
	.EXAMPLE
		PS C:\> Get-MonDataSource
	
		Lists all data sources.
#>
	[CmdletBinding()]
	param (
		[string]
		$Name = '*'
	)
	
	process
	{
		$script:dataSources.Values | Where-Object Name -Like $Name | ForEach-Object {
			$clonedHashtable = $_.Clone()
			$clonedHashtable['PSTypeName'] = 'Monitoring.DataSource'
			[pscustomobject]$clonedHashtable
		}
	}
}