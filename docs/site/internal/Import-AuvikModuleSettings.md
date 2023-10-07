---
external help file: AuvikAPI-help.xml
grand_parent: internal
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/internal/Import-AuvikModuleSettings.html
parent: GET
schema: 2.0.0
title: Import-AuvikModuleSettings
---

# Import-AuvikModuleSettings

## SYNOPSIS
Imports the Auvik BaseURI, API, & JSON configuration information to the current session.

## SYNTAX

```powershell
Import-AuvikModuleSettings [-AuvikConfPath <String>] [-AuvikConfFile <String>] [<CommonParameters>]
```

## DESCRIPTION
The Import-AuvikModuleSettings cmdlet imports the Auvik BaseURI, API, & JSON configuration
information stored in the Auvik configuration file to the users current session.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\AuvikAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Import-AuvikModuleSettings
```

Validates that the configuration file created with the Export-AuvikModuleSettings cmdlet exists
then imports the stored data into the current users session.

The default location of the Auvik configuration file is:
    $env:USERPROFILE\AuvikAPI\config.psd1

### EXAMPLE 2
```powershell
Import-AuvikModuleSettings -AuvikConfPath C:\AuvikAPI -AuvikConfFile MyConfig.psd1
```

Validates that the configuration file created with the Export-AuvikModuleSettings cmdlet exists
then imports the stored data into the current users session.

The location of the Auvik configuration file in this example is:
    C:\AuvikAPI\MyConfig.psd1

## PARAMETERS

### -AuvikConfPath
Define the location to store the Auvik configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\AuvikAPI

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Config.psd1
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Import-AuvikModuleSettings.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Import-AuvikModuleSettings.html)

