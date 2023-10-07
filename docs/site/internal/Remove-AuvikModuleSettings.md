---
external help file: AuvikAPI-help.xml
grand_parent: internal
Module Name: AuvikAPI
online version: https://celerium.github.io/Auvik-PowerShellWrapper/site/internal/Remove-AuvikModuleSettings.html
parent: DELETE
schema: 2.0.0
title: Remove-AuvikModuleSettings
---

# Remove-AuvikModuleSettings

## SYNOPSIS
Removes the stored Auvik configuration folder.

## SYNTAX

```powershell
Remove-AuvikModuleSettings [-AuvikConfPath <String>] [-andVariables] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-AuvikModuleSettings cmdlet removes the Auvik folder and its files.
This cmdlet also has the option to remove sensitive Auvik variables as well.

By default configuration files are stored in the following location and will be removed:
    $env:USERPROFILE\AuvikAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-AuvikModuleSettings
```

Checks to see if the default configuration folder exists and removes it if it does.

The default location of the Auvik configuration folder is:
    $env:USERPROFILE\AuvikAPI

### EXAMPLE 2
```powershell
Remove-AuvikModuleSettings -AuvikConfPath C:\AuvikAPI -andVariables
```

Checks to see if the defined configuration folder exists and removes it if it does.
If sensitive Auvik variables exist then they are removed as well.

The location of the Auvik configuration folder in this example is:
    C:\AuvikAPI

## PARAMETERS

### -AuvikConfPath
Define the location of the Auvik configuration folder.

By default the configuration folder is located at:
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

### -andVariables
Define if sensitive Auvik variables should be removed as well.

By default the variables are not removed.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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

[https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Remove-AuvikModuleSettings.html](https://celerium.github.io/Auvik-PowerShellWrapper/site/Internal/Remove-AuvikModuleSettings.html)

