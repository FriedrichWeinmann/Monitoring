﻿# Add all things you want to run after importing the main code

# Load Configurations
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal\configurations\*.ps1" -ErrorAction Ignore))
{
	. Import-ModuleFile -Path $file.FullName
}

# Load Scriptblocks
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal\scriptblocks\*.ps1" -ErrorAction Ignore))
{
	. Import-ModuleFile -Path $file.FullName
}

# Load Tab Expansion
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal\tepp\*.tepp.ps1" -ErrorAction Ignore))
{
	. Import-ModuleFile -Path $file.FullName
}

# Load Tab Expansion Assignment
. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\tepp\assignment.ps1"

# Load License
. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\scripts\license.ps1"

# Load Variables
. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\scripts\variables.ps1"

# Load Connections
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal\connections\*.ps1" -ErrorAction Ignore))
{
	. Import-ModuleFile -Path $file.FullName
}

# Load Sources
foreach ($file in (Get-ChildItem "$($script:ModuleRoot)\internal\sources\*.ps1" -ErrorAction Ignore))
{
	. Import-ModuleFile -Path $file.FullName
}

# Load persisted content
. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\scripts\importContent.ps1"