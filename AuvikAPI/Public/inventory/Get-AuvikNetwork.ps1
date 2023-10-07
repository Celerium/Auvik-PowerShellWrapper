function Get-AuvikNetwork {
<#
    .SYNOPSIS
        Get Auvik networks and other related information

    .DESCRIPTION
        The Get-AuvikNetwork cmdlet allows you to view an inventory of
        networks and other related information discovered by Auvik.

        Use the [ -details & -detailsGeneral  ] parameters when wanting to target
        specific information. See Get-Help Get-AuvikNetwork -Full for
        more information on associated parameters

    .PARAMETER id
        ID of network

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_networkType
        Filter by network type

        Allowed values:
            "routed", "vlan", "wifi", "loopback", "network", "layer2", "internet"

    .PARAMETER filter_scanStatus
        Filter by the network's scan status

        Allowed values:
            "true", "false", "notAllowed", "unknown"

    .PARAMETER filter_devices
        Filter by IDs of devices on this network

        Filter by multiple values by providing a comma delimited list

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER filter_scope
        Filter by the network's scope

        Allowed values:
            "private", "public"

    .PARAMETER include
        Use to include the full resource objects of the list device relationships

        Example: include=deviceDetail

    .PARAMETER fields_networkDetail
        Use to limit the attributes that will be returned in the included detail
        object to only what is specified by this query parameter.

        Allowed values:
            "scope", "primaryCollector", "secondaryCollectors", "collectorSelection", "excludedIpAddresses"

        Requires include=networkDetail

    .PARAMETER details
        Target the details endpoint

        /inventory/network/info & /inventory/network/info/{id}

    .PARAMETER detailsGeneral
        Target the general details endpoint

        /inventory/network/detail & /inventory/network/detail/{id}

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
        Get-AuvikNetwork

        Pulls general information about the first 100 networks
        Auvik has discovered

    .EXAMPLE
        Get-AuvikNetwork -id 123456789 -detailsGeneral

        Pulls general information for the defined network
        Auvik has discovered

    .EXAMPLE
        Get-AuvikNetwork -details

        Pulls detailed information about the first 100 networks
        Auvik has discovered

    .EXAMPLE
        Get-AuvikNetwork -id 123456789 -details

        Pulls details information for the defined network
        Auvik has discovered

    .EXAMPLE
        Get-AuvikNetwork -page_first 1000 -allPages

        Pulls general information for all networks found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikNetwork.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiNetworkGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleNetworkGeneral' )]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateSet( "routed", "vlan", "wifi", "loopback", "network", "layer2", "internet" )]
        [string]$filter_networkType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateSet( "true", "false", "notAllowed", "unknown" )]
        [string]$filter_scanStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$filter_devices,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateSet( "private", "public" )]
        [string]$filter_scope,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleNetworkGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$include,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleNetworkGeneral' )]
        [ValidateSet( "scope", "primaryCollector", "secondaryCollectors", "collectorSelection", "excludedIpAddresses" )]
        [string]$fields_networkDetail,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleNetworkDetail' )]
        [switch]$details,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexBySingleNetworkGeneral' )]
        [switch]$detailsGeneral,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkGeneral' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiNetworkDetail' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiNetworkGeneral'    { $resource_uri = "/inventory/network/info" }
            'indexBySingleNetworkGeneral'   { $resource_uri = "/inventory/network/info/$id" }

            'indexByMultiNetworkDetail'     { $resource_uri = "/inventory/network/detail" }
            'indexBySingleNetworkDetail'    { $resource_uri = "/inventory/network/detail/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_networkParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
