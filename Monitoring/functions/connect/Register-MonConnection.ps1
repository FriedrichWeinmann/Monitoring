function Register-MonConnection
{
<#
	.SYNOPSIS
		Registers logic that connects to targets.
	
	.DESCRIPTION
		Registers logic that connects to targets.
		Use this to add capabilities to the module, that can then be used to connect to a target and be leveraged by checks.
	
	.PARAMETER Capability
		The name to assign to the capability.
	
	.PARAMETER ConnectionScript
		The script to connect to a target.
		Only receives the name of the target as argument.
		Must return a hashtable, either with a unique name and the connection object, or an empty hashtable.
		The hashtable may contain more than one entry and will be merged with other entires, if a target supports multiple capabilities.
	
	.PARAMETER DisconnectionScript
		The script to disconnect from a target.
		Receives two arguments:
		- A hashtable of connections
		- The name of the target
		The hastable in question contains ALL connections from all capabilities applicable to the target.
	
	.EXAMPLE
		PS C:\> Register-MonConnection -Capability 'WinRM' -ConnectionScript $connect -DisconnectionScript $disconnect
	
		Registers the WinRM capability with logic to connect and logic to disconnect.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Capability,
		
		[Parameter(Mandatory = $true)]
		[System.Management.Automation.ScriptBlock]
		$ConnectionScript,
		
		[System.Management.Automation.ScriptBlock]
		$DisconnectionScript = { }
	)
	
	process
	{
		$script:connectionTypes[$Capability] = @{
			Name = $Capability
			Connect = $ConnectionScript
			Disconnect = $DisconnectionScript
		}
	}
}
