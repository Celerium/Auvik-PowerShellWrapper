---
external help file: AuvikAPI-help.xml
grand_parent: billing
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/billing/Get-AuvikBilling.html
parent: GET
schema: 2.0.0
title: Get-AuvikBilling
---

# Get-AuvikBilling

## SYNOPSIS
Get Auvik billing information

## SYNTAX

### indexByClient (Default)
```powershell
Get-AuvikBilling -filter_fromDate <DateTime> -filter_thruDate <DateTime> [-tenants <String[]>]
 [<CommonParameters>]
```

### indexByDevice
```powershell
Get-AuvikBilling -filter_fromDate <DateTime> -filter_thruDate <DateTime> -id <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikBilling cmdlet gets billing information
to help calculate your invoices

The dataTime value are converted to UTC, however for these endpoints
you will only need to defined yyyy-MM-dd

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30
```

Pulls a summary of a client's (and client's children if a multi-client)
usage for the given time range.

### EXAMPLE 2
```powershell
Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30 -tenants 12345,98765
```

Pulls a summary of the defined client's (and client's children if a multi-client)
usage for the given time range.

### EXAMPLE 3
```powershell
Get-AuvikBilling -filter_fromDate 2023-09-01 -filter_thruDate 2023-09-30 -id 123456789
```

Pulls a summary of the define device id's usage for the given time range.

## PARAMETERS

### -filter_fromDate
Date from which you want to query

Example: filter\[fromDate\]=2019-06-01

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

### -filter_thruDate
Date to which you want to query

Example: filter\[thruDate\]=2019-06-30

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

### -tenants
Comma delimited list of tenant IDs to request info from.

Example: tenants=199762235015168516,199762235015168004

```yaml
Type: String[]
Parameter Sets: indexByClient
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -id
ID of device

```yaml
Type: String
Parameter Sets: indexByDevice
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Auvik-PowerShellWrapper/site/billing/Get-AuvikBilling.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/billing/Get-AuvikBilling.html)

