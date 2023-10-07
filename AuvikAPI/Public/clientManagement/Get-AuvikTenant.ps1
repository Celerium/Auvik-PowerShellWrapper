function Get-AuvikTenant {
<#
    .SYNOPSIS
        Get Auvik tenant information

    .DESCRIPTION
        The Get-AuvikTenant cmdlet get Auvik general or detailed
        tenant information associated to your Auvik user account

    .PARAMETER tenantDomainPrefix
        Domain prefix of your main Auvik account (tenant).

    .PARAMETER filter_availableTenants
        Filter whether or not a tenant is available,
        i.e. data can be gotten from them via the API.

    .PARAMETER id
        ID of tenant

    .EXAMPLE
        Get-AuvikTenant

        Pulls general information about multiple multi-clients and
        clients associated with your Auvik user account.

    .EXAMPLE
        Get-AuvikTenant -tenantDomainPrefix CeleriumMSP

        Pulls detailed information about multiple multi-clients and
        clients associated with your main Auvik account.

    .EXAMPLE
        Get-AuvikTenant -tenantDomainPrefix CeleriumMSP -id 123456789

        Pulls detailed information about a single tenant from
        your main Auvik account.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/clientManagement/Get-AuvikTenant.html
#>

    [CmdletBinding(DefaultParameterSetName = 'indexMultiTenant')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'indexMultiTenantDetails')]
        [Parameter(Mandatory = $true, ParameterSetName = 'indexSingleTenantDetails')]
        [ValidateNotNullOrEmpty()]
        [string]$tenantDomainPrefix,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexMultiTenantDetails')]
        [switch]$filter_availableTenants,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexSingleTenantDetails')]
        [ValidateNotNullOrEmpty()]
        [string]$id
    )

    begin {

        switch ( $($PSCmdlet.ParameterSetName) ) {
            'indexMultiTenant'          { $resource_uri = "/tenants" }
            'indexMultiTenantDetails'   { $resource_uri = "/tenants/detail" }
            'indexSingleTenantDetails'  { $resource_uri = "/tenants/detail/$id" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Region     [ Remove path parameters ]

        if( $PSBoundParameters.ContainsKey('id') ) {
            $PSBoundParameters.Remove('id') > $null
        }

        #EndRegion  [ Remove path parameters ]

        Set-Variable -Name 'Auvik_tenantParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}

}
