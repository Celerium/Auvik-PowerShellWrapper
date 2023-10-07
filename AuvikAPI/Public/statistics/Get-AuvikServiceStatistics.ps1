function Get-AuvikServiceStatistics {
<#
    .SYNOPSIS
        Provides historical cloud ping check statistics.

    .DESCRIPTION
        The Get-AuvikServiceStatistics cmdlet provides historical
        cloud ping check statistics.

    .PARAMETER statId
        ID of statistic to return

        Allowed values:
            "pingTime", "pingPacket"

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_fromTime
        Timestamp from which you want to query

    .PARAMETER filter_thruTime
        Timestamp to which you want to query (defaults to current time)

    .PARAMETER filter_interval
        Statistics reporting interval

        Allowed values:
            "minute", "hour", "day"

    .PARAMETER filter_serviceId
        Filter by service ID

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
        Get-AuvikServiceStatistics -statId pingTime -filter_fromTime 2023-10-03 -filter_interval day

        Provides the first 100 historical cloud ping check statistics.

    .EXAMPLE
        Get-AuvikServiceStatistics -statId pingTime -filter_fromTime 2023-10-03 -filter_interval day -page_first 1000 -allPages

        Provides all historical cloud ping check statistics.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikServiceStatistics.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStatistics' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "pingTime", "pingPacket" )]
        [string]$statId,

        [Parameter( Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruTime,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStatistics' )]
        [ValidateSet( "minute", "hour", "day" )]
        [string]$filter_interval,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStatistics' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_serviceId,

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
            'indexByStatistics' { $resource_uri = "/stat/service/$statId" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Adjust parameters ]

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('filter_thruTime') ) { $PSBoundParameters.filter_thruTime = Get-Date }

            if( $PSBoundParameters.ContainsKey('statId') ) {
                $PSBoundParameters.Remove('statId') > $null
            }

        #EndRegion  [ Adjust  parameters ]

        Set-Variable -Name 'Auvik_deviceServiceStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
