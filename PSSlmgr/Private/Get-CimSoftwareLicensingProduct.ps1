Function Get-CimSoftwareLicensingProduct {

    [Cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [String]$Query,
        [Parameter(Mandatory=$false)]
        [Alias('MachineName')]
        $ComputerName="localhost",
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,
        [Parameter(Mandatory=$false)]
        [Switch]$AnsibleMode
    )

    trap { "Erorr occured"; continue; }

    Remove-Variable -Name LicenseProductErrorGlobal -Force -Scope Global -ErrorAction SilentlyContinue

    $LicenseProductData = Get-CimInstance -Query $ProductQueryString -ErrorVariable LicenseProductError #2>&1 | out-null

    if ( -Not [String]::IsNullOrEmpty($LicenseProductError)) {

        New-Variable -Name LicenseProductErrorGlobal -Value $LicenseProductError -Scope Global

    }
    else {

        New-Variable -Name LicenseProductErrorGlobal -Value $null -Scope Global

        Return $LicenseProductData

    }

}