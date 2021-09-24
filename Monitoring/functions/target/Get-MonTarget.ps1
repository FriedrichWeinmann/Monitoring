function Get-MonTarget
{
<#
	.SYNOPSIS
		Returns registered monitoring targets.
	
	.DESCRIPTION
		Returns registered monitoring targets.
	
	.PARAMETER Name
		The name of the target.
	
	.PARAMETER Tag
		The tags the tartget should have.
	
	.EXAMPLE
		PS C:\> Get-MonTarget
	
		Returns all targets
#>
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[string[]]
		$Name = "*",
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string[]]
		$Tag = "*"
	)
	
	process
	{
		foreach ($targetItem in $script:configuration.Values)
		{
			$clonedItem = $targetItem.Clone()
			#region Filter by Name
			$foundName = $false
			foreach ($nameItem in $Name)
			{
				if ($clonedItem.Name -like $nameItem)
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
				if ($clonedItem.Tag -like $tagItem)
				{
					$foundTag = $true
					break
				}
			}
			if (-not $foundTag -and ($Tag -notcontains '*')) { continue }
			#endregion Filter by Tag
			
			$clonedItem['PSTypeName'] = 'Monitoring.Target'
			[pscustomobject]$clonedItem
		}
	}
}
