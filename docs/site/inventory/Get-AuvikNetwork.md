---
external help file: AuvikAPI-help.xml
grand_parent: inventory
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikNetwork.html
parent: GET
schema: 2.0.0
title: Get-AuvikNetwork
---

# Get-AuvikNetwork

## SYNOPSIS
Get Auvik networks and other related information

## SYNTAX

### indexByMultiNetworkGeneral (Default)
```powershell
Get-AuvikNetwork [-tenants <String[]>] [-filter_networkType <String>] [-filter_scanStatus <String>]
 [-filter_devices <String[]>] [-filter_modifiedAfter <DateTime>] [-include <String>]
 [-fields_networkDetail <String>] [-page_first <Int64>] [-page_after <String>] [-page_last <Int64>]
 [-page_before <String>] [-allPages] [<CommonParameters>]
```

### indexBySingleNetworkDetail
```powershell
Get-AuvikNetwork -id <String> [-details] [<CommonParameters>]
```

### indexBySingleNetworkGeneral
```powershell
Get-AuvikNetwork -id <String> [-include <String>] [-fields_networkDetail <String>] [-detailsGeneral]
 [<CommonParameters>]
```

### indexByMultiNetworkDetail
```powershell
Get-AuvikNetwork [-tenants <String[]>] [-filter_networkType <String>] [-filter_scanStatus <String>]
 [-filter_devices <String[]>] [-filter_modifiedAfter <DateTime>] [-filter_scope <String>] [-page_first <Int64>]
 [-page_after <String>] [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikNetwork cmdlet allows you to view an inventory of
networks and other related information discovered by Auvik.

Use the \[ -details & -detailsGeneral  \] parameters when wanting to target
specific information.
See Get-Help Get-AuvikNetwork -Full for
more information on associated parameters

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikNetwork
```

Pulls general information about the first 100 networks
Auvik has discovered

### EXAMPLE 2
```powershell
Get-AuvikNetwork -id 123456789 -detailsGeneral
```

Pulls general information for the defined network
Auvik has discovered

### EXAMPLE 3
```powershell
Get-AuvikNetwork -details
```

Pulls detailed information about the first 100 networks
Auvik has discovered

### EXAMPLE 4
```powershell
Get-AuvikNetwork -id 123456789 -details
```

Pulls details information for the defined network
Auvik has discovered

### EXAMPLE 5
```powershell
Get-AuvikNetwork -page_first 1000 -allPages
```

Pulls general information for all networks found by Auvik.

## PARAMETERS

### -id
ID of network

```yaml
Type: String
Parameter Sets: indexBySingleNetworkDetail, indexBySingleNetworkGeneral
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -tenants
Comma delimited list of tenant IDs to request info from

```yaml
Type: String[]
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_networkType
Filter by network type

Allowed values:
    "routed", "vlan", "wifi", "loopback", "network", "layer2", "internet"

```yaml
Type: String
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_scanStatus
Filter by the network's scan status

Allowed values:
    "true", "false", "notAllowed", "unknown"

```yaml
Type: String
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_devices
Filter by IDs of devices on this network

Filter by multiple values by providing a comma delimited list

```yaml
Type: String[]
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_modifiedAfter
Filter by date and time, only returning entities modified after provided value

```yaml
Type: DateTime
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_scope
Filter by the network's scope

Allowed values:
    "private", "public"

```yaml
Type: String
Parameter Sets: indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -include
Use to include the full resource objects of the list device relationships

Example: include=deviceDetail

```yaml
Type: String
Parameter Sets: indexByMultiNetworkGeneral, indexBySingleNetworkGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -fields_networkDetail
Use to limit the attributes that will be returned in the included detail
object to only what is specified by this query parameter.

Allowed values:
    "scope", "primaryCollector", "secondaryCollectors", "collectorSelection", "excludedIpAddresses"

Requires include=networkDetail

```yaml
Type: String
Parameter Sets: indexByMultiNetworkGeneral, indexBySingleNetworkGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -details
Target the details endpoint

/inventory/network/info & /inventory/network/info/{id}

```yaml
Type: SwitchParameter
Parameter Sets: indexBySingleNetworkDetail
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -detailsGeneral
Target the general details endpoint

/inventory/network/detail & /inventory/network/detail/{id}

```yaml
Type: SwitchParameter
Parameter Sets: indexBySingleNetworkGeneral
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_first
For paginated responses, the first N elements will be returned
Used in combination with page\[after\]

Default Value: 100

```yaml
Type: Int64
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_after
Cursor after which elements will be returned as a page
The page size is provided by page\[first\]

```yaml
Type: String
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_last
For paginated responses, the last N services will be returned
Used in combination with page\[before\]

Default Value: 100

```yaml
Type: Int64
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_before
Cursor before which elements will be returned as a page
The page size is provided by page\[last\]

```yaml
Type: String
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allPages
Returns all items from an endpoint

Highly recommended to only use with filters to reduce API errors\timeouts

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiNetworkGeneral, indexByMultiNetworkDetail
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikNetwork.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikNetwork.html)

