**Attention: This module has been migrated to the [Celerium.Auvik](https://github.com/Celerium/Celerium.Auvik) module as of 2025-03-01.**



<h1 align="center">
  <br>
  <a href="http://Celerium.org"><img src="https://raw.githubusercontent.com/Celerium/Auvik-PowerShellWrapper/main/.github/images/Celerium_PoSHGallery_AuvikAPI.png" alt="_CeleriumDemo" width="200"></a>
  <br>
  Celerium_AuvikAPI
  <br>
</h1>

[![Az_Pipeline][Az_Pipeline-shield]][Az_Pipeline-url]
[![GitHub_Pages][GitHub_Pages-shield]][GitHub_Pages-url]

[![PoshGallery_Version][PoshGallery_Version-shield]][PoshGallery_Version-url]
[![PoshGallery_Platforms][PoshGallery_Platforms-shield]][PoshGallery_Platforms-url]
[![PoshGallery_Downloads][PoshGallery_Downloads-shield]][PoshGallery_Downloads-url]
[![codeSize][codeSize-shield]][codeSize-url]

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]

[![Blog][Website-shield]][Website-url]
[![GitHub_License][GitHub_License-shield]][GitHub_License-url]

---

## Buy me a coffee

Whether you use this project, have learned something from it, or just like it, please consider supporting it by buying me a coffee, so I can dedicate more time on open-source projects like this :)

<a href="https://www.buymeacoffee.com/Celerium" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg" alt="Buy Me A Coffee" style="width:150px;height:50px;"></a>

---

<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://celerium.org">
    <img src="https://raw.githubusercontent.com/Celerium/Auvik-PowerShellWrapper/main/.github/images/Celerium_PoSHGitHub_AuvikAPI.png" alt="Logo">
  </a>

  <p align="center">
    <a href="https://www.powershellgallery.com/packages/AuvikAPI" target="_blank">PowerShell Gallery</a>
    ·
    <a href="https://github.com/Celerium/Auvik-PowerShellWrapper/issues/new/choose" target="_blank">Report Bug</a>
    ·
    <a href="https://github.com/Celerium/Auvik-PowerShellWrapper/issues/new/choose" target="_blank">Request Feature</a>
  </p>
</div>

---

<!-- TABLE OF CONTENTS
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>
-->

## About The Project

