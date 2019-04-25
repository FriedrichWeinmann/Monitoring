function Get-MonCheck
{
<#
	.SYNOPSIS
		Returns registered checks.
	
	.DESCRIPTION
		Returns registered checks.
	
	.PARAMETER Tag
		The tag to filter by.
	
	.PARAMETER Name
		The name to filter by
	
	.EXAMPLE
		PS C:\> Get-MonCheck
	
		Returns all registered checks.
#>
	[CmdletBinding()]
	Param (
		[string[]]
		$Tag = '*',
		
		[string[]]
		$Name = '*'
	)
	
	process
	{
		$checks = foreach ($checkItem in $script:checks.Values)
		{
			#region Filter by Name
			$foundName = $false
			foreach ($nameItem in $Name)
			{
				if ($checkItem.Name -like $nameItem)
				{
					$foundName = $true
					break
				}
			}
			if (-not $foundName) { continue }
			#endregion Filter by Name
			
			#region Filter by Tag
			$foundTag = $false
			foreach ($tagItem in $Tag)
			{
				if ($checkItem.Tag -like $tagItem)
				{
					$foundTag = $true
					break
				}
			}
			if (-not $foundTag) { continue }
			#endregion Filter by Tag
			
			$clonedCheck = $checkItem.Clone()
			$clonedCheck['PSTypeName'] = 'Monitoring.Check'
			
			[PSCustomObject]$clonedCheck
		}
		$checks | Sort-Object Name
	}
}
