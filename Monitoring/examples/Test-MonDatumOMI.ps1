function Test-MonDatumOMI
{
<#
	.SYNOPSIS
		Data retrieval for integration into OMI
	
	.DESCRIPTION
		Data retrieval for integration into OMI
	
	.PARAMETER TargetName
		The name of the target to retrieve a data point for.
	
	.PARAMETER CheckName
		The name of the check to retrieve a data point for.
	
	.PARAMETER SensorID
		The ID of the Sensor as OMI sees it (required for the return data command)
	
	.PARAMETER AlertValue
		The threshold that constitutes an alert.
	
	.PARAMETER Operator
		What operator to apply to the threshold.
		For example, a combination of "80" and "GreaterThan" means any result greater than 80 should be considered an error.
	
	.EXAMPLE
		PS C:\> Test-MonDatumOMI -TargetName 'server.contoso.com' -CheckName 'NTDS.DBDiskFreeSpacePercent' -SensorID 'server\NTDSDisk' -AlertValue 20
	
		Checks the data cached for the specified target/check combination and reports it to the OMI monitoring system.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$TargetName,
		
		[Parameter(Mandatory = $true)]
		[string]
		$CheckName,
		
		[string]
		$SensorID,
		
		$AlertValue,
		
		[ValidateSet('GreaterThan', 'GreaterEqual', 'Equal', 'NotEqual', 'LessEqual', 'LessThan', 'Like', 'NotLike', 'Match', 'NotMatch')]
		[string]
		$Operator = 'LessThan'
	)
	
	begin
	{
		if ($PSBoundParameters.ContainsKey('AlertValue'))
		{
			Set-MonLimit -TargetName $TargetName -CheckName $CheckName -ErrorLimit $AlertValue -Operator $Operator
		}
	}
	process
	{
		$result = Get-MonDatum -TargetName $TargetName -CheckName $CheckName
		
		# Case: No Data
		if ($result.Message -eq "No Data")
		{
			Write-PSFMessage -Level Host -Message "No Data Found"
		}
		# Case: Something went wrong when gathering data
		elseif ($result.Message)
		{
			Write-PSFMessage -Level Host -Message "Error happened: $($result.Message)"
		}
		# Case: Got Data
		else
		{
			if ($result.Timestamp.Add((Get-PSFConfigValue -FullName 'Monitoring.Data.StaleTimeout')) -lt (Get-Date))
			{
				Write-PSFMessage -Level Host -Message "Got Data, but is stale: $($result.Result)"
			}
			else { Write-PSFMessage -Level Host -Message "Got Data: $($result.Result)" }
		}
	}
}
