param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$lpDir = Join-Path $Root "writeups\tryhackme\Learning_Paths"
$readmePath = Join-Path $lpDir "README.md"

function Get-TitleFromFileName([string]$name) {
  $base = [System.IO.Path]::GetFileNameWithoutExtension($name)

  $map = @{
    "M2-01-What_is_Networking" = "Module 2 - What is Networking?"
    "M2-02-Intro_to_LAN" = "Module 2 - Intro to LAN"
    "M2-03-OSI_Model" = "Module 2 - OSI Model"
    "M3-01-DNS_in_Detail" = "Module 3 - DNS in Detail"
    "M3-02-HTTP_in_Detail" = "Module 3 - HTTP in Detail"
    "M4-03-Client_Server_Basics" = "Module 4 - Client-Server Basics"
    "M5-01-Operating_Systems_Introduction" = "Module 5 - Operating Systems: Introduction"
    "M5-03-Linux_CLI_Basics" = "Module 5 - Linux CLI Basics"
    "M5-04-Windows_CLI_Basics" = "Module 5 - Windows CLI Basics"
    "M6-04-JavaScript_Simple_Demo" = "Module 6 - JavaScript Simple Demo"
    "M6-05-Database_SQL_Basics" = "Module 6 - Database SQL Basics"
    "M7-01-The_CIA_Triad" = "Module 7 - The CIA Triad"
  }

  if ($map.ContainsKey($base)) { return $map[$base] }

  $parts = $base -split '-'
  if ($parts.Length -lt 3) { return $base }

  $moduleNum = [int]($parts[0].Substring(1))
  $namePart = ($parts[2..($parts.Length-1)] -join '-')
  $title = ($namePart -replace '_',' ')
  $title = ($title -split ' ' | ForEach-Object {
      if ($_ -match '^(in|to|a|the|and|of)$') { $_.ToLower() } else { (Get-Culture).TextInfo.ToTitleCase($_.ToLower()) }
    }) -join ' '

  return "Module $moduleNum - $title"
}

$preFiles = Get-ChildItem -Path (Join-Path $lpDir "Pre_Security") -File -Filter "M*.md" | Sort-Object Name
$cyberFiles = Get-ChildItem -Path (Join-Path $lpDir "Cyber_Security_101") -File -Filter "M*.md" | Sort-Object Name

$lines = @()
$lines += '![Last update](https://img.shields.io/badge/Last%20update-2026--05--19-495057?style=for-the-badge)'
$lines += ''
$lines += '# Learning Paths'
$lines += ''

foreach ($file in $preFiles) {
  $title = Get-TitleFromFileName $file.Name
  $rel = "Pre_Security/$($file.Name)"
  $lines += "- [$title]($rel)"
}

$lines += ''
$lines += '## Cyber Security 101'
$lines += ''

foreach ($file in $cyberFiles) {
  $title = Get-TitleFromFileName $file.Name
  $rel = "Cyber_Security_101/$($file.Name)"
  $lines += "- [$title]($rel)"
}

$newContent = ($lines -join "`r`n")

if ($DryRun) {
  Write-Output "[DRY RUN] Would regenerate: $readmePath"
  exit 0
}

Set-Content -Path $readmePath -Value $newContent -Encoding UTF8
Write-Output "Regenerated: $readmePath"
