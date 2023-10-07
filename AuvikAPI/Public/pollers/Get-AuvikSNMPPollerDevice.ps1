function Get-AuvikSNMPPollerDevice {
<#
    .SYNOPSIS
        Provides details about all the devices associated to a
        specific SNMP Poller Setting.

    .DESCRIPTION
        The Get-AuvikSNMPPollerDevice cmdlet provides details about all
        the devices associated to a specific SNMP Poller Setting.

    .PARAMETER snmpPollerSettingId
        ID of the SNMP Poller Setting that the devices apply to

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_onlineStatus
        Filter by the device's online status

        Allowed values:
            "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER filter_notSeenSince
        Filter by the last seen online time, returning entities not
        seen online after the provided value.

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
        Get-AuvikSNMPPollerDevice -snmpPollerSettingId MTk5NTAyNzg2ODc3 -tenants 123456789

        Provides details about the first 100 devices associated to the defined
        SNMP Poller id


    .EXAMPLE
        Get-AuvikSNMPPollerDevice -snmpPollerSettingId MTk5NTAyNzg2ODc3 -tenants 123456789 -page_first 1000 -allPages

        Provides details about all the devices associated to the defined
        SNMP Poller id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/pollers/Get-AuvikSNMPPollerDevice.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexBySNMPDevice' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$snmpPollerSettingId,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateSet( "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown" )]
        [string]$filter_onlineStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_notSeenSince,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateSet(   "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall", "workstation",
                        "server", "storage", "printer", "copier", "hypervisor", "multimedia", "phone", "tablet",
                        "handheld", "virtualAppliance", "bridge", "controller", "hub", "modem", "ups", "module",
                        "loadBalancer", "camera", "telecommunications", "packetProcessor", "chassis", "airConditioner",
                        "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings", "voipSwitch", "stack",
                        "backupDevice", "timeClock", "lightingDevice", "audioVisual", "securityAppliance", "utm",
                        "alarm", "buildingManagement", "ipmi", "thinAccessPoint", "thinClient"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_makeModel,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_vendorName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySNMPDevice' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexBySNMPDevice'     { $resource_uri = "/settings/snmppoller/$snmpPollerSettingId/devices" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('snmpPollerSettingId') ) {
                $PSBoundParameters.Remove('snmpPollerSettingId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_snmpDeviceParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
