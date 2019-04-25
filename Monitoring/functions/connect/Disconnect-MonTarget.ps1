function Disconnect-MonTarget
{
<#
	.SYNOPSIS
		Disconnects all sessions for a given target.
	
	.DESCRIPTION
		Disconnects all sessions for a given target.
	
	.PARAMETER Capability
		The capability for which to cancel the connection.
	
	.PARAMETER Connection
		The hashtable of connections generated from Connect-MonTarget
	
	.PARAMETER TargetName
		The target to disconnect from.
	
	.EXAMPLE
		PS C:\> Disconnect-MonTarget -Capability 'WinRM' -Connection $Connection -TargetName server.contoso.com
	
		Disconnects all WinRM related sessions for server.contoso.com
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Capability,
		
		[Parameter(Mandatory = $true)]
		$Connection,
		
		[string]
		$TargetName
	)
	
	process
	{
		if (-not $script:connectionTypes.ContainsKey($Capability))
		{
			Write-Error "Connection Type: $Capability not found!"
			return
		}
		
		try { $script:connectionTypes[$Capability].Disconnect.Invoke($Connection, $TargetName) }
		catch
		{
			Write-Error "Failed to disconnect from $Capability : $_"
			return
		}
	}
}