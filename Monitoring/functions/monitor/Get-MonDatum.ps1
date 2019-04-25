function Get-MonDatum
{
<#
	.SYNOPSIS
		Returns information on a single piece of scanned data.
	
	.DESCRIPTION
		Returns information on a single piece of scanned data.
	
		Returns an object with three properties:
		- Timestamp (When was the data last retrieved)
		- Result (What data was retrieved)
		- Message (Any error message)
		Any content in Message implies a failed result.
		If no data was found for the specified combination of target and check, the message property will list "No Data".
	
	.PARAMETER TargetName
		The name of the target to retrive data for.
		No wildcards.
	
	.PARAMETER CheckName
		The name of the check to retrive data for.
		No wildcards.
	
	.EXAMPLE
		PS C:\> Get-MonDatum -TargetName sever.contoso.com -CheckName NTDS.DBDiskFreeSpacePercent
	
		Returns the check result of NTDS.DBDiskFreeSpacePercent for sever.contoso.com
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$TargetName,
		
		[Parameter(Mandatory = $true)]
		[string]
		$CheckName
	)
	
	begin
	{
		Import-Data -TargetName $TargetName
	}
	process
	{
		$datum = $script:data.$TargetName.$CheckName
		
		if ($datum)
		{
			$clonedDatum = $datum.Clone()
			$clonedDatum['PSTypeName'] = 'Monitoring.Datum'
			[pscustomobject]$clonedDatum
		}
		else
		{
			[pscustomobject]@{
				PSTypeName = 'Monitoring.Datum'
				Timestamp = $null
				Result    = $null
				Message   = 'No Data'
			}
		}
	}
}
