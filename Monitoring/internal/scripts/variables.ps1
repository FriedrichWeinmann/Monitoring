#if (-not (Test-Path -Path $script:pathConfiguration)) { New-Item -Path $script:pathConfiguration -ItemType Directory -Force }

#region Data & Config
# DATA: Stores the data actually present on each target for each applicable check
$script:data = @{
	<#
		TargetName = @{
			CheckName = @{
				Timestamp = $null
				Result = $null
				Message = ""
			}
		}
	#>
}

# CONFIG: Stores configuration data, specifically that relating to targets
$script:configuration = @{
<#
	TargetName = @{
		Name = 'TargetName'
		Tag = 'tag1','tag2'
		Capability = 'WinRM'
	}
#>
}

# CONFIG: Stores the limits specified by the monitoring system.
$script:limits = @{
	<#
	TargetName = @{
		CheckName = @{
			TargetName = 'TargetName'
			CheckName = 'CheckName'
			AlarmLimit = $null
			WarningLimit = $null
			Operator = 'GreaterThan|GreaterEqual|Equal|NotEqual|LesserEqual|LesserThan|Like|NotLike|Match|NotMatch'
		}
	}
	#>
}
#endregion Data & Config

#region Runtime
# RUNTIME : Stores the registered config source configuration
$script:configSources = @{
	<#
	SourceName = @{
		Name = 'SourceName'
		ImportScript = { ... }
		ExportScript = { ... }
	}
	#>
}

# RUNTIME : Stores the registered data source configuration
$script:dataSources = @{
	<#
	SourceName = @{
		Name = 'SourceName'
		ImportScript = { ... }
		ExportScript = { ... }
	}
	#>
}

# RUNTIME : Stores the various checks that have been registered
$script:checks = @{
	<#
	CheckName = @{
		Name = 'CheckName'
		Tag = 'tag1'
		Check = { ... }
	}
	#>
}

# RUNTIME: Stores registered connection types
$script:connectionTypes = @{
	<#
	CapabilityName = @{
		Name = 'CapabilityName'
		Connect = { ... }
		Disconnect = { ... }
	}
	#>
}
#endregion Runtime

$script:triedAutoImport = $false