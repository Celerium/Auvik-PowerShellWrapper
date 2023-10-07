function Get-AuvikInterface {
<#
    .SYNOPSIS
        Get Auvik interfaces and other related information

    .DESCRIPTION
        The Get-AuvikInterface cmdlet allows you to view an inventory of
        interfaces and other related information discovered by Auvik.

    .PARAMETER id
        ID of interface

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_interfaceType
        Filter by interface type

        Allowed values:
            "ethernet", "wifi", "bluetooth", "cdma", "coax", "cpu", "distributedVirtualSwitch",
            "firewire", "gsm", "ieee8023AdLag", "inferredWired", "inferredWireless", "interface",
            "linkAggregation", "loopback", "modem", "wimax", "optical", "other", "parallel", "ppp",
            "radiomac", "rs232", "tunnel", "unknown", "usb", "virtualBridge", "virtualNic",
            "virtualSwitch", "vlan"

    .PARAMETER filter_parentDevice
        Filter by the entity's parent device ID

    .PARAMETER filter_adminStatus
        Filter by the interface's admin status

    .PARAMETER filter_operationalStatus
        Filter by the interface's operational status

        Allowed values:
            "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

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
        Get-AuvikInterface

        Pulls general information about the first 100 interfaces
        Auvik has discovered

    .EXAMPLE
        Get-AuvikInterface -id 123456789

        Pulls general information for the defined interface
        Auvik has discovered

    .EXAMPLE
        Get-AuvikInterface -page_first 1000 -allPages

        Pulls general information for all interfaces found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikInterface.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiInterfaceGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateSet(   "ethernet", "wifi", "bluetooth", "cdma", "coax", "cpu", "distributedVirtualSwitch",
                        "firewire", "gsm", "ieee8023AdLag", "inferredWired", "inferredWireless", "interface",
                        "linkAggregation", "loopback", "modem", "wimax", "optical", "other", "parallel", "ppp",
                        "radiomac", "rs232", "tunnel", "unknown", "usb", "virtualBridge", "virtualNic",
                        "virtualSwitch", "vlan"
        )]
        [string]$filter_interfaceType,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_parentDevice,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [switch]$filter_adminStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateSet( "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown" )]
        [string]$filter_operationalStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiInterfaceGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiInterfaceGeneral'  { $resource_uri = "/inventory/interface/info" }
            'indexBySingleInterfaceGeneral' { $resource_uri = "/inventory/interface/info/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_interfaceParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
