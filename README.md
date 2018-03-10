
# PSSlmgr PowerShell module

It's a placeholder project for the PowerShell PSSlmgr module - PowerShell implementation of slmgr.vbs.

Module will be presented under PowerShell Conference Europe 2018.

| slmgr.vbs section | slmgr.vbs option                      | Purpose                                                           | PSSlmgr command           | Status |
| ------------------|---------------------------------------|-------------------------------------------------------------------|---------------------------|--------|
| Global Options    | /ipk <Product Key>                    | Install product key (replaces existing key)                       |Invoke-ProductKeyInstall   |Planned |
| Global Options    | /ato [Activation ID]                  | Activate Windows                                                  |Invoke-WindowsActivation   |Planned |
| Global Options    | /dli [Activation ID \| All]           | Display license information (default: current license)            |Get-LicenseStatus          |Planned |
| Global Options    | /dlv [Activation ID \| All]           | Display detailed license information (default: current license)   |Get-LicenseStatusDetail    |Planned |
| Global Options    | /xpr [Activation ID]                  | Expiration date for current license state                         |Get-License                |Planned |
| Advanced Options  | /cpky                                 | Clear product key from the registry (prevents disclosure attacks) |Clear-ProductKey           |Planned |
| Advanced Options  | /ilc <License file>                   | Install license                                                   |Invoke-<TBD>               |Planned |
| Advanced Options  | /rilc                                 | Re-install system license files                                   |Invoke-<TBD>               |Planned |
| Advanced Options  | /rearm                                | Reset the licensing status of the machine                         |Invoke-WindowsRearm        |Planned |
| Advanced Options  | /rearm-app <Application ID>           | Reset the licensing status of the given app                       |Invoke-ApplicationRearm    |Planned |
| Advanced Options  | /rearm-sku <Activation ID>            | Reset the licensing status of the given sku                       |Invoke-SKURearm            |Planned |
| Advanced Options  | /upk [Activation ID]                  | Uninstall product key                                             |Invoke-ProductKeyUninstall |Planned |
| Advanced Options  | /dti [Activation ID]                  | Display Installation ID for offline activation                    |Get-OfflineActivationID    |Planned |
| Advanced Options  | /atp <Confirmation ID> [Activation ID]| Activate product with user-provided Confirmation ID               |Invoke-OfflineActivation   |Planned |
