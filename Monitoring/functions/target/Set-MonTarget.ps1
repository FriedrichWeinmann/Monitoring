function Set-MonTarget
{
<#
	.SYNOPSIS
		Register a monitoring target.
	
	.DESCRIPTION
		Register a monitoring target.
		This is used for updating and maintaining a target system.
	
	.PARAMETER Name
		What to target the monitoring subject by.
		A unique label used to identify the resource.
		For computer management, this could be a DNS name.
		For monitoring SQL instances a connection string or instance name.
	
	.PARAMETER Tag
		What tag to assign to the target.
		Tags are monitoring groups. Checks are assigned to tags.
		For example, all checks assigned the tag 'DC' are applied to targets also tagged as 'DC'.
		At the same time, a target could also have the tag 'Server' and thus be subject to checks assigned to that tag.
		Assignments of tags are cummulative - applying new tags adds them to the object.
	
	.PARAMETER Capability
		Capabilities are used to determine what kind of connections can be established to this target.
		For example, adding a WinRM capability would tell the system the target can accept PowerShell Remoting and CIM over WinRM connections.
		Add supported capabilities by using the Register-MonConnection.
		Assignments of capabilities are cummulative - applying new capabilities adds them to the object.

	.PARAMETER RemoveTag
		Remove a tag from the specified target.

	.PARAMETER RemoveCapability
		Remvoe a connection capability from the specified target.
	
	.EXAMPLE
		PS C:\> Set-MonTarget -Name 'server1.contoso.com' -Tag 'server', 'dc', 'server2019' -Capability WinRM, ldap
	
		Configures the server 'server1.contoso.com' as server, server2019 and dc.
		It also configures it to accept WinRM and ldap connections.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectUsageOfAssignmentOperator", "")]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[string[]]
		$Name,
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string[]]
		$Tag,
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidateSet(TabCompletion = 'Monitoring.Connection')]
		[PsfArgumentCompleter('Monitoring.Connection')]
		[string[]]
		$Capability,

		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string[]]
		$RemoveTag,

		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidateSet(TabCompletion = 'Monitoring.Connection')]
		[PsfArgumentCompleter('Monitoring.Connection')]
		[string[]]
		$RemoveCapability
	)
	
	process
	{
		foreach ($nameItem in $Name)
		{
			Import-Config -TargetName $nameItem
			#region Add to existing target
			if ($target = $script:configuration[$nameItem])
			{
				foreach ($tagItem in $Tag)
				{
					if ($target.Tag -notcontains $tagItem)
					{
						$target.Tag = $target.Tag + $tagItem
					}
				}
				foreach ($capabilityItem in $Capability)
				{
					if ($target.Capability -notcontains $capabilityItem)
					{
						$target.Capability = $target.Capability + $capabilityItem
					}
				}
				foreach ($tagItem in $RemoveTag)
				{
					$target.Tag = @(($target.Tag | Where-Object {$_ -ne $tagItem }))
				}
				foreach ($capabilityItem in $RemoveCapability)
				{
					$target.Capability = @(($target.Capability | Where-Object {$_ -ne $capabilityItem }))
				}
			}
			#endregion Add to existing target
			
			#region Create new target
			else
			{
				$script:configuration[$nameItem] = @{
					Name	   = $nameItem
					Tag	       = @($Tag)
					Capability = @($Capability)
				}
			}
			#endregion Create new target
			Export-Config -TargetName $nameItem
		}
	}
}
