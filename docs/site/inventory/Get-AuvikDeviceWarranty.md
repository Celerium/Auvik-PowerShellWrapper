---
external help file: AuvikAPI-help.xml
grand_parent: inventory
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDeviceWarranty.html
parent: GET
schema: 2.0.0
title: Get-AuvikDeviceWarranty
---

# Get-AuvikDeviceWarranty

## SYNOPSIS
Get Auvik devices and other related information

## SYNTAX

### indexByMultiDevice (Default)
```powershell
Get-AuvikDeviceWarranty [-tenants <String[]>] [-filter_coveredUnderWarranty] [-filter_coveredUnderService]
 [-page_first <Int64>] [-page_after <String>] [-page_last <Int64>] [-page_before <String>] [-allPages]
 [<CommonParameters>]
```

### indexBySingleDevice
```powershell
Get-AuvikDeviceWarranty -id <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikDeviceWarranty cmdlet allows you to view an inventory of
devices and other related information discovered by Auvik.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikDeviceWarranty
```

Pulls general warranty information about the first 100 devices
Auvik has discovered

### EXAMPLE 2
```powershell
Get-AuvikDeviceWarranty -id 123456789
```

Pulls general warranty information for the defined device
Auvik has discovered

### EXAMPLE 3
```powershell
Get-AuvikDeviceWarranty -page_first 1000 -allPages
```

Pulls general warranty information for all devices found by Auvik.

## PARAMETERS

### -id
ID of device

```yaml
Type: String
Parameter Sets: indexBySingleDevice
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
Parameter Sets: indexByMultiDevice
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_coveredUnderWarranty
Filter by warranty coverage status

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiDevice
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_coveredUnderService
Filter by service coverage status

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiDevice
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
Parameter Sets: indexByMultiDevice
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
Parameter Sets: indexByMultiDevice
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
Parameter Sets: indexByMultiDevice
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
Parameter Sets: indexByMultiDevice
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
Parameter Sets: indexByMultiDevice
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDeviceWarranty.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDeviceWarranty.html)

