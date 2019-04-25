<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'Monitoring' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'Monitoring' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'Monitoring' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."

# Data Settings
Set-PSFConfig -Module 'Monitoring' -Name 'Data.StaleTimeout' -Value (New-TimeSpan -Minutes 30) -Initialize -Validation 'timespan' -Description "The time limit after which data is by default considered to be stale."

# Runspace Settings
Set-PSFConfig -Module 'Monitoring' -Name 'Runspace.MaxWorkerCount' -Value 32 -Initialize -Validation 'integer' -Description "The maximum number of targets that can be processed in parallel."
Set-PSFConfig -Module 'Monitoring' -Name 'Runspace.ExecutionTimeout' -Value (New-TimeSpan -Seconds 300) -Initialize -Validation 'timespan' -Description "The timeout of each worker runspace. If gathering data takes longer than this, data gathering is cancelled."

# Source Settings
Set-PSFConfig -Module 'Monitoring' -Name 'Source.Config.Active' -Value 'Path' -Initialize -Validation 'string' -Description 'Which data source is used for configuration storage and retrieval.'
Set-PSFConfig -Module 'Monitoring' -Name 'Source.Data.Active' -Value 'Path' -Initialize -Validation 'string' -Description 'Which data source is used for data storage and retrieval.'

# Management Pack Settings
Set-PSFConfig -Module 'Monitoring' -Name 'ManagementPack.AutoLoad' -Value $false -Initialize -Validation 'bool' -Description 'Whether to automatically detect and load Management Pack Modules during module import.'
Set-PSFConfig -Module 'Monitoring' -Name 'ManagementPack.Import' -Value @() -Initialize -Validation 'stringarray' -Description 'An explicit list of Management Pack Modules to import when importing this module.'