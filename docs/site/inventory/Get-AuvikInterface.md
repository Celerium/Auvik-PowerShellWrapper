---
external help file: AuvikAPI-help.xml
grand_parent: inventory
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikInterface.html
parent: GET
schema: 2.0.0
title: Get-AuvikInterface
---

# Get-AuvikInterface

## SYNOPSIS
Get Auvik interfaces and other related information

## SYNTAX

### indexByMultiInterfaceGeneral (Default)
```powershell
Get-AuvikInterface [-tenants <String[]>] [-filter_interfaceType <String>] [-filter_parentDevice <String>]
 [-filter_adminStatus] [-filter_operationalStatus <String>] [-filter_modifiedAfter <DateTime>]
 [-page_first <Int64>] [-page_after <String>] [-page_last <Int64>] [-page_before <String>] [-allPages]
 [<CommonParameters>]
```

### indexBySingleInterfaceGeneral
```powershell
Get-AuvikInterface -id <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikInterface cmdlet allows you to view an inventory of
interfaces and other related information discovered by Auvik.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikInterface
```

Pulls general information about the first 100 interfaces
Auvik has discovered

### EXAMPLE 2
```powershell
Get-AuvikInterface -id 123456789
```

Pulls general information for the defined interface
Auvik has discovered

### EXAMPLE 3
```powershell
Get-AuvikInterface -page_first 1000 -allPages
```

Pulls general information for all interfaces found by Auvik.

## PARAMETERS

### -id
ID of interface

```yaml
Type: String
Parameter Sets: indexBySingleInterfaceGeneral
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
Parameter Sets: indexByMultiInterfaceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_interfaceType
Filter by interface type

Allowed values:
    "ethernet", "wifi", "bluetooth", "cdma", "coax", "cpu", "distributedVirtualSwitch",
    "firewire", "gsm", "ieee8023AdLag", "inferredWired", "inferredWireless", "interface",
    "linkAggregation", "loopback", "modem", "wimax", "optical", "other", "parallel", "ppp",
    "radiomac", "rs232", "tunnel", "unknown", "usb", "virtualBridge", "virtualNic",
    "virtualSwitch", "vlan"

```yaml
Type: String
Parameter Sets: indexByMultiInterfaceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_parentDevice
Filter by the entity's parent device ID

```yaml
Type: String
Parameter Sets: indexByMultiInterfaceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_adminStatus
Filter by the interface's admin status

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiInterfaceGeneral
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_operationalStatus
Filter by the interface's operational status

Allowed values:
    "online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

```yaml
Type: String
Parameter Sets: indexByMultiInterfaceGeneral
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
Parameter Sets: indexByMultiInterfaceGeneral
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
Parameter Sets: indexByMultiInterfaceGeneral
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
Parameter Sets: indexByMultiInterfaceGeneral
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
Parameter Sets: indexByMultiInterfaceGeneral
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
Parameter Sets: indexByMultiInterfaceGeneral
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
Parameter Sets: indexByMultiInterfaceGeneral
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikInterface.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikInterface.html)

