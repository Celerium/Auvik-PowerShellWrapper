function Invoke-AuvikRequest {
<#
    .SYNOPSIS
        Makes an API request

    .DESCRIPTION
        The Invoke-AuvikRequest cmdlet invokes an API request to Auvik API.

        This is an internal function that is used by all public functions

        As of 2023-08 the Auvik v1 API only supports GET requests

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'GET'

    .PARAMETER resource_Uri
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER uri_Filter
        Used with the internal function [ ConvertTo-AuvikQueryString ] to combine
        a functions parameters with the resource_Uri parameter.

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $Auvik_Base_URI + $resource_Uri + ConvertTo-AuvikQueryString

    .PARAMETER data
        Place holder parameter to use when other methods are supported
        by the Auvik v1 API

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Invoke-AuvikRequest -method GET -resource_Uri '/account' -uri_Filter $uri_Filter

        Invoke a rest method against the defined resource using any of the provided parameters

        Example:
            Name                           Value
            ----                           -----
            Method                         GET
            Uri                            https://auvikapi.us1.my.auvik.com/v1/account?accountId=12345&details=True
            Headers                        {Authorization = Bearer 123456789}
            Body


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Invoke-AuvikRequest.html

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('GET', 'POST')]
        [String]$method = 'GET',

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri,

        [Parameter(Mandatory = $false)]
        [Hashtable]$uri_Filter = $null,

        [Parameter(Mandatory = $false)]
        [Hashtable]$data = $null,

        [Parameter(Mandatory = $false)]
        [Switch]$allPages

    )

    begin {}

    process {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        $query_string = ConvertTo-AuvikQueryString -uri_Filter $uri_Filter -resource_Uri $resource_Uri

        Set-Variable -Name 'Auvik_queryString' -Value $query_string -Scope Global -Force

        if ($null -eq $data) {
            $body = $null
        } else {
            $body = @{'data'= $data} | ConvertTo-Json -Depth $Auvik_JSON_Conversion_Depth
        }

        try {
            $Api_Token = Get-AuvikAPIKey -PlainText
            $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).userName,($Api_Token).apiKey) ) )

            $parameters = [ordered] @{
                "Method"    = $method
                "Uri"       = $query_string.Uri
                "Headers"   = @{ 'Authorization' = 'Basic {0}'-f $Api_Token_base64 }
                "Body"      = $body
            }

                if ( $method -ne 'GET' ) {
                    $parameters['ContentType'] = 'application/vnd.api+json; charset=utf-8'
                }

            Set-Variable -Name 'Auvik_invokeParameters' -Value $parameters -Scope Global -Force

            if ($allPages){

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Gathering all items from [ $( $parameters.uri.LocalPath ) ] "

                $page_number = 1
                $all_responseData = [System.Collections.Generic.List[object]]::new()

                do {

                    $current_page = Invoke-RestMethod @parameters -ErrorAction Stop

                    Write-Verbose "[ $page_number ] of [ $($current_page.meta.totalPages) ] pages"

                        foreach ($item in $current_page.data){
                            $all_responseData.add($item)
                        }

                    $parameters.Remove('Uri') > $null
                    $parameters.Add('Uri',$current_page.links.next)

                    $page_number++

                } while ( $null -ne $current_page.links.next <#-and $current_page.meta.totalPages -ne 0#> )

            }
            else{
                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Gathering items from [ $( $parameters.uri.LocalPath ) ] "

                $api_response = Invoke-RestMethod @parameters -ErrorAction Stop
            }

        }
        catch {

            $exceptionError = $_.Exception.Message
            Write-Warning 'The [ Auvik_invokeParameters, Auvik_queryString, & Auvik_<CmdletName>Parameters ] variables can provide extra details'

            switch -Wildcard ($exceptionError) {
                '*308*' { Write-Error "Invoke-AuvikRequest : Permanent Redirect, check assigned region" }
                '*404*' { Write-Error "Invoke-AuvikRequest : Uri not found - [ $resource_Uri ]" }
                '*429*' { Write-Error 'Invoke-AuvikRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-AuvikRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }

        }
        finally {

            $Auth = $Auvik_invokeParameters['headers']['Authorization']
            $Auvik_invokeParameters['headers']['Authorization'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 9) ) + '*******'

        }


        if($allPages){

            #Making output consistent
            if( [string]::IsNullOrEmpty($all_responseData.data) ){
                $api_response = $null
            }
            else{
                $api_response = [PSCustomObject]@{
                    data    = $all_responseData
                    links   = $null
                    meta    = $null
                }
            }

            return $api_response

        }
        else{ return $api_response }

    }

    end {}

}