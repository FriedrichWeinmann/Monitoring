function Get-MonLimit
{
<#
	.SYNOPSIS
		Returns registered check limits.
	
	.DESCRIPTION
		Returns registered check limits.
	
	.PARAMETER TargetName
		The name of the target for which to check limits.
	
	.PARAMETER CheckName
		The name of the check to look for.
	
	.EXAMPLE
		PS C:\> Get-MonLimit
	
		Returns all limits registered.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "")]
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('Name')]
		[string[]]
		$TargetName = "*",
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string[]]
		$CheckName = '*'
	)
	
	begin
	{
		Import-Config
	}
	process
	{
		foreach ($targetItem in (Get-MonTarget -Name $TargetName))
		{
			$script:Limits.$($targetItem.Name).Values | Where-Object { Test-Overlap -ReferenceObject $_.CheckName -DifferenceObject $CheckName -Operator Like } | ForEach-Object {
				$clonedTable = $_.Clone()
				$clonedTable['PSTypeName'] = 'Monitoring.Limit'
				[pscustomobject]$clonedTable
			}
		}
	}
}
