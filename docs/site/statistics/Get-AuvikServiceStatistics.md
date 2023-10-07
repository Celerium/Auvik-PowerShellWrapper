---
external help file: AuvikAPI-help.xml
grand_parent: statistics
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikServiceStatistics.html
parent: GET
schema: 2.0.0
title: Get-AuvikServiceStatistics
---

# Get-AuvikServiceStatistics

## SYNOPSIS
Provides historical cloud ping check statistics.

## SYNTAX

```powershell
Get-AuvikServiceStatistics -statId <String> [-tenants <String[]>] -filter_fromTime <DateTime>
 [-filter_thruTime <DateTime>] -filter_interval <String> [-filter_serviceId <String>] [-page_first <Int64>]
 [-page_after <String>] [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikServiceStatistics cmdlet provides historical
cloud ping check statistics.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikServiceStatistics -statId pingTime -filter_fromTime 2023-10-03 -filter_interval day
```

Provides the first 100 historical cloud ping check statistics.

### EXAMPLE 2
```powershell
Get-AuvikServiceStatistics -statId pingTime -filter_fromTime 2023-10-03 -filter_interval day -page_first 1000 -allPages
```

Provides all historical cloud ping check statistics.

## PARAMETERS

### -statId
ID of statistic to return

Allowed values:
    "pingTime", "pingPacket"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenants
Comma delimited list of tenant IDs to request info from

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

### -filter_interval
Statistics reporting interval

Allowed values:
    "minute", "hour", "day"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_serviceId
Filter by service ID

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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikServiceStatistics.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/statistics/Get-AuvikServiceStatistics.html)

