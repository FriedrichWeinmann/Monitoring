#region Configurations
$basePath = Join-PSFPath $env:APPDATA 'WindowsPowerShell' 'Monitoring'
if (Test-PSFPowerShell -Elevated) { $basePath = Join-PSFPath $env:ProgramData 'WindowsPowerShell' 'Monitoring' }
Set-PSFConfig -Module 'Monitoring' -Name 'Source.Path.Config' -Value (Join-Path -Path $basePath -ChildPath Config) -Initialize -Validation 'string' -Description 'The path where the "Path" data source stores its configuration data.'
#endregion Configurations

#region Create Configuration Source
$scriptblockImport = {
	param (
		[string]
		$Type,
		
		[string]
		$TargetName
	)
	
	#region Import Targets
	if ($Type -match '^All$|^Target$')
	{
		foreach ($fileItem in (Get-Item "$(Get-PSFConfigValue -FullName 'Monitoring.Source.Path.Config')\*.target"))
		{
			$baseName = $fileItem.BaseName | ConvertFrom-Base64
			
			if (-not (($baseName -eq $TargetName) -or ($baseName -like $TargetName))) { continue }
			
			$data = Import-PSFClixml -Path $fileItem.FullName
			$script:configuration[$data.Target] = $data.Value
		}
	}
	#endregion Import Targets
	
	#region Import Limits
	if ($Type -match '^All$|^Limit$')
	{
		foreach ($fileItem in (Get-Item "$(Get-PSFConfigValue -FullName 'Monitoring.Source.Path.Config')\*.limit"))
		{
			$baseName = $fileItem.BaseName | ConvertFrom-Base64
			
			if (-not (($baseName -eq $TargetName) -or ($baseName -like $TargetName))) { continue }
			
			$data = Import-PSFClixml -Path $fileItem.FullName
			$script:limits[$data.Target] = $data.Value
		}
	}
	#endregion Import Limits
}
$scriptblockExport = {
	param (
		[string]
		$Type,
		
		[string]
		$TargetName
	)
	
	$pathConfiguration = Get-PSFConfigValue -FullName 'Monitoring.Source.Path.Config'
	
	#region Export Targets
	if ($Type -match '^All$|^Target$')
	{
		$wasFound = $false
		foreach ($key in $script:configuration.Keys)
		{
			if (-not (($key -eq $TargetName) -or ($key -like $TargetName))) { continue }
			if ($key -eq $TargetName) { $wasFound = $true }
			
			$object = [pscustomobject]@{
				Target   = $key
				Value    = $script:configuration[$key]
			}
			$object | Export-PSFClixml -Path (Join-Path -Path $pathConfiguration -ChildPath "$($key | ConvertTo-Base64).target") -Depth 5
		}
		
		# Delete logic. Applies when using Remove-MonTarget
		if ((-not $wasFound) -and (Test-Path (Join-Path -Path $pathConfiguration -ChildPath "$($TargetName | ConvertTo-Base64).target")))
		{
			Remove-Item -Path (Join-Path -Path $pathConfiguration -ChildPath "$($TargetName | ConvertTo-Base64).target") -Force
		}
	}
	#endregion Export Targets
	
	#region Export Limits
	if ($Type -match '^All$|^Limit$')
	{
		$wasFound = $false
		foreach ($key in $script:limits.Keys)
		{
			if (-not (($key -eq $TargetName) -or ($key -like $TargetName))) { continue }
			if ($key -eq $TargetName) { $wasFound = $true }
			
			$object = [pscustomobject]@{
				Target   = $key
				Value    = $script:limits[$key]
			}
			$object | Export-PSFClixml -Path (Join-Path -Path $pathConfiguration -ChildPath "$($key | ConvertTo-Base64).limit") -Depth 5
		}
		
		# Delete logic. Applies when using Remove-MonTarget
		if ((-not $wasFound) -and (Test-Path (Join-Path -Path $pathConfiguration -ChildPath "$($TargetName | ConvertTo-Base64).limit")))
		{
			Remove-Item -Path (Join-Path -Path $pathConfiguration -ChildPath "$($TargetName | ConvertTo-Base64).limit") -Force
		}
	}
	#endregion Export Limits
}
$paramRegisterMonConfigSource = @{
	Name		 = 'Path'
	Description  = 'Uses the filesystem as data backend for monitoring configuration'
	ImportScript = $scriptblockImport
	ExportScript = $scriptblockExport
}
Register-MonConfigSource @paramRegisterMonConfigSource
#endregion Create Configuration Source

#region Ensure Path Exists
$pathConfigCache = Get-PSFConfigValue -FullName 'Monitoring.Source.Path.Config'
if (-not (Test-Path -Path $pathConfigCache))
{
	$null = New-Item -Path $pathConfigCache -ItemType Directory -Force
}
#endregion Ensure Path Exists