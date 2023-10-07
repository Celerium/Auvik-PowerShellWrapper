function Get-AuvikSNMPPollerSetting {
<#
    .SYNOPSIS
        Provides details about one or more SNMP Poller Settings.

    .DESCRIPTION
        The Get-AuvikSNMPPollerSetting cmdlet provides details about
        one or more SNMP Poller Settings.

    .PARAMETER snmpPollerSettingId
        ID of the SNMP Poller Setting to retrieve

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER filter_useAs
        Filter by oid type

        Allowed values:
            "serialNo", "poller"

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall", "workstation",
            "server", "storage", "printer", "copier", "hypervisor", "multimedia", "phone", "tablet",
            "handheld", "virtualAppliance", "bridge", "controller", "hub", "modem", "ups", "module",
            "loadBalancer", "camera", "telecommunications", "packetProcessor", "chassis", "airConditioner",
            "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings", "voipSwitch", "stack",
            "backupDevice", "timeClock", "lightingDevice", "audioVisual", "securityAppliance", "utm",
            "alarm", "buildingManagement", "ipmi", "thinAccessPoint", "thinClient"

    .PARAMETER filter_makeModel
        Filter by the device's make and model

    .PARAMETER filter_vendorName
        Filter by the device's vendor/manufacturer

    .PARAMETER filter_oid
        Filter by OID

    .PARAMETER filter_name
        Filter by the name of the SNMP poller setting

    .PARAMETER page_first
        For paginated responses, the first N elements will be returned
        Used in combination with page[after]

        Default Value: 100

    .PARAMETER page_after
        Cursor after which elements will be returned as a page
        The page size is provided by page[first]

    .PARAMETER page_last
        For paginated responses, the last N services will be returned
        Used in combination with page[before]

        Default Value: 100

    .PARAMETER page_before
        Cursor before which elements will be returned as a page
        The page size is provided by page[last]

    .PARAMETER allPages
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-AuvikSNMPPollerSetting -tenants 123456789

        Provides details about the first 100 SNMP Poller Settings
        associated to the defined tenant

    .EXAMPLE
        Get-AuvikSNMPPollerSetting -tenants 123456789 -page_first 1000 -allPages

        Provides details about all the SNMP Poller Settings
        associated to the defined tenant

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/pollers/Get-AuvikSNMPPollerSetting.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiSNMPGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$snmpPollerSettingId,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateSet( "serialNo", "poller")]
        [string]$filter_useAs,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateSet(   "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall", "workstation",
                        "server", "storage", "printer", "copier", "hypervisor", "multimedia", "phone", "tablet",
                        "handheld", "virtualAppliance", "bridge", "controller", "hub", "modem", "ups", "module",
                        "loadBalancer", "camera", "telecommunications", "packetProcessor", "chassis", "airConditioner",
                        "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings", "voipSwitch", "stack",
                        "backupDevice", "timeClock", "lightingDevice", "audioVisual", "securityAppliance", "utm",
                        "alarm", "buildingManagement", "ipmi", "thinAccessPoint", "thinClient"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_makeModel,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_vendorName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_oid,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_name,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiSNMPGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiSNMPGeneral'   { $resource_uri = "/settings/snmppoller" }
            'indexBySingleSNMPGeneral'  { $resource_uri = "/settings/snmppoller/$snmpPollerSettingId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('snmpPollerSettingId') ) {
                $PSBoundParameters.Remove('snmpPollerSettingId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_snmpSettingsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
