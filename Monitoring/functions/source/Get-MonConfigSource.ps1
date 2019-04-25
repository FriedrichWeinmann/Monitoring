function Get-MonConfigSource
{
<#
	.SYNOPSIS
		Returns the registered config sources.
	
	.DESCRIPTION
		Returns the registered config sources.
	
	.PARAMETER Name
		The name of the source to return.
	
	.EXAMPLE
		PS C:\> Get-MonConfigSource
	
		Lists all config sources.
#>
	[CmdletBinding()]
	param (
		[string]
		$Name = '*'
	)
	
	process
	{
		$script:configSources.Values | Where-Object Name -Like $Name | ForEach-Object {
			$clonedHashtable = $_.Clone()
			$clonedHashtable['PSTypeName'] = 'Monitoring.ConfigSource'
			[pscustomobject]$clonedHashtable
		}
	}
}