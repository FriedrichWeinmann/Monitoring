# This is where the strings go, that are written by
# Write-PSFMessage, Stop-PSFFunction or the PSFramework validation scriptblocks
@{
	# Module Import
	'Import.ManagementPack.Import'	      = 'Importing Management Pack Module: {0}'
	'Import.ManagementPack.Import.Failed' = 'Failed to import the Management Pack Module: {0}'
	
	# Import-Config
	'Import-Config.SourceNotFound'	      = 'The config source "{0}" could not be found. Configuration import failed critically.'
	
	# Import-Data
	'Import-Data.SourceNotFound'		  = 'The data source "{0}" could not be found. Data import failed critically.'
	
	# Receive-Workload
	'Receive-Workload.ConnectFailed'	  = 'Failed to connect to {0} : {1}'
	'Receive-Workload.CheckFailed'	      = 'Failed to check {0} on {1} : {2}'
	'Receive-Workload.RunspaceTimeout'    = 'Timeout: Gathering data from {0}'
}