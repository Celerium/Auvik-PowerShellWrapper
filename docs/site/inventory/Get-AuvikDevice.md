---
external help file: AuvikAPI-help.xml
grand_parent: inventory
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDevice.html
parent: GET
schema: 2.0.0
title: Get-AuvikDevice
---

# Get-AuvikDevice

## SYNOPSIS
Get Auvik devices and other related information

## SYNTAX

### indexByMultiDeviceGeneral (Default)
```powershell
Get-AuvikDevice [-tenants <String[]>] [-filter_networks <String>] [-filter_deviceType <String>]
 [-filter_makeModel <String>] [-filter_vendorName <String>] [-filter_onlineStatus <String>]
 [-filter_modifiedAfter <DateTime>] [-filter_notSeenSince <DateTime>] [-include <String>]
 [-fields_deviceDetail <String>] [-detailsGeneral] [-page_first <Int64>] [-page_after <String>]
 [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

### indexBySingleDeviceExtDetail
```powershell
Get-AuvikDevice -id <String> [-detailsExtended] [<CommonParameters>]
```

### indexBySingleDeviceDetail
```powershell
Get-AuvikDevice -id <String> [-details] [<CommonParameters>]
```

### indexBySingleDeviceGeneral
```powershell
Get-AuvikDevice -id <String> [-include <String>] [-fields_deviceDetail <String>] [-detailsGeneral]
 [<CommonParameters>]
