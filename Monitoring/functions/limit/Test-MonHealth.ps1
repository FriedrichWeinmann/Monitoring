function Test-MonHealth
{
<#
	.SYNOPSIS
		Returns cached data and compares it with configured alert limits (if present).
	
	.DESCRIPTION
		Returns cached data and compares it with configured alert limits (if present).
	
	.PARAMETER TargetName
		Filter by target.
	
	.PARAMETER Tag
		Filter by assigned tag to that target.
	
	.PARAMETER CheckName
		Filter by applied check.
	
	.EXAMPLE
		PS C:\> Test-MonHealth
	
		Returns all scanend data for all targets and all checks.
#>
	[CmdletBinding()]
	param (
		[string[]]
		$TargetName = '*',
		
		[string[]]
		$Tag = '*',
		
		[string[]]
		$CheckName = '*'
	)
	
	begin
	{
		#region Utility Function
		function Add-Result
		{
			[CmdletBinding()]
			param (
				[string]
				$Name,
				
				$Data,
				
				[hashtable]
				$Result,
				
				[string]
				$CheckName,
				
				[string]
				$TargetName,
				
				$WarningLimit,
				
				$ErrorLimit,
				
				[string]
				$Operator,
				
				[switch]
				$Finalize
			)
			
			#region Finalize and return objects
			if ($Finalize)
			{
				foreach ($resultItem in $Result.Values)
				{
					#region Case: No data gathered yet
					if (-not $resultItem.Timestamp)
					{
						$resultItem.Status = 'Error'
						$resultItem
						continue
					}
					#endregion Case: No data gathered yet
					
					#region Case: Stale Data
					if ($resultItem.Timestamp.Add((Get-PSFConfigValue -FullName 'Monitoring.Data.StaleTimeout')) -lt (Get-Date))
					{
						$resultItem.Status = 'Error'
						$resultItem
						continue
					}
					#endregion Case: Stale Data
					
					#region Case: Valid Data
					switch ($resultItem.Operator)
					{
						'GreaterThan'
						{
							if ($resultItem.Value -gt $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -gt $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'GreaterEqual'
						{
							if ($resultItem.Value -ge $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -ge $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'Equal'
						{
							if ($resultItem.Value -eq $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -eq $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'NotEqual'
						{
							if ($resultItem.Value -ne $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -ne $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'LessEqual'
						{
							if ($resultItem.Value -le $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -le $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'LessThan'
						{
							if ($resultItem.Value -lt $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -lt $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'Like'
						{
							if ($resultItem.Value -like $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -like $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'NotLike'
						{
							if ($resultItem.Value -notlike $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -notlike $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'Match'
						{
							if ($resultItem.Value -match $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -match $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						'NotMatch'
						{
							if ($resultItem.Value -notmatch $resultItem.WarningLimit) { $resultItem.Status = 'Warning' }
							if ($resultItem.Value -notmatch $resultItem.AlarmLimit) { $resultItem.Status = 'Error' }
							break
						}
						default
						{
							$resultItem.Status = 'No Limit'
						}
					}
					$resultItem
					#endregion Case: Valid Data
				}
			}
			#endregion Finalize and return objects
			
			if (-not $Result[$Name])
			{
				$Result[$Name] = [pscustomobject]@{
					PSTypeName = 'Monitoring.HealthResult'
					Target	   = $TargetName
					Check	   = $CheckName
					Value	   = $Data.Result
					Timestamp  = $Data.Timestamp
					Message    = $Data.Message
					WarningLimit = $WarningLimit
					ErrorLimit = $ErrorLimit
					Operator   = $Operator
					Status	   = 'Healthy'
				}
			}
			else
			{
				# Can only happen when processing limits that have matching data
				$Result[$Name].WarningLimit = $WarningLimit
				$Result[$Name].ErrorLimit = $ErrorLimit
				$Result[$Name].Operator = $Operator
			}
		}
		#endregion Utility Function
		
		Import-Config
	}
	process
	{
		foreach ($targetItem in (Get-MonTarget -Name $TargetName -Tag $Tag))
		{
			Import-Data -TargetName $targetItem
			$result = @{ }
			
			foreach ($key in $script:data[$targetItem.Name].Keys)
			{
				if (-not (Test-Overlap -ReferenceObject $key -DifferenceObject $CheckName -Operator Like)) { continue }
				Add-Result -Name $key -Data $script:data[$targetItem.Name][$key] -Result $result -CheckName $key -TargetName $targetItem.Name
			}
			
			foreach ($limitItem in $script:limits[$targetItem.Name].Values)
			{
				if (-not (Test-Overlap -ReferenceObject $limitItem.CheckName -DifferenceObject $CheckName -Operator Like)) { continue }
				$paramAddResult = @{
					Name = $limitItem.CheckName
					Result = $result
					CheckName = $key
					TargetName = $targetItem.Name
					WarningLimit = $limitItem.WarningLimit
					ErrorLimit = $limitItem.ErrorLimit
					Operator = $limitItem.Operator
				}
				Add-Result @paramAddResult
			}
			Add-Result -Result $result -Finalize
		}
	}
}
