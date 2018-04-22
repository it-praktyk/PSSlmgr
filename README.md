# PSSlmgr PowerShell module

The PSSlmgr PowerShell module is intended to be replacement of slmgr.vbs.

The module was a part of presentation 'Use your PowerShell skills to extend Ansible workflows. Create your own Ansible module for Windows platform.' under [PowerShell Conference Europe 2018](http://www.psconf.eu/) in conjunction with the Ansible [win_psslmgr_rearm](https://github.com/it-praktyk/ansible-win_psslmgr_rearm) which performs rearm operations.

| slmgr.vbs section | slmgr.vbs option                      | Purpose                                                           | PSSlmgr command                  | Status |
| ------------------|---------------------------------------|-------------------------------------------------------------------|----------------------------------|--------|
| Global Options    | /ipk <Product Key>                    | Install product key (replaces existing key)                       |Invoke-ProductKeyInstall          |Planned |
| Global Options    | /ato [Activation ID]                  | Activate Windows                                                  |Invoke-WindowsActivation          |Planned |
| Global Options    | /dli [Activation ID \| All]           | Display license information (default: current license)            |Get-LicenseStatus                 |Implemented |
| Global Options    | /dlv [Activation ID \| All]           | Display detailed license information (default: current license)   |Get-LicenseStatus -Details        |Planned |
| Global Options    | /xpr [Activation ID]                  | Expiration date for current license state                         |Get-LicenseStatus -Details        |Planned |
| Advanced Options  | /cpky                                 | Clear product key from the registry (prevents disclosure attacks) |Clear-ProductKey                  |Planned |
| Advanced Options  | /ilc <License file>                   | Install license                                                   |Invoke-LicenseInstall             |Planned |
| Advanced Options  | /rilc                                 | Re-install system license files                                   |Invoke-LicenseInstall -Force      |Planned |
| Advanced Options  | /rearm                                | Reset the licensing status of the machine                         |Invoke-Rearm -Windows             |Implemented |
| Advanced Options  | /rearm-app <Application ID>           | Reset the licensing status of the given app                       |Invoke-Rearm -Application         |Planned |
| Advanced Options  | /rearm-sku <Activation ID>            | Reset the licensing status of the given sku                       |Invoke-Rearm -SKU                 |Planned |
| Advanced Options  | /upk [Activation ID]                  | Uninstall product key                                             |Invoke-ProductKeyUninstall        |Planned |
| Advanced Options  | /dti [Activation ID]                  | Display Installation ID for offline activation                    |Get-OfflineActivationID           |Planned |
| Advanced Options  | /atp <Confirmation ID> [Activation ID]| Activate product with user-provided Confirmation ID               |Invoke-WindowsActivation -Offline |Planned |
