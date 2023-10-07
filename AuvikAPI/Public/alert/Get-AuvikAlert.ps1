function Get-AuvikAlert {
<#
    .SYNOPSIS
        Get Auvik alert events that have been triggered by your Auvik collector(s).

    .DESCRIPTION
        The Get-AuvikAlert cmdlet allows you to view the alert events
        that has been triggered by your Auvik collector(s).

    .PARAMETER id
        ID of alert

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_alertDefinitionId
        Filter by alert definition ID

    .PARAMETER filter_severity
        Filter by alert severity

        Allowed values:
            "unknown", "emergency", "critical", "warning", "info"

    .PARAMETER filter_status
        Filter by the status of the alert

        Allowed values:
            "created", "resolved", "paused", "unpaused"

    .PARAMETER filter_entityId
        Filter by the related entity ID

    .PARAMETER filter_dismissed
        Filter by the dismissed status

        As of 2023-10 this parameter does not appear to work

    .PARAMETER filter_dispatched
        Filter by dispatched status

        As of 2023-10 this parameter does not appear to work

    .PARAMETER filter_detectedTimeAfter
        Filter by the time which is greater than the given timestamp

    .PARAMETER filter_detectedTimeBefore
        Filter by the time which is less than or equal to the given timestamp

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
        Get-AuvikAlert

        Pulls general information about the first 100 alerts
        Auvik has discovered

    .EXAMPLE
        Get-AuvikAlert -id 123456789

        Pulls general information for the defined alert
        Auvik has discovered

    .EXAMPLE
        Get-AuvikAlert -page_first 1000 -allPages

        Pulls general information for all alerts found by Auvik.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/alert/Get-AuvikAlert.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMultiAlertGeneral' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexBySingleAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$id,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_alertDefinitionId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateSet( "unknown", "emergency", "critical", "warning", "info" )]
        [string]$filter_severity,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateSet( "created", "resolved", "paused", "unpaused" )]
        [string]$filter_status,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_entityId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [switch]$filter_dismissed,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [switch]$filter_dispatched,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_detectedTimeAfter,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_detectedTimeBefore,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByMultiAlertGeneral' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByMultiAlertGeneral'     { $resource_uri = "/alert/history/info" }
            'indexBySingleAlertGeneral'    { $resource_uri = "/alert/history/info/$id" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            if( $PSBoundParameters.ContainsKey('id') ) {
                $PSBoundParameters.Remove('id') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_alertParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
