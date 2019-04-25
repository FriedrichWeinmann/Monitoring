function Register-MonCheck
{
<#
	.SYNOPSIS
		Register the logic used to scan a target for a given point of information.
	
	.DESCRIPTION
		Register a scriptblock that will be used to gather a piece of information from the target.
		This scriptblock will receive two arguments:
		- The name of the target
		- A hashtable of connections (as registered using Register-MonConnection and applied to the target by its Capability property)
	
	.PARAMETER Name
		The name of the check to register.
		Must be unique or it will overwrite the other check.
	
	.PARAMETER Check
		The logic to execute.
		This scriptblock will receive two arguments:
		- The name of the target
		- A hashtable of connections (as registered using Register-MonConnection and applied to the target by its Capability property)
	
	.PARAMETER Tag
		The tags this check applies to.
		Tags are arbitrary labels that group monitoring targets.
		A target has one or more tags, and all checks with a matching tag are applied to the target.
	
	.PARAMETER Description
		Adds a description to the check, explaining what this check does and requires.
	
	.PARAMETER Module
		The Management Pack Module that introduced the check.
	
	.PARAMETER RecommendedLimit
		Adds a recommended limit to the check.
		This is intended to offer the opportunity to give a sane default setting.
	
		Caveat:
		Under no circumstances is this an assumption that this limit is a good fit for every environment.
		Consider this a starting point if you are unsure, what your actual limits should be like.
	
	.PARAMETER RecommendedLimitOperator
		The operator to apply to the recommended limit.
		See the caveat on the parameter help for RecommendedLimit.
	
	.EXAMPLE
		PS C:\> Register-MonCheck -Name 'NTDS_DB_FreeDiskPercent' -Check $checkScript -Tag 'dc' -Description 'Returns the percent of free space on the disk hosting the NTDS Database.'
		
		Registers the logic stored in the $checkScript variable under the name 'NTDS_DB_FreeDiskPercent' and assigns it to the 'dc' label.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[string]
		$Name,
		
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[System.Management.Automation.ScriptBlock]
		$Check,
		
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[string[]]
		$Tag,
		
		[string]
		$Description,
		
		[string]
		$Module,
		
		[object]
		$RecommendedLimit,
		
		[Monitoring.LimitOperator]
		$RecommendedLimitOperator = 'LessThan'
	)
	
	process
	{
		$script:checks[$Name] = @{
			Name					 = $Name
			Tag					     = $Tag
			Check				     = $Check
			Description			     = $Description
			Module				     = $Module
			RecommendedLimit		 = $RecommendedLimit
			RecommendedLimitOperator = $RecommendedLimitOperator
		}
	}
}