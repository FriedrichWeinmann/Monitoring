# List of forbidden commands
$global:BannedCommands = @(
	'Write-Host',
	'Write-Verbose',
	'Write-Warning',
	'Write-Error',
	'Write-Output',
	'Write-Information',
	'Write-Debug',
	
	# Use CIM instead where possible
	'Get-WmiObject',
	'Invoke-WmiMethod',
	'Register-WmiEvent',
	'Remove-WmiObject',
	'Set-WmiInstance'
)

<#
	Contains list of exceptions for banned cmdlets.
	Insert the file names of files that may contain them.
	
	Example:
	"Write-Host"  = @('Write-PSFHostColor.ps1','Write-PSFMessage.ps1')
#>
$global:MayContainCommand = @{
	"Write-Host"  = @('Test-MonDatumOMI.ps1')
	"Write-Verbose" = @()
	"Write-Warning" = @('Receive-Workload.ps1')
	"Write-Error"  = @('Connect-MonTarget.ps1', 'Disconnect-MonTarget.ps1', 'Get-MonConnection.ps1', 'Remove-MonTarget.ps1', 'Receive-Workload.ps1')
	"Write-Output" = @('Add-Workload.ps1')
	"Write-Information" = @()
	"Write-Debug" = @()
}