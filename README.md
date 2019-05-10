# Description

The Monitoring module is a module designed to gather monitoring data.
It is freely extensible, both in what data to retrieve and what kind of targets to manage.

It provides two key benefits:

 - Data proxy / Credential Isolation: The actual monitoring service consuming the data offered by this module does not have to have access to the source systems.
 - Abstracts data gathering logic. Individual "Management Pack"-Modules can be consumed all the same, no matter which monitoring system uses the data. This makes the gathering scripts no longer specific to a single platform.

# In Action

> Installation

First to install the module.
The core module does not provide any checks (= data gathering logic), so we'll also add the ActiveDirectory Management Pack Module:

```powershell
Install-Module Monitoring
Install-Module Monitoring.ActiveDirectory
```

> Configuration

Then add a domain controller to the list of monitored objects:

```powershell
Set-MonTarget -Name dc1.contoso.com -Tag domaincontroller -Capability WinRM, ldap
```

The tags determine what checks are applied to the target. The capabilities are the remote connection options the target supports.

Active Directory however is not limited to just monitoring Domain Controllers:
The overall domain health is also looked at, so let's go ahead and register the domain as a target as well!

```powershell
Set-MonTarget -Name contoso.com -Tag domain -Capability ldap
```

> Gather Data

With that setup, all it takes is executing the scan:

```powershell
Invoke-MonCheck
```

Without parameters, `Invoke-MonCheck` will execute all configured check-target combinations.

> Evaluate

Finally we need to do something with the results.
To get a quick view at all the data gathered, we can run ...

```powershell
Test-MonHealth
```

To retrieve a specific piece of information, the way a monitoring solution would to just pick up the information it needs, we use `Get-MonDatum` instead:

```powershell
Get-MonDatum -TargetName dc1.contoso.com -CheckName domaincontroller_SysvolFreePercent
```

# Prerequisites

 - PowerShell v5+
 - PowerShell Module: PSFramework