```

### indexByMultiDeviceExtDetail
```powershell
Get-AuvikDevice [-tenants <String[]>] -filter_deviceType <String> [-filter_modifiedAfter <DateTime>]
 [-filter_notSeenSince <DateTime>] [-detailsExtended] [-page_first <Int64>] [-page_after <String>]
 [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

### indexByMultiDeviceDetail
```powershell
Get-AuvikDevice [-tenants <String[]>] [-filter_manageStatus] [-filter_discoverySNMP <String>]
 [-filter_discoveryWMI <String>] [-filter_discoveryLogin <String>] [-filter_discoveryVMware <String>]
 [-filter_trafficInsightsStatus <String>] [-details] [-page_first <Int64>] [-page_after <String>]
 [-page_last <Int64>] [-page_before <String>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikDevice cmdlet allows you to view an inventory of
devices and other related information discovered by Auvik.

Use the \[ -details, -detailsExtended, & -detailsGeneral  \] parameters
when wanting to target specific information.

See Get-Help Get-AuvikDevice -Full for more information on associated parameters

This function combines 6 endpoints together within the Device API.

Read Multiple Devices' Info:
    Pulls detail about multiple devices discovered on your client's network.
Read a Single Device's Info:
    Pulls detail about a specific device discovered on your client's network.

Read Multiple Devices' Details:
    Pulls details about multiple devices not already included in the Device Info API.
Read a Single Device's Details:
    Pulls details about a specific device not already included in the Device Info API.

Read Multiple Device's Extended Details:
    Pulls extended information about multiple devices not already included in the Device Info API.
Read a Single Device's Extended Details:
    Pulls extended information about a specific device not already included in the Device Info API.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikDevice
```

Pulls general information about the first 100 devices
Auvik has discovered

### EXAMPLE 2
```powershell
Get-AuvikDevice -id 123456789 -detailsGeneral
```

Pulls general information for the defined device
Auvik has discovered

### EXAMPLE 3
```powershell
Get-AuvikDevice -details
```

Pulls detailed information about the first 100 devices
Auvik has discovered

### EXAMPLE 4
```powershell
Get-AuvikDevice -id 123456789 -details
```

Pulls details information for the defined device
Auvik has discovered

### EXAMPLE 5
```powershell
Get-AuvikDevice -detailsExtended
```

Pulls extended detail information about the first 100 devices
Auvik has discovered

### EXAMPLE 6
```powershell
Get-AuvikDevice -id 123456789 -detailsExtended
```

Pulls extended detail information for the defined device
Auvik has discovered

### EXAMPLE 7
```powershell
Get-AuvikDevice -page_first 1000 -allPages
```

Pulls general information for all devices found by Auvik.

## PARAMETERS

### -id
ID of device

```yaml
Type: String
Parameter Sets: indexBySingleDeviceExtDetail, indexBySingleDeviceDetail, indexBySingleDeviceGeneral
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
Parameter Sets: indexByMultiDeviceGeneral, indexByMultiDeviceExtDetail, indexByMultiDeviceDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_networks
Filter by IDs of networks this device is on

```yaml
Type: String
Parameter Sets: indexByMultiDeviceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_manageStatus
Filter by managed status

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiDeviceDetail
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_discoverySNMP
Filter by the device's SNMP discovery status

Allowed values:
    "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

```yaml
Type: String
Parameter Sets: indexByMultiDeviceDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_discoveryWMI
Filter by the device's WMI discovery status

Allowed values:
    "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

```yaml
Type: String
Parameter Sets: indexByMultiDeviceDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_discoveryLogin
Filter by the device's Login discovery status

Allowed values:
    "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

```yaml
Type: String
Parameter Sets: indexByMultiDeviceDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_discoveryVMware
Filter by the device's VMware discovery status

Allowed values:
    "disabled", "determining", "notSupported", "notAuthorized", "authorizing", "authorized", "privileged"

```yaml
Type: String
Parameter Sets: indexByMultiDeviceDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_trafficInsightsStatus
Filter by the device's VMware discovery status

Allowed values:
    "notDetected", "detected", "notApproved", "approved", "linking", "linkingFailed", "forwarding"

```yaml
Type: String
Parameter Sets: indexByMultiDeviceDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_deviceType
Filter by device type

Allowed values:
    "accessPoint", "airConditioner", "alarm", "audioVisual", "backhaul", "backupDevice",
    "bridge", "buildingManagement", "camera", "chassis", "controller", "copier", "firewall",
    "handheld", "hub", "hypervisor", "internetOfThings", "ipmi", "ipPhone", "l3Switch",
    "lightingDevice", "loadBalancer", "modem", "module", "multimedia", "packetProcessor",
    "pdu", "phone", "printer", "router", "securityAppliance", "server", "stack", "storage",
    "switch", "tablet", "telecommunications", "thinAccessPoint", "thinClient", "timeClock",
    "unknown", "ups", "utm", "virtualAppliance", "virtualMachine", "voipSwitch", "workstation"

```yaml
Type: String
Parameter Sets: indexByMultiDeviceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: indexByMultiDeviceExtDetail
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_makeModel
Filter by the device's make and model

```yaml
Type: String
Parameter Sets: indexByMultiDeviceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_vendorName
Filter by the device's vendor/manufacturer

```yaml
Type: String
Parameter Sets: indexByMultiDeviceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_onlineStatus
Filter by the device's online status

Allowed values:
"online", "offline", "unreachable", "testing", "unknown", "dormant", "notPresent", "lowerLayerDown"

```yaml
Type: String
Parameter Sets: indexByMultiDeviceGeneral
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
Parameter Sets: indexByMultiDeviceGeneral, indexByMultiDeviceExtDetail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_notSeenSince
Filter by the last seen online time, returning entities not seen online after the provided value

```yaml
Type: DateTime
Parameter Sets: indexByMultiDeviceGeneral, indexByMultiDeviceExtDetail
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
Parameter Sets: indexByMultiDeviceGeneral, indexBySingleDeviceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -fields_deviceDetail
Use to limit the attributes that will be returned in the included detail object to
only what is specified by this query parameter

Requires include=deviceDetail

```yaml
Type: String
Parameter Sets: indexByMultiDeviceGeneral, indexBySingleDeviceGeneral
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -details
Target the details endpoint

/inventory/device/detail & /inventory/device/detail/{id}

```yaml
Type: SwitchParameter
Parameter Sets: indexBySingleDeviceDetail, indexByMultiDeviceDetail
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -detailsExtended
Target the extended details endpoint

/inventory/device/detail/extended & /inventory/device/detail/extended/{id}

```yaml
Type: SwitchParameter
Parameter Sets: indexBySingleDeviceExtDetail, indexByMultiDeviceExtDetail
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -detailsGeneral
Target the general details endpoint

Only needed when limiting general search by id, to give the parameter
set a unique value.

/inventory/device/info & /inventory/device/info

```yaml
Type: SwitchParameter
Parameter Sets: indexByMultiDeviceGeneral, indexBySingleDeviceGeneral
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
Parameter Sets: indexByMultiDeviceGeneral, indexByMultiDeviceExtDetail, indexByMultiDeviceDetail
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
Parameter Sets: indexByMultiDeviceGeneral, indexByMultiDeviceExtDetail, indexByMultiDeviceDetail
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
Parameter Sets: indexByMultiDeviceGeneral, indexByMultiDeviceExtDetail, indexByMultiDeviceDetail
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
Parameter Sets: indexByMultiDeviceGeneral, indexByMultiDeviceExtDetail, indexByMultiDeviceDetail
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
Parameter Sets: indexByMultiDeviceGeneral, indexByMultiDeviceExtDetail, indexByMultiDeviceDetail
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDevice.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/inventory/Get-AuvikDevice.html)

