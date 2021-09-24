function Get-MonConnection
{
<#
	.SYNOPSIS
		Returns registered connections based on capability.
	
	.DESCRIPTION
		Returns registered connections based on capability.
	
	.PARAMETER Capability
		The capability for which to look for connections.
	
	.EXAMPLE
		PS C:\> Get-MonConnection -Capability WinRM
	
		Returns the registered connection logic for connecting via WinRM
#>
	[CmdletBinding()]
	param (
		[string[]]
		$Capability
	)
	
	process
	{
		if (-not $Capability) {
			foreach ($key in $script:connectionTypes.Keys) {
				[pscustomobject]@{
					PSTypeName = 'Monitoring.Connection'
					Name	   = $key
					Connection = $script:connectionTypes[$key]
				}
			}
			return
		}
		foreach ($capabilityItem in $Capability)
		{
			if (-not $script:connectionTypes[$capabilityItem])
			{
				Write-Error "Connection Capability $capabilityItem has no matching connection script!"
				continue
			}
			
			[pscustomobject]@{
				PSTypeName = 'Monitoring.Connection'
				Name	   = $capabilityItem
				Connection = $script:connectionTypes[$capabilityItem]
			}
		}
	}
}
