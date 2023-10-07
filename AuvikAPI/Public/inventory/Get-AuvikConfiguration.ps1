function Get-AuvikConfiguration {
<#
    .SYNOPSIS
        Get Auvik history of device configurations

    .DESCRIPTION
        The Get-AuvikConfiguration cmdlet allows you to view a history of
        device configurations and other related information discovered by Auvik.

    .PARAMETER id
        ID of entity note\audit

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER filter_backupTimeAfter
        Filter by date and time, filtering out configurations backed up before value

    .PARAMETER filter_backupTimeBefore
        Filter by date and time, filtering out configurations backed up after value.

    .PARAMETER filter_isRunning
        Filter for configurations that are currently running, or filter
        for all configurations which are not currently running.

        As of 2023-10, this does not appear to function correctly on this endpoint

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
        Get-AuvikConfiguration

        Pulls general information about the first 100 configurations
        Auvik has discovered

    .EXAMPLE
        Get-AuvikConfiguration -id 123456789

        Pulls general information for the defined configuration
        Auvik has discovered

    .EXAMPLE
        Get-AuvikConfiguration -page_first 1000 -allPages

        Pulls general information for all configurations found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikConfiguration.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiConfigGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_backupTimeAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_backupTimeBefore,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [switch]$filter_isRunning,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiConfigGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiConfigGeneral'     { $resource_uri = "/inventory/configuration" }
            'indexBySingleConfigGeneral'    { $resource_uri = "/inventory/configuration/$id" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_configurationParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
