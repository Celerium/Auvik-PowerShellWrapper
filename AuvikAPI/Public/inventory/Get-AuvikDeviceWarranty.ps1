function Get-AuvikDeviceWarranty {
    <#
        .SYNOPSIS
            Get Auvik devices and other related information

        .DESCRIPTION
            The Get-AuvikDeviceWarranty cmdlet allows you to view an inventory of
            devices and other related information discovered by Auvik.

        .PARAMETER id
            ID of device

        .PARAMETER tenants
            Comma delimited list of tenant IDs to request info from

        .PARAMETER filter_coveredUnderWarranty
            Filter by warranty coverage status

        .PARAMETER filter_coveredUnderService
            Filter by service coverage status

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
            Get-AuvikDeviceWarranty

            Pulls general warranty information about the first 100 devices
            Auvik has discovered

        .EXAMPLE
            Get-AuvikDeviceWarranty -id 123456789

            Pulls general warranty information for the defined device
            Auvik has discovered


        .EXAMPLE
            Get-AuvikDeviceWarranty -page_first 1000 -allPages

            Pulls general warranty information for all devices found by Auvik.

        .NOTES
        N\A

        .LINK
            https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDeviceWarranty.html
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
            [switch]$filter_coveredUnderWarranty,

            [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiDevice' )]
            [switch]$filter_coveredUnderService,

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
                'indexByMultiDevice'    { $resource_uri = "/inventory/device/warranty" }
                'indexBySingleDevice'   { $resource_uri = "/inventory/device/warranty/$id" }
            }

        }

        process {

            Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Region     [ Adjust parameters ]

                if( $PSBoundParameters.ContainsKey('id') ) {
                    $PSBoundParameters.Remove('id') > $null
                }

            #EndRegion  [ Adjust  parameters ]

            Set-Variable -Name 'Auvik_deviceWarrantyParameters' -Value $PSBoundParameters -Scope Global -Force

            Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

        }

        end {}

    }
