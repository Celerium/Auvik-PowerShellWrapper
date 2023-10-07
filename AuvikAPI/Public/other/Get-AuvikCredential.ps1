function Get-AuvikCredential {
<#
    .SYNOPSIS
        Verify that your credentials are correct before making a call to an endpoint.

    .DESCRIPTION
        The Get-AuvikCredential cmdlet Verifies that your
        credentials are correct before making a call to an endpoint.

    .EXAMPLE
        Get-AuvikCredential

        Pulls general information about multiple multi-clients and
        clients associated with your Auvik user account.

    .EXAMPLE
        Get-AuvikCredential

        Verify that your credentials are correct
        before making a call to an endpoint.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/other/Get-AuvikCredential.html
#>

    [CmdletBinding()]
    [alias('Test-AuvikAPIKey')]
    Param ()

    begin {

        $resource_uri = "/authentication/verify"

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $return = Invoke-AuvikRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -ErrorVariable restError

        if ( [string]::IsNullOrEmpty($return) -and [bool]$restError -eq $false ){
            $true
        }
        else{
            $false
        }

    }

    end {}

}