The [AuvikAPI](https://auvikapi.us1.my.auvik.com/docs) offers users the ability to extract data from Auvik into third-party reporting tools and aims to abstract away the details of interacting with Auvik's API endpoints in such a way that is consistent with PowerShell nomenclature. This gives system administrators and PowerShell developers a convenient and familiar way of using Auvik's API to create documentation scripts, automation, and integrations.

- :book: Project documentation can be found on [Github Pages](https://celerium.github.io/Auvik-PowerShellWrapper/)
- :book: Auvik's REST API documentation on their management portal [here](https://auvikapi.us1.my.auvik.com/docs).

Auvik features a REST API that makes use of common HTTPs GET actions. In order to maintain PowerShell best practices, only approved verbs are used.

- GET  -> Get-
- POST -> Clear-

Additionally, PowerShell's `verb-noun` nomenclature is respected. Each noun is prefixed with `Auvik` in an attempt to prevent naming problems.

For example, one might access the `/tenants` endpoint by running the following PowerShell command with the appropriate parameters:

```posh
Get-AuvikTenant
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Install

This module can be installed directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/AuvikAPI) with the following command:

```posh
Install-Module -Name AuvikAPI
```

- :information_source: This module supports PowerShell 5.0+ and *should* work in PowerShell Core.
- :information_source: If you are running an older version of PowerShell, or if PowerShellGet is unavailable, you can manually download the *main* branch and place the *AuvikAPI* folder into the (default) `C:\Program Files\WindowsPowerShell\Modules` folder.

Project documentation can be found on [Github Pages](https://celerium.github.io/Auvik-PowerShellWrapper/)

- A full list of functions can be retrieved by running `Get-Command -Module AuvikAPI`.
- Help info and a list of parameters can be found by running `Get-Help <command name>`, such as:

```posh
Get-Help Get-AuvikTenant
Get-Help Get-AuvikTenant -Full
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Initial Setup

After installing this module, you will need to configure both the *base URI* & *API access tokens* that are used to talk with the Auvik API.

1. Run `Add-AuvikBaseURI`
   - By default, Auvik's `https://auvikapi.us1.my.auvik.com/v1` URI is used.
   - If you have your own API gateway or proxy, you may put in your own custom URI by specifying the `-base_uri` parameter:
      - `Add-AuvikBaseURI -base_uri http://myapi.gateway.celerium.org`
<br>

2. Run `Add-AuvikAPIKey -Api_UserName 12345 -Api_Key 123456789`
   - It will prompt you to enter your API access tokens if you do not specify them.
   - Auvik API access tokens are generated via the [Auvik portal](https://support.auvik.com/hc/en-us/articles/204309114#topic_regenerate)
<br>

3. [**optional**] Run `Export-AuvikModuleSettings`
   - This will create a config file at `%UserProfile%\AuvikAPI` that holds the *base uri* & *API access tokens* information.
   - Next time you run `Import-Module -Name AuvikAPI`, this configuration file will automatically be loaded.
   - :warning: Exporting module settings encrypts your API access tokens in a format that can **only be unencrypted by the user principal** that encrypted the secret. It makes use of .NET DPAPI, which for Windows uses reversible encrypted tied to your user principal. This means that you **cannot copy** your configuration file to another computer or user account and expect it to work.
   - :warning: However in Linux\Unix operating systems the secret keys are more obfuscated than encrypted so it is recommend to use a more secure & cross-platform storage method.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Usage

Calling an API resource is as simple as running `Get-Auvik<resourceName>`

- The following is a table of supported functions and their corresponding API resources:
- Table entries with [ `-` ] indicate that the functionality is **NOT** supported by the Auvik API at this time.

|Section         |API Resource                                      |Create|Read                                 |Update|Delete                      |
|----------------|--------------------------------------------------|------|-------------------------------------|------|----------------------------|
|alert           |/alert/dismiss/{id}                               |-     |                                     |Clear-AuvikAlert|-                           |
|alert           |/alert/history/info                               |-     |Get-AuvikAlert                       |-     |-                           |
|alert           |/alert/history/info/{id}                          |-     |Get-AuvikAlert                       |-     |-                           |
|billing         |/billing/usage/client                             |-     |Get-AuvikBilling                     |-     |-                           |
|billing         |/billing/usage/device/{id}                        |-     |Get-AuvikBilling                     |-     |-                           |
|clientManagement|/tenants                                          |-     |Get-AuvikTenant                      |-     |-                           |
|clientManagement|/tenants/detail                                   |-     |Get-AuvikTenant                      |-     |-                           |
|clientManagement|/tenants/detail/{id}                              |-     |Get-AuvikTenant                      |-     |-                           |
|inventory       |/inventory/component/info                         |-     |Get-AuvikComponent                   |-     |-                           |
|inventory       |/inventory/component/info/{id}                    |-     |Get-AuvikComponent                   |-     |-                           |
|inventory       |/inventory/configuration                          |-     |Get-AuvikConfiguration               |-     |-                           |
|inventory       |/inventory/configuration/{id}                     |-     |Get-AuvikConfiguration               |-     |-                           |
|inventory       |/inventory/device/detail                          |-     |Get-AuvikDevice                      |-     |-                           |
|inventory       |/inventory/device/detail/{id}                     |-     |Get-AuvikDevice                      |-     |-                           |
|inventory       |/inventory/device/detail/extended                 |-     |Get-AuvikDevice                      |-     |-                           |
|inventory       |/inventory/device/detail/extended/{id}            |-     |Get-AuvikDevice                      |-     |-                           |
|inventory       |/inventory/device/info                            |-     |Get-AuvikDevice                      |-     |-                           |
|inventory       |/inventory/device/info/{id}                       |-     |Get-AuvikDevice                      |-     |-                           |
|inventory       |/inventory/device/lifecycle                       |-     |Get-AuvikDeviceLifecycle             |-     |-                           |
|inventory       |/inventory/device/lifecycle/{id}                  |-     |Get-AuvikDeviceLifecycle             |-     |-                           |
|inventory       |/inventory/device/warranty                        |-     |Get-AuvikDeviceWarranty              |-     |-                           |
|inventory       |/inventory/device/warranty/{id}                   |-     |Get-AuvikDeviceWarranty              |-     |-                           |
|inventory       |/inventory/entity/audit                           |-     |Get-AuvikEntity                      |-     |-                           |
|inventory       |/inventory/entity/audit/{id}                      |-     |Get-AuvikEntity                      |-     |-                           |
|inventory       |/inventory/entity/note                            |-     |Get-AuvikEntity                      |-     |-                           |
|inventory       |/inventory/entity/note/{id}                       |-     |Get-AuvikEntity                      |-     |-                           |
|inventory       |/inventory/interface/info                         |-     |Get-AuvikInterface                   |-     |-                           |
|inventory       |/inventory/interface/info/{id}                    |-     |Get-AuvikInterface                   |-     |-                           |
|inventory       |/inventory/network/detail                         |-     |Get-AuvikNetwork                     |-     |-                           |
|inventory       |/inventory/network/detail/{id}                    |-     |Get-AuvikNetwork                     |-     |-                           |
|inventory       |/inventory/network/info                           |-     |Get-AuvikNetwork                     |-     |-                           |
|inventory       |/inventory/network/info/{id}                      |-     |Get-AuvikNetwork                     |-     |-                           |
|other           |/authentication/verify                            |-     |Get-AuvikCredential                  |-     |-                           |
|poolers         |/settings/snmppoller/{snmpPollerSettingId}/devices|-     |Get-AuvikSNMPPollerDevice            |-     |-                           |
|poolers         |/settings/snmppoller                              |-     |Get-AuvikSNMPPollerSetting           |-     |-                           |
|poolers         |/settings/snmppoller/{snmpPollerSettingId}        |-     |Get-AuvikSNMPPollerSetting           |-     |-                           |
|poolers         |/stat/snmppoller/int                              |-     |Get-AuvikSNMPPolllerHistory          |-     |-                           |
|poolers         |/stat/snmppoller/string                           |-     |Get-AuvikSNMPPolllerHistory          |-     |-                           |
|statistics      |/stat/component/{componentType}/{statId}          |-     |Get-AuvikComponentStatistics         |-     |-                           |
|statistics      |/stat/deviceAvailability/{statId}                 |-     |Get-AuvikDeviceAvailabilityStatistics|-     |-                           |
|statistics      |/stat/device/{statId}                             |-     |Get-AuvikDeviceStatistics            |-     |-                           |
|statistics      |/stat/interface/{statId}                          |-     |Get-AuvikInterfaceStatistics         |-     |-                           |
|statistics      |/stat/oid/{statId}                                |-     |Get-AuvikOIDStatistics               |-     |-                           |
|statistics      |/stat/service/{statId}                            |-     |Get-AuvikServiceStatistics           |-     |-                           |

Each `Get-Auvik*` function will respond with the raw data that Auvik's API provides.

- :warning: Returned data is mostly structured the same but can vary between commands.
- data - The actual information requested (this is what most people care about)
- links - Information about the number of pages of results are available and other metadata.
- meta - Information about the number of pages of results are available and other metadata.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Roadmap

- [ ] Add Changelog
- [x] Build more robust Pester & ScriptAnalyzer tests
- [x] Figure out how to do CI & PowerShell gallery automation
- [ ] Add example scripts & automation

See the [open issues](https://github.com/Celerium/Auvik-PowerShellWrapper/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

See the [CONTRIBUTING](https://github.com/Celerium/Auvik-PowerShellWrapper/blob/main/.github/CONTRIBUTING.md) guide for more information about contributing.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## License

Distributed under the MIT License. See [`LICENSE`](https://github.com/Celerium/Auvik-PowerShellWrapper/blob/main/LICENSE) for more information.

[![GitHub_License][GitHub_License-shield]][GitHub_License-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

<div align="left">

  <p align="left">
    ·
    <a href="https://celerium.org/#/contact" target="_blank">Website</a>
    ·
    <a href="mailto: celerium@celerium.org">Email</a>
    ·
    <a href="https://www.reddit.com/user/CeleriumIO" target="_blank">Reddit</a>
    ·
  </p>
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Acknowledgments

Big thank you to the following people and services as they have provided me with lots of helpful information as I continue this project!

- [GitHub Pages](https://pages.github.com)
- [Img Shields](https://shields.io)
- [Font Awesome](https://fontawesome.com)
- [Choose an Open Source License](https://choosealicense.com)
- [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[Az_Pipeline-shield]:               https://img.shields.io/azure-devops/build/AzCelerium/AuvikAPI/5?style=for-the-badge&label=DevOps_Build
[Az_Pipeline-url]:                  https://dev.azure.com/AzCelerium/AuvikAPI/_build?definitionId=5

[GitHub_Pages-shield]:              https://img.shields.io/github/actions/workflow/status/celerium/Auvik-PowerShellWrapper/pages%2Fpages-build-deployment?style=for-the-badge&label=GitHub%20Pages
[GitHub_Pages-url]:                 https://github.com/Celerium/Auvik-PowerShellWrapper/actions/workflows/pages/pages-build-deployment

[GitHub_License-shield]:            https://img.shields.io/github/license/celerium/Auvik-PowerShellWrapper?style=for-the-badge
[GitHub_License-url]:               https://github.com/Celerium/Auvik-PowerShellWrapper/blob/main/LICENSE

[PoshGallery_Version-shield]:       https://img.shields.io/powershellgallery/v/Auvikapi?include_prereleases&style=for-the-badge
[PoshGallery_Version-url]:          https://www.powershellgallery.com/packages/AuvikAPI

[PoshGallery_Platforms-shield]:     https://img.shields.io/powershellgallery/p/Auvikapi?style=for-the-badge
[PoshGallery_Platforms-url]:        https://www.powershellgallery.com/packages/AuvikAPI

[PoshGallery_Downloads-shield]:     https://img.shields.io/powershellgallery/dt/AuvikAPI?style=for-the-badge
[PoshGallery_Downloads-url]:        https://www.powershellgallery.com/packages/AuvikAPI

[website-shield]:                   https://img.shields.io/website?up_color=blue&url=https%3A%2F%2Fcelerium.org&style=for-the-badge&label=Blog
[website-url]:                      https://celerium.org

[codeSize-shield]:                  https://img.shields.io/github/repo-size/celerium/Auvik-PowerShellWrapper?style=for-the-badge
[codeSize-url]:                     https://github.com/Celerium/Auvik-PowerShellWrapper

[contributors-shield]:              https://img.shields.io/github/contributors/celerium/Auvik-PowerShellWrapper?style=for-the-badge
[contributors-url]:                 https://github.com/Celerium/Auvik-PowerShellWrapper/graphs/contributors

[forks-shield]:                     https://img.shields.io/github/forks/celerium/Auvik-PowerShellWrapper?style=for-the-badge
[forks-url]:                        https://github.com/Celerium/Auvik-PowerShellWrapper/network/members

[stars-shield]:                     https://img.shields.io/github/stars/celerium/Auvik-PowerShellWrapper?style=for-the-badge
[stars-url]:                        https://github.com/Celerium/Auvik-PowerShellWrapper/stargazers

[issues-shield]:                    https://img.shields.io/github/issues/Celerium/Auvik-PowerShellWrapper?style=for-the-badge
[issues-url]:                       https://github.com/Celerium/Auvik-PowerShellWrapper/issues
