function Get-AuvikBilling {
<#
    .SYNOPSIS
        Get Auvik billing information

    .DESCRIPTION
        The Get-AuvikBilling cmdlet gets billing information
        to help calculate your invoices

        The dataTime value are converted to UTC, however for these endpoints
        you will only need to defined yyyy-MM-dd

    .PARAMETER filter_fromDate
        Date from which you want to query

        Example: filter[fromDate]=2019-06-01

    .PARAMETER filter_thruDate
        Date to which you want to query

        Example: filter[thruDate]=2019-06-30

    .PARAMETER tenants
        Comma delimited list of tenant IDs to request info from.

        Example: tenants=199762235015168516,199762235015168004

    .PARAMETER id
        ID of device

    .EXAMPLE
        Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30

        Pulls a summary of a client's (and client's children if a multi-client)
        usage for the given time range.

    .EXAMPLE
        Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30 -tenants 12345,98765

        Pulls a summary of the defined client's (and client's children if a multi-client)
        usage for the given time range.

    .EXAMPLE
        Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30 -id 123456789

        Pulls a summary of the define device id's usage for the given time range.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/billing/Get-AuvikBilling.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByClient')]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_fromDate,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [DateTime]$filter_thruDate,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'indexByClient')]
        [ValidateNotNullOrEmpty()]
        [string[]]$tenants,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexByDevice')]
        [ValidateNotNullOrEmpty()]
        [string]$id
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexByClient' { $resource_uri = "/billing/usage/client" }
            'indexByDevice' { $resource_uri = "/billing/usage/device/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Remove path parameters ]

        if( $PSBoundParameters.ContainsKey('id') ) {
            $PSBoundParameters.Remove('id') > $null
        }

        #EndRegion  [ Remove path parameters ]

        Set-Variable -Name 'Auvik_billingParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}

}
