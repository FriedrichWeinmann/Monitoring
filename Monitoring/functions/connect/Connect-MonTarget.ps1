function Connect-MonTarget
{
<#
	.SYNOPSIS
		Establish a connection to the specified target.
	
	.DESCRIPTION
		Establish a connection to the specified target.
		All configured capabilities will be considered.
	
	.PARAMETER Name
		The name of the target to connect to.
	
	.EXAMPLE
		PS C:\> Connect-MonTarget -Name server.contoso.com
	
		Establishes a connection to server.contoso.com
#>
	[OutputType([Hashtable])]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name
	)
	
	begin
	{
		$target = Get-MonTarget -Name $Name
	}
	process
	{
		[hashtable]$connections = @{ }
		foreach ($capability in $target.Capability)
		{
			if (-not $script:connectionTypes.ContainsKey($capability))
			{
				Write-Error "Connection Type: $capability not found!"
				continue
			}
			
			try
			{
				$tempResult = $script:connectionTypes[$capability].Connect.Invoke($Name) | Select-Object -First 1
				foreach ($key in $tempResult.Keys) { $connections[$key] = $tempResult[$key] }
			}
			catch
			{
				Write-Error "Failed to connect to $Name via $capability : $_"
				continue
			}
		}
		$connections
	}
}
