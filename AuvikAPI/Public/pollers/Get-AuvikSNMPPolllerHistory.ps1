function Get-AuvikSNMPPolllerHistory {
<#
    .SYNOPSIS
        Get Auvik historical values of SNMP Poller settings

    .DESCRIPTION
        The Get-AuvikSNMPPolllerHistory cmdlet allows you to view
        historical values of SNMP Poller settings

        There are two endpoints available in the SNMP Poller History API.

        Read String SNMP Poller Setting History:
            Provides historical values of String SNMP Poller Settings.
        Read Numeric SNMP Poller Setting History:
            Provides historical values of Numeric SNMP Poller Settings.

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from

    .PARAMETER filter_fromTime
        Timestamp from which you want to query

    .PARAMETER filter_thruTime
        Timestamp to which you want to query (defaults to current time)

    .PARAMETER filter_compact
        Whether to show compact view of the results or not.

        Compact view only shows changes in value.
        If compact view is false, dateTime range can be a maximum of 24h

    .PARAMETER filter_interval
        Statistics reporting interval

        Allowed values:
            "minute", "hour", "day"

    .PARAMETER filter_deviceId
        Filter by device ID

    .PARAMETER filter_snmpPollerSettingId
        Comma delimited list of SNMP poller setting IDs to request info from.

        Note this is internal snmpPollerSettingId.
        The user can get the list of IDs for a specific poller using the
        GET /settings/snmppoller endpoint.

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
        Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789

        Pulls general information about the first 100 historical SNMP
        string poller settings

    .EXAMPLE
        Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789 -filter_interval day

        Pulls general information about the first 100 historical SNMP
        numerical poller settings

    .EXAMPLE
        Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789 -page_first 1000 -allPages

        Pulls general information about all historical SNMP
        string poller settings

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/poolers/Get-AuvikSNMPPolllerHistory.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByStringSNMP' )]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruTime,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [switch]$filter_compact,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateSet( "minute", "hour", "day")]
        [string]$filter_interval,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_deviceId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string[]]$filter_snmpPollerSettingId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_first,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_after,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page_last,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [ValidateNotNullOrEmpty()]
        [string]$page_before,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByStringSNMP' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByNumericSNMP' )]
        [switch]$allPages
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByStringSNMP'     { $resource_uri = "/stat/snmppoller/string" }
            'indexByNumericSNMP'    { $resource_uri = "/stat/snmppoller/int" }

        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Auvik_snmpHistoryParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
