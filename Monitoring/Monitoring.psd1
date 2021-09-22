@{
	# Script module or binary module file associated with this manifest
	RootModule = 'Monitoring.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.1'
	
	# ID used to uniquely identify this module
	GUID = '690f8e43-7a62-420c-b68c-659713e944e2'
	
	# Author of this module
	Author = 'Friedrich Weinmann'
	
	# Company or vendor of this module
	CompanyName = ''
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) 2019 Friedrich Weinmann'
	
	# Description of the functionality provided by this module
	Description = 'Module to implement a freely extensible monitoring data gathering framework'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName='PSFramework'; ModuleVersion= '1.6.205' }
	)
	
	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @('bin\Monitoring.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\Monitoring.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @('xml\Monitoring.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport  = @(
		'Connect-MonTarget'
		'Disconnect-MonTarget'
		'Get-MonCheck'
		'Get-MonConfigSource'
		'Get-MonConnection'
		'Get-MonDataSource'
		'Get-MonDatum'
		'Get-MonLimit'
		'Get-MonTarget'
		'Invoke-MonCheck'
		'Register-MonCheck'
		'Register-MonConfigSource'
		'Register-MonConnection'
		'Register-MonDataSource'
		'Remove-MonTarget'
		'Set-MonLimit'
		'Set-MonTarget'
		'Test-MonHealth'
	)
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('Monitoring')
			
			# A URL to the license for this module.
			LicenseUri = 'https://github.com/FriedrichWeinmann/Monitoring/blob/development/LICENSE'
			
			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/FriedrichWeinmann/Monitoring'
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			ReleaseNotes = 'https://github.com/FriedrichWeinmann/Monitoring/blob/development/Monitoring/changelog.md'
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}