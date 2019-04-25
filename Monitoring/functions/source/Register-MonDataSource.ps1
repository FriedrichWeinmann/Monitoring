function Register-MonDataSource
{
<#
	.SYNOPSIS
		Registers a custom monitoring data source.
	
	.DESCRIPTION
		Registers a custom monitoring data source.
		Data sources are the data backend that manage the data gathered by the checks.
		For example, the 'Path' data source that comes with the module (and is the default source) will store the data in file.
		This command makes the actual backend freely extensible.
	
	.PARAMETER Name
		The name of the source. Must be unique, otherwise the previous data source will be overwritten,
	
	.PARAMETER Description
		A description of the data source.
	
	.PARAMETER ImportScript
		The scriptblock to execute to read data from the source.
	
	.PARAMETER ExportScript
		The scriptblock to execute to write data to the source.
	
	.EXAMPLE
		PS C:\> Register-MonDataSource -Name 'Path' -Description 'Uses the filesystem as data backend for monitoring data' -ImportScript $ImportScript -ExportScript $ExportScript
	
		Registers the "Path" data source.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name,
		
		[Parameter(Mandatory = $true)]
		[string]
		$Description,
		
		[Parameter(Mandatory = $true)]
		[scriptblock]
		$ImportScript,
		
		[Parameter(Mandatory = $true)]
		[scriptblock]
		$ExportScript
	)
	process
	{
		$script:dataSources[$Name] = @{
			Name		 = $Name
			Description  = $Description
			ImportScript = $ImportScript
			ExportScript = $ExportScript
		}
	}
}