function ConvertTo-AuvikQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-AuvikRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-AuvikRequest & any public functions that define parameters

    .PARAMETER uri_Filter
        Hashtable of values to combine a functions parameters with
        the resource_Uri parameter.

        This allows for the full uri query to occur

    .PARAMETER resource_Uri
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-AuvikQueryString -uri_Filter $uri_Filter -resource_Uri '/account'

        Example: (From public function)
            $uri_Filter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
                if( $excludedParameters -contains $Key.Key ){$null}
                else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://auvikapi.us1.my.auvik.com/v1/account?accountId=12345
            2x key = https://auvikapi.us1.my.auvik.com/v1/account?accountId=12345&details=True

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/ConvertTo-AuvikQueryString.html

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [hashtable]$uri_Filter,

    [Parameter(Mandatory = $true)]
    [String]$resource_Uri
)

    begin {}

    process {

        if (-not $uri_Filter) {
            return ""
        }

        $excludedParameters =   'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
                                'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
                                'allPages', 'details', 'detailsExtended', 'detailsGeneral', 'audits', 'notes'

        $convertParameters = 'fields_', 'filter_', 'page_'

        $query_Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

        ForEach ( $Key in $uri_Filter.GetEnumerator() ){

            $new_KeyName = $null
            foreach ( $convertParameter in $convertParameters ){

                if ( $Key.Key -like "$convertParameter*" ) {
                    $split_KeyName  = $Key.Key -split '_'
                    $new_KeyName    = "$($split_KeyName[0])[$($split_KeyName[1])]"
                }

            }


            if ( $excludedParameters -contains $Key.Key ){ $null }
            elseif ( $Key.Value.GetType().IsArray ){

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - [ $($Key.Key) ] is an array parameter"

                foreach ($Value in $Key.Value) {
                    if ($new_KeyName){  $query_Parameters.Add($new_KeyName, $Value) }
                    else{               $query_Parameters.Add($Key.Key, $Value)     }
                }

            }
            elseif ( $Key.Value.GetType().FullName -eq 'System.DateTime' ){

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - [ $($Key.Key) ] is a dateTime parameter"

                if ($Key.Key -like "*fromDate*" -or $Key.Key -like "*thruDate*" ){
                    $universalTime = ($Key.Value).ToUniversalTime().ToString('yyyy-MM-dd')
                }
                else{
                    $universalTime = ($Key.Value).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                }

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Converting [ $($Key.Value) ] to [ $universalTime ]"
                if ($new_KeyName){  $query_Parameters.Add($new_KeyName, $universalTime) }
                else{               $query_Parameters.Add($Key.Key, $universalTime) }

            }
            else{

                if ($new_KeyName){  $query_Parameters.Add($new_KeyName, $Key.Value) }
                else{               $query_Parameters.Add($Key.Key, $Key.Value)     }

            }

        }

        # Build the request and load it with the query string.
        $uri_Request        = [System.UriBuilder]($Auvik_Base_URI + $resource_Uri)
        $uri_Request.Query  = $query_Parameters.ToString()

        return $uri_Request

    }

    end {}

}