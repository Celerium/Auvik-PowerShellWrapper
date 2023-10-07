function Get-AuvikDevice {
<#
    .SYNOPSIS
        Get Auvik devices and other related information

    .DESCRIPTION
        The Get-AuvikDevice cmdlet allows you to view an inventory of
        devices and other related information discovered by Auvik.

        Use the [ -details, -detailsExtended, & -detailsGeneral  ] parameters
        when wanting to target specific information.

        See Get-Help Get-AuvikDevice -Full for more information on associated parameters

        This function combines 6 endpoints together within the Device API.

        Read Multiple Devices' Info:
            Pulls detail about multiple devices discovered on your client's network.
        Read a Single Device's Info:
            Pulls detail about a specific device discovered on your client's network.

        Read Multiple Devices' Details:
            Pulls details about multiple devices not already included in the Device Info API.
        Read a Single Device's Details:
            Pulls details about a specific device not already included in the Device Info API.

        Read Multiple Device's Extended Details:
            Pulls extended information about multiple devices not already included in the Device Info API.
        Read a Single Device's Extended Details:
            Pulls extended information about a specific device not already included in the Device Info API.

    .PARAMETER id
        ID of device

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_networks
        Filter by IDs of networks this device is on

    .PARAMETER filter_manageStatus
        Filter by managed status

    .PARAMETER filter_discoverySNMP
        Filter by the device's SNMP discovery status

        Allowed values:
            "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

    .PARAMETER filter_discoveryWMI
        Filter by the device's WMI discovery status

        Allowed values:
            "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

    .PARAMETER filter_discoveryLogin
        Filter by the device's Login discovery status

        Allowed values:
            "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

    .PARAMETER filter_discoveryVMware
        Filter by the device's VMware discovery status

        Allowed values:
            "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

    .PARAMETER filter_trafficInsightsStatus
        Filter by the device's VMware discovery status

        Allowed values:
            "notDetected", "detected", "notApproved", "approved", "linking", "linkingFailed", "forwarding"

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "accessPoint", "airConditioner", "alarm", "audioVisual", "backhaul", "backupDevice",
            "bridge", "buildingManagement", "camera", "chassis", "controller", "copier", "firewall",
            "handheld", "hub", "hypervisor", "internetOfThings", "ipmi", "ipPhone", "l3Switch",
            "lightingDevice", "loadBalancer", "modem", "module", "multimedia", "packetProcessor",
            "pdu", "phone", "printer", "router", "securityAppliance", "server", "stack", "storage",
            "switch", "tablet", "telecommunications", "thinAccessPoint", "thinClient", "timeClock",
            "unknown", "ups", "utm", "virtualAppliance", "virtualMachine", "voipSwitch", "workstation"

    .PARAMETER filter_makeModel
        Filter by the device's make and model

    .PARAMETER filter_vendorName
        Filter by the device's vendor/manufacturer

    .PARAMETER filter_onlineStatus
        Filter by the device's online status

        Allowed values:
        "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER filter_notSeenSince
        Filter by the last seen online time, returning entities not seen online after the provided value

    .PARAMETER include
        Use to include the full resource objects of the list device relationships

        Example: include=deviceDetail

    .PARAMETER fields_deviceDetail
        Use to limit the attributes that will be returned in the included detail object to
        only what is specified by this query parameter

        Requires include=deviceDetail

    .PARAMETER details
        Target the details endpoint

        /inventory/device/detail & /inventory/device/detail/{id}

    .PARAMETER detailsExtended
        Target the extended details endpoint

        /inventory/device/detail/extended & /inventory/device/detail/extended/{id}

    .PARAMETER detailsGeneral
        Target the general details endpoint

        Only needed when limiting general search by id, to give the parameter
        set a unique value.

        /inventory/device/info & /inventory/device/info

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
        Get-AuvikDevice

        Pulls general information about the first 100 devices
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -id 123456789 -detailsGeneral

        Pulls general information for the defined device
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -details

        Pulls detailed information about the first 100 devices
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -id 123456789 -details

        Pulls details information for the defined device
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -detailsExtended

        Pulls extended detail information about the first 100 devices
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -id 123456789 -detailsExtended

        Pulls extended detail information for the defined device
        Auvik has discovered

    .EXAMPLE
        Get-AuvikDevice -page_first 1000 -allPages

        Pulls general information for all devices found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDevice.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiDeviceGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDeviceGeneral' )]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDeviceDetail' )]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_networks,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [switch]$filter_manageStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged" )]
        [string]$filter_discoverySNMP,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged" )]
        [string]$filter_discoveryWMI,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged" )]
        [string]$filter_discoveryLogin,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged" )]
        [string]$filter_discoveryVMware,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [ValidateSet( "notDetected", "detected", "notApproved", "approved", "linking", "linkingFailed", "forwarding" )]
        [string]$filter_trafficInsightsStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $true , ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateSet(   "accessPoint", "airConditioner", "alarm", "audioVisual", "backhaul", "backupDevice",
                        "bridge", "buildingManagement", "camera", "chassis", "controller", "copier", "firewall",
                        "handheld", "hub", "hypervisor", "internetOfThings", "ipmi", "ipPhone", "l3Switch",
                        "lightingDevice", "loadBalancer", "modem", "module", "multimedia", "packetProcessor",
                        "pdu", "phone", "printer", "router", "securityAppliance", "server", "stack", "storage",
                        "switch", "tablet", "telecommunications", "thinAccessPoint", "thinClient", "timeClock",
                        "unknown", "ups", "utm", "virtualAppliance", "virtualMachine", "voipSwitch", "workstation"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_makeModel,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_vendorName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [ValidateSet( "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown" )]
        [string]$filter_onlineStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_notSeenSince,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$include,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceGeneral' )]
        [ValidateSet( "discoveryStatus", "components", "connectedDevices", "configurations", "manageStatus", "interfaces" )]
        [string]$fields_deviceDetail,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceDetail' )]
        [switch]$details,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceExtDetail' )]
        [switch]$detailsExtended,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleDeviceGeneral' )]
        [switch]$detailsGeneral,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceDetail' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDeviceExtDetail' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiDeviceGeneral'     { $resource_uri = "/inventory/device/info" }
            'indexBySingleDeviceGeneral'    { $resource_uri = "/inventory/device/info/$id" }

            'indexByMultiDeviceDetail'      { $resource_uri = "/inventory/device/detail" }
            'indexBySingleDeviceDetail'     { $resource_uri = "/inventory/device/detail/$id" }

            'indexByMultiDeviceExtDetail'   { $resource_uri = "/inventory/device/detail/extended" }
            'indexBySingleDeviceExtDetail'  { $resource_uri = "/inventory/device/detail/extended/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_deviceParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
