function Get-AuvikOIDStatistics {
<#
    .SYNOPSIS
        Provides the current value for numeric SNMP Pollers.

    .DESCRIPTION
        The Get-AuvikOIDStatistics cmdlet provides the current
        value for numeric SNMP Pollers.

    .PARAMETER statId
        ID of statistic to return

        Allowed values:
            "deviceMonitor"

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER filter_deviceType
        Filter by device type

        Allowed values:
            "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall",
            "workstation", "server", "storage", "printer", "copier", "hypervisor",
            "multimedia", "phone", "tablet", "handheld", "virtualAppliance", "bridge",
            "controller", "hub", "modem", "ups", "module", "loadBalancer", "camera",
            "telecommunications", "packetProcessor", "chassis", "airConditioner",
            "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings",
            "voipSwitch", "stack", "backupDevice", "timeClock", "lightingDevice",
            "audioVisual", "securityAppliance", "utm", "alarm", "buildingManagement",
            "ipmi", "thinAccessPoint", "thinClient"

    .PARAMETER filter_oid
        Filter by OID

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
        Get-AuvikOIDStatistics -statId deviceMonitor

        Provides the first 100 values for numeric SNMP Pollers.

    .EXAMPLE
        Get-AuvikOIDStatistics -statId deviceMonitor -page_first 1000 -allPages

        Provides all values for numeric SNMP Pollers.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikOIDStatistics.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStatistics' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet("deviceMonitor" )]
        [string]$statId,

        [Parameter( Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet(   "unknown", "switch", "l3Switch", "router", "accessPoint", "firewall",
                        "workstation", "server", "storage", "printer", "copier", "hypervisor",
                        "multimedia", "phone", "tablet", "handheld", "virtualAppliance", "bridge",
                        "controller", "hub", "modem", "ups", "module", "loadBalancer", "camera",
                        "telecommunications", "packetProcessor", "chassis", "airConditioner",
                        "virtualMachine", "pdu", "ipPhone", "backhaul", "internetOfThings",
                        "voipSwitch", "stack", "backupDevice", "timeClock", "lightingDevice",
                        "audioVisual", "securityAppliance", "utm", "alarm", "buildingManagement",
                        "ipmi", "thinAccessPoint", "thinClient"
        )]
        [string]$filter_deviceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_oid,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStatistics' { $resource_uri = "/stat/oid/$statId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('statId') ) {
                $PSBoundParameters.Remove('statId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_oidStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
