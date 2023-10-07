---
external help file: AuvikAPI-help.xml
grand_parent: poolers
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/poolers/Get-AuvikSNMPPolllerHistory.html
parent: GET
schema: 2.0.0
title: Get-AuvikSNMPPolllerHistory
---

# Get-AuvikSNMPPolllerHistory

## SYNOPSIS
Get Auvik historical values of SNMP Poller settings

## SYNTAX

### indexByStringSNMP (Default)
```powershell
Get-AuvikSNMPPolllerHistory -tenants <String[]> -filter_fromTime <DateTime> [-filter_thruTime <DateTime>]
 [-filter_compact] [-filter_deviceId <String>] [-filter_snmpPollerSettingId <String[]>] [-page_first <Int64>]
 [-page_after <String>] [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

### indexByNumericSNMP
```powershell
Get-AuvikSNMPPolllerHistory -tenants <String[]> -filter_fromTime <DateTime> [-filter_thruTime <DateTime>]
 -filter_interval <String> [-filter_deviceId <String>] [-filter_snmpPollerSettingId <String[]>]
 [-page_first <Int64>] [-page_after <String>] [-page_last <Int64>] [-page_before <String>] [-allPages]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikSNMPPolllerHistory cmdlet allows you to view
historical values of SNMP Poller settings

There are two endpoints available in the SNMP Poller History API.

Read String SNMP Poller Setting History:
    Provides historical values of String SNMP Poller Settings.
Read Numeric SNMP Poller Setting History:
    Provides historical values of Numeric SNMP Poller Settings.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789
```

Pulls general information about the first 100 historical SNMP
string poller settings

### EXAMPLE 2
```powershell
Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789 -filter_interval day
```

Pulls general information about the first 100 historical SNMP
numerical poller settings

### EXAMPLE 3
```powershell
Get-AuvikSNMPPolllerHistory -filter_fromTime 2023-10-01 -tenants 123456789 -page_first 1000 -allPages
```

Pulls general information about all historical SNMP
string poller settings

## PARAMETERS

### -tenants
Comma delimited list of tenant IDs to request info from

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_fromTime
Timestamp from which you want to query

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_thruTime
Timestamp to which you want to query (defaults to current time)

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_compact
Whether to show compact view of the results or not.

Compact view only shows changes in value.
If compact view is false, dateTime range can be a maximum of 24h

```yaml
Type: SwitchParameter
Parameter Sets: indexByStringSNMP
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_interval
Statistics reporting interval

Allowed values:
    "minute", "hour", "day"

```yaml
Type: String
Parameter Sets: indexByNumericSNMP
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_deviceId
Filter by device ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_snmpPollerSettingId
Comma delimited list of SNMP poller setting IDs to request info from.

Note this is internal snmpPollerSettingId.
The user can get the list of IDs for a specific poller using the
GET /settings/snmppoller endpoint.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -page_first
For paginated responses, the first N elements will be returned
Used in combination with page\[after\]

Default Value: 100

```yaml
Type: Int64
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/poolers/Get-AuvikSNMPPolllerHistory.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/poolers/Get-AuvikSNMPPolllerHistory.html)

