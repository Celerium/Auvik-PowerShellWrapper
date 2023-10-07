function Get-AuvikComponent {
<#
    .SYNOPSIS
        Get Auvik components and other related information

    .DESCRIPTION
        The Get-AuvikComponent cmdlet allows you to view an inventory of
        components and other related information discovered by Auvik.

    .PARAMETER id
        ID of component

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_modifiedAfter
        Filter by date and time, only returning entities modified after provided value

    .PARAMETER filter_deviceId
        Filter by the component's parent device's ID

    .PARAMETER filter_deviceName
        Filter by the component's parent device's name

    .PARAMETER filter_currentStatus
        Filter by the component's current status

        Allowed values:
            "ok", "degraded", "failed"

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
        Get-AuvikComponent

        Pulls general information about the first 100 components
        Auvik has discovered

    .EXAMPLE
        Get-AuvikComponent -id 123456789

        Pulls general information for the defined component
        Auvik has discovered

    .EXAMPLE
        Get-AuvikComponent -page_first 1000 -allPages

        Pulls general information for all components found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikComponent.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiComponentGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_modifiedAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceName,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateSet( "ok", "degraded", "failed" )]
        [string]$filter_currentStatus,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiComponentGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiComponentGeneral'  { $resource_uri = "/inventory/component/info" }
            'indexBySingleComponentGeneral' { $resource_uri = "/inventory/component/info/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_componentParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
