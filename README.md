[![PSScriptAnalyzer](https://github.com/VNerdIO/Rebrandly/actions/workflows/powershell.yml/badge.svg)](https://github.com/VNerdIO/Rebrandly/actions/workflows/powershell.yml)

# Rebrandly
Powershell module to interact with Rebrandly API

# HOWTO

Assumption: git is installed

- open Powershell prompt, cd to Documents\Powershell\Modules
- execute `git clone https://github.com/VNerdIO/Rebrandly`
- Type `Import-Module Rebrandly`
- Get/store an api key securely. Store it in memory as `$global:RBKey` so the module will have access.
- If you are using a workspace, store that id in memory at `$global:WBWSId`
- See the documentation (`Get-Help New-RBLink -Full`)
