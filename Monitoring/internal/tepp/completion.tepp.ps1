Register-PSFTeppScriptblock -Name Monitoring.Tags -ScriptBlock {
	(Get-MonCheck).Tag, (Get-MonTarget).Tag | Remove-PSFNUll -Enumerate | Select-Object -Unique | Sort-Object
}

Register-PSFTeppScriptblock -Name Monitoring.Target -ScriptBlock {
	(Get-MonTarget).Name
}

Register-PSFTeppScriptblock -Name Monitoring.Check -ScriptBlock {
	if ($fakeBoundParameter.TargetName)
	{
		$targetTags = (Get-MonTarget -Name $fakeBoundParameter.TargetName).Tag
		if ($targetTags) { return (Get-MonCheck -Tag $targetTags).Name }
	}
	(Get-MonCheck).Name
}

Register-PSFTeppScriptblock -Name Monitoring.Connection -ScriptBlock {
	(Get-MonConnection).Name
}