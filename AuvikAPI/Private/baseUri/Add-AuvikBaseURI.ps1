function Add-AuvikBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the Auvik API connection.

    .DESCRIPTION
        The Add-AuvikBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the Auvik API connection using Auvik's URI or a custom URI.

    .PARAMETER data_center
        Auvik's URI connection point that can be one of the predefined data centers.

        https://support.auvik.com/hc/en-us/articles/360033412992

        Accepted Values:
        'au1', 'ca1', 'eu1', 'eu2', 'us1', 'us2', 'us3', 'us4'

        Example:
            us3 = https://auvikapi.us3.my.auvik.com/v1

    .EXAMPLE
        Add-AuvikBaseURI

        The base URI will use https://auvikapi.us1.my.auvik.com/v1 which is Auvik's default URI.

    .EXAMPLE
        Add-AuvikBaseURI -data_center US

        The base URI will use https://auvikapi.us1.my.auvik.com/v1 which is Auvik's US URI.

    .EXAMPLE
        Add-AuvikBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to Auvik's API.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Add-AuvikBaseURI.html
#>

    [cmdletbinding()]
    [alias('Set-AuvikBaseURI')]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$base_uri = 'https://auvikapi.us1.my.auvik.com/v1',

        [Parameter(Mandatory = $false)]
        [ValidateSet( 'au1', 'ca1', 'eu1', 'eu2', 'us1', 'us2', 'us3', 'us4' )]
        [String]$data_center
    )

    begin {}

    process {

        # Trim superfluous forward slash from address (if applicable)
        if ($base_uri[$base_uri.Length-1] -eq "/") {
            $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
        }

        if ($data_center){
            $base_uri = "https://auvikapi.$data_center.my.auvik.com/v1"
        }

        Set-Variable -Name "Auvik_Base_URI" -Value $base_uri -Option ReadOnly -Scope global -Force

    }

    end {}

}