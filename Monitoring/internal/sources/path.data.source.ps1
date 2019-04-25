#region Configurations
$basePath = Join-PSFPath $env:APPDATA 'WindowsPowerShell' 'Monitoring'
if (Test-PSFPowerShell -Elevated) { $basePath = Join-PSFPath $env:ProgramData 'WindowsPowerShell' 'Monitoring' }
Set-PSFConfig -Module 'Monitoring' -Name 'Source.Path.Data' -Value (Join-Path -Path $basePath -ChildPath Data) -Initialize -Validation 'string' -Description 'The path where the "Path" data source stores its scan content.'
#endregion Configurations

#region Create Data Source
$scriptblockImport = {
	param (
		[string]
		$TargetName = '*'
	)
	
	$wasFound = $false
	foreach ($fileItem in (Get-ChildItem -Path (Get-PSFConfigValue -FullName 'Monitoring.Source.Path.Data') -File))
	{
		$baseName = $fileItem.BaseName | ConvertFrom-Base64
		
		if ($baseName -eq $TargetName) { $wasFound = $true }
		if (($baseName -eq $TargetName) -or ($baseName -like $TargetName))
		{
			$importedData = Import-PSFClixml -Path $fileItem.FullName
			$script:data[$importedData.Target] = $importedData.Content
		}
	}
	if (-not $TargetName.Contains("*") -and -not $wasFound)
	{
		$script:data[$TargetName] = @{ }
	}
}
$scriptblockExport = {
	param (
		[string]
		$TargetName = '*'
	)
	
	$pathDataCache = Get-PSFConfigValue -FullName 'Monitoring.Source.Path.Data'
	$wasFound = $false
	
	foreach ($key in $script:data.Keys)
	{
		if (($key -ne $TargetName) -and ($key -notlike $TargetName)) { continue }
		if ($key -eq $TargetName) { $wasFound = $true }
		
		$object = [pscustomobject]@{
			Target   = $key
			Content  = $script:data[$key]
		}
		$object | Export-PSFClixml -Path (Join-Path -Path $pathDataCache -ChildPath ($key | ConvertTo-Base64)) -Depth 5
	}
	
	# Delete logic. Applies when using Remove-MonTarget
	if ((-not $wasFound) -and (Test-Path (Join-Path -Path $pathDataCache -ChildPath ($TargetName | ConvertTo-Base64))))
	{
		Remove-Item -Path (Join-Path -Path $pathDataCache -ChildPath ($TargetName | ConvertTo-Base64)) -Force
	}
}
$paramRegisterMonDataSource = @{
	Name		 = 'Path'
	Description  = 'Uses the filesystem as data backend for monitoring data'
	ImportScript = $scriptblockImport
	ExportScript = $scriptblockExport
}
Register-MonDataSource @paramRegisterMonDataSource
#endregion Create Data Source

#region Ensure Path Exists
$pathDataCache = Get-PSFConfigValue -FullName 'Monitoring.Source.Path.Data'
if (-not (Test-Path -Path $pathDataCache))
{
	$null = New-Item -Path $pathDataCache -ItemType Directory -Force
}
#endregion Ensure Path Exists