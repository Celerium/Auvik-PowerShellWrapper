---
external help file: AuvikAPI-help.xml
grand_parent: internal
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/internal/Get-AuvikModuleSettings.html
parent: GET
schema: 2.0.0
title: Get-AuvikModuleSettings
---

# Get-AuvikModuleSettings

## SYNOPSIS
Gets the saved Auvik configuration settings

## SYNTAX

### index (Default)
```powershell
Get-AuvikModuleSettings [-AuvikConfPath <String>] [-AuvikConfFile <String>] [<CommonParameters>]
```

### show
```powershell
Get-AuvikModuleSettings [-openConfFile] [<CommonParameters>]
```

## DESCRIPTION
The Get-AuvikModuleSettings cmdlet gets the saved Auvik configuration settings
from the local system.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\AuvikAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Get-AuvikModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-AuvikModuleSettings

The default location of the Auvik configuration file is:
    $env:USERPROFILE\AuvikAPI\config.psd1

### EXAMPLE 2
```powershell
Get-AuvikModuleSettings -AuvikConfPath C:\AuvikAPI -AuvikConfFile MyConfig.psd1 -openConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the Auvik configuration file in this example is:
    C:\AuvikAPI\MyConfig.psd1

## PARAMETERS

### -AuvikConfPath
Define the location to store the Auvik configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\AuvikAPI

```yaml
Type: String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"AuvikAPI"}else{".AuvikAPI"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuvikConfFile
Define the name of the Auvik configuration file.

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -openConfFile
Opens the Auvik configuration file

```yaml
Type: SwitchParameter
Parameter Sets: show
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikModuleSettings.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Get-AuvikModuleSettings.html)

