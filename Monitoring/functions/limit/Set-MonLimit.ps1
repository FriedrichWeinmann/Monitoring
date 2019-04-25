function Set-MonLimit
{
<#
	.SYNOPSIS
		Applies a limit/threshold about what constitutes a warning/error.
	
	.DESCRIPTION
		Applies a limit/threshold about what constitutes a warning/error.
	
	.PARAMETER TargetName
		The name of the target to apply it to.
		The targets must already exist for this to be considered.
		By default, ALL targets are considered.
	
	.PARAMETER CheckName
		The check for which to apply a limit.
		The check does not have to exist before applying a limit.
	
	.PARAMETER ErrorLimit
		The threshold that needs to be crossed for the state to be considered in Error.
	
	.PARAMETER WarningLimit
		The threshold that needs to be crossed for the state to be considered in Warning.
	
	.PARAMETER Operator
		What operator to apply to the limit.
		For example, setting the Operator to 'GreaterThan' and the ErrorLimit to 80 would have all results greater than 80 be considered in error.
	
	.EXAMPLE
		PS C:\> Get-MonTarget -Tag DC | Set-MonLimit -CheckName 'LogDriveFreeSpacePercent' -ErrorLimit 10 -WarningLimit 20 -Operator LessThan
	
		Updates all targets of the type DC to new limit thresholds for the check LogDriveFreeSpacePercent:
		- Warning as soon as the result sinks below '20'
		- Error as soon as the result sinks below '10'
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('Name')]
		[string[]]
		$TargetName = "*",
		
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[string]
		$CheckName,
		
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[object]
		$ErrorLimit,
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[object]
		$WarningLimit,
		
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Monitoring.LimitOperator]
		[string]
		$Operator
	)
	
	process
	{
		foreach ($targetItem in (Get-MonTarget -Name $TargetName))
		{
			Import-Config -TargetName $targetItem.Name -Type Limit
			if (-not $script:limits[$targetItem.Name]) { $script:limits[$targetItem.Name] = @{ } }
			$script:limits[$targetItem.Name][$CheckName] = @{
				TargetName   = $targetItem.Name
				CheckName    = $CheckName
				ErrorLimit   = $ErrorLimit
				WarningLimit = $WarningLimit
				Operator	 = $Operator
			}
			Export-Config -TargetName $targetItem.Name -Type Limit
		}
	}
}
