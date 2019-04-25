function Remove-MonTarget
{
<#
	.SYNOPSIS
		Deletes a target.
	
	.DESCRIPTION
		Deletes a target.
		This will purge all configuration data from memory and file.
		Optionally, the data gathered from checks can be retained.
	
	.PARAMETER Name
		Name of the target to purge.
	
	.PARAMETER KeepData
		By default, all data pertaining a given target will be purged as well.
		Using this switch disables that behavior.
	
	.EXAMPLE
		PS C:\> Remove-MonTarget -Name 'server.contoso.com'
	
		Removes the target named server.contoso.com
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[string[]]
		$Name,
		
		[switch]
		$KeepData
	)
	
	process
	{
		foreach ($nameItem in $Name)
		{
			Import-Config -TargetName $nameItem
			if (-not $script:configuration[$nameItem])
			{
				Write-Error "Unable to find target $nameItem"
				continue
			}
			$script:configuration.Remove($nameItem)
			if ($script:limits.ContainsKey($nameItem)) { $script:limits.Remove($nameItem) }
			Export-Config -TargetName $nameItem
			
			Import-Data -TargetName $nameItem
			if (-not $KeepData -and $script:data[$nameItem])
			{
				$script:data.Remove($nameItem)
				Export-Data -TargetName $nameItem
			}
		}
	}
}
