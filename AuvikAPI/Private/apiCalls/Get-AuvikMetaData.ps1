function Get-AuvikMetaData {
<#
    .SYNOPSIS
        Gets various Api metadata values

    .DESCRIPTION
        The Get-AuvikMetaData cmdlet gets various Api metadata values from an
        Invoke-WebRequest to assist in various troubleshooting scenarios such
        as rate-limiting.

    .PARAMETER base_uri
        Define the base URI for the Auvik API connection using Auvik's URI or a custom URI.

        The default base URI is https://auvikapi.us1.my.auvik.com/v1

    .EXAMPLE
        Get-AuvikMetaData

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The default full base uri test path is:
            https://auvikapi.us1.my.auvik.com/v1

    .EXAMPLE
        Get-AuvikMetaData -base_uri http://myapi.gateway.example.com

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikMetaData.html
#>

    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$base_uri = $Auvik_Base_URI
    )

    begin { $resource_uri = "/authentication/verify" }

    process {

        try {

            $Api_Token = Get-AuvikAPIKey -plainText
            $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).userName,($Api_Token).apiKey) ) )

            $Auvik_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $Auvik_Headers.Add("Content-Type", 'application/json')
            $Auvik_Headers.Add('Authorization', 'Basic {0}'-f $Api_Token_base64)

            $rest_output = Invoke-WebRequest -method Get -uri ($base_uri + $resource_uri) -headers $Auvik_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method = $_.Exception.Response.Method
                StatusCode = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.StatusDescription
                Message = $_.Exception.Message
                URI = $($Auvik_Base_URI + $resource_uri)
            }

        }
        finally {
            Remove-Variable -Name Auvik_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                ResponseUri             = $data.BaseResponse.ResponseUri.AbsoluteUri
                ResponsePort            = $data.BaseResponse.ResponseUri.Port
                StatusCode              = $data.StatusCode
                StatusDescription       = $data.StatusDescription
                'Content-Type'          = $data.headers.'Content-Type'
                'X-Request-Id'          = $data.headers.'X-Request-Id'
                'X-API-Limit-Remaining' = $data.headers.'X-API-Limit-Remaining'
                'X-API-Limit-Resets'    = $data.headers.'X-API-Limit-Resets'
                'X-API-Limit-Cost'      = $data.headers.'X-API-Limit-Cost'
                raw                     = $data
            }
        }

    }

    end {}
}