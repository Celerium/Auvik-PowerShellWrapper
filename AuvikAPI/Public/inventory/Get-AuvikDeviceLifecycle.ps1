function Get-AuvikDeviceLifecycle {
    <#
        .SYNOPSIS
            Get Auvik devices and other related information

        .DESCRIPTION
            The Get-AuvikDeviceLifecycle cmdlet allows you to view an inventory of
            devices and other related information discovered by Auvik.

        .PARAMETER id
            ID of device

        .PARAMETER tenants
            Comma delimited list of tenant IDs to request info from

        .PARAMETER filter_salesAvailability
            Filter by sales availability

            Allowed values:
                "covered", "available", "expired", "securityOnly", "unpublished", "empty"

        .PARAMETER filter_softwareMaintenanceStatus
            Filter by software maintenance status

            Allowed values:
                "covered", "available", "expired", "securityOnly", "unpublished", "empty"

        .PARAMETER filter_securitySoftwareMaintenanceStatus
            Filter by security software maintenance status

            Allowed values:
                "covered", "available", "expired", "securityOnly", "unpublished", "empty"

        .PARAMETER filter_lastSupportStatus
            Filter by last support status

            Allowed values:
                "covered", "available", "expired", "securityOnly", "unpublished", "empty"

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
            Get-AuvikDeviceLifecycle

            Pulls general lifecycle information about the first 100 devices
            Auvik has discovered

        .EXAMPLE
            Get-AuvikDeviceLifecycle -id 123456789

            Pulls general lifecycle information for the defined device
            Auvik has discovered


        .EXAMPLE
            Get-AuvikDeviceLifecycle -page_first 1000 -allPages

            Pulls general lifecycle information for all devices found by Auvik.

        .NOTES
        N\A

        .LINK
            https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDeviceLifecycle.html
    #>

        [CmdletBinding(DefaultParameterSetName = 'indexByMultiDevice' )]
        Param (
            [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$id,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string[]]$tenants,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateSet( "covered", "available", "expired", "securityOnly", "unpublished", "empty" )]
            [string]$filter_salesAvailability,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateSet( "covered", "available", "expired", "securityOnly", "unpublished", "empty" )]
            [string]$filter_softwareMaintenanceStatus,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateSet( "covered", "available", "expired", "securityOnly", "unpublished", "empty" )]
            [string]$filter_securitySoftwareMaintenanceStatus,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateSet( "covered", "available", "expired", "securityOnly", "unpublished", "empty" )]
            [string]$filter_lastSupportStatus,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateRange(1, [int64]::MaxValue)]
            [int64]$page_first,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$page_after,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateRange(1, [int64]::MaxValue)]
            [int64]$page_last,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [ValidateNotNullOrEmpty()]
            [string]$page_before,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [switch]$allPages
        )

        begin {

            switch ( $($PSCmdlet.ParameterSetName) ) {
                'indexByMultiDevice'    { $resource_uri = "/inventory/device/lifecycle" }
                'indexBySingleDevice'   { $resource_uri = "/inventory/device/lifecycle/$id" }
            }

        }

        process {

            Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Region     [ Adjust parameters ]

                if( $PSBoundParameters.ContainsKey('id') ) {
                    $PSBoundParameters.Remove('id') > $null
                }

            #EndRegion  [ Adjust  parameters ]

            Set-Variable -Name 'Auvik_deviceLifecycleParameters' -Value $PSBoundParameters -Scope Global -Force

            Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

        }

        end {}

    }
