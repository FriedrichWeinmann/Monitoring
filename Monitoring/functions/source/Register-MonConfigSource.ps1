function Register-MonConfigSource
{
<#
	.SYNOPSIS
		Registers a custom monitoring configuration source.
	
	.DESCRIPTION
		Registers a custom monitoring configuration source.
		Config sources are the configuration backend that define the data gathering behavior.
		This includes the targets to monitor and any limits to apply in scenarios where the limit configuration is stored in the module configuration itself.
		For example, the 'Path' config source that comes with the module (and is the default source) will store the configuration in file.
		This command makes the actual configuration management freely extensible.
	
	.PARAMETER Name
		The name of the source. Must be unique, otherwise the previous config source will be overwritten,
	
	.PARAMETER Description
		A description of the config source.
	
	.PARAMETER ImportScript
		The scriptblock to execute to read configuration from the source.
	
	.PARAMETER ExportScript
		The scriptblock to execute to write configuration to the source.
	
	.EXAMPLE
		PS C:\> Register-MonConfigSource -Name 'Path' -Description 'Uses the filesystem as data backend for monitoring configuration' -ImportScript $ImportScript -ExportScript $ExportScript
	
		Registers the "Path" config source.
#>
	[CmdletBinding()]
	Param (
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
		$script:configSources[$Name] = @{
			Name		 = $Name
			Description  = $Description
			ImportScript = $ImportScript
			ExportScript = $ExportScript
		}
	}
}