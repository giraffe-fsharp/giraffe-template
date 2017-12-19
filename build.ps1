# ----------------------------------------------
# Build script
# ----------------------------------------------

$ErrorActionPreference = "Stop"

# ----------------------------------------------
# Helper functions
# ----------------------------------------------

function Test-IsWindows
{
    [environment]::OSVersion.Platform -ne "Unix"
}

function Invoke-Cmd ($cmd)
{
    Write-Host $cmd -ForegroundColor DarkCyan
    if (Test-IsWindows) { $cmd = "cmd.exe /C $cmd" }
    Invoke-Expression -Command $cmd
    if ($LastExitCode -ne 0) { Write-Error "An error occured when executing '$cmd'."; return }
}

function Test-Version ($project)
{
    if ($env:APPVEYOR_REPO_TAG -eq $true)
    {
        Write-Host "Matching version against git tag..." -ForegroundColor Magenta

        [xml] $xml = Get-Content $project
        [string] $version = $xml.package.metadata.version
        [string] $gitTag  = $env:APPVEYOR_REPO_TAG_NAME

        Write-Host "Project version: $version" -ForegroundColor Cyan
        Write-Host "Git tag version: $gitTag" -ForegroundColor Cyan

        if (!$gitTag.EndsWith($version))
        {
            Write-Error "Version and Git tag do not match."
        }
    }
}

function Update-AppVeyorBuildVersion ($project)
{
    if ($env:APPVEYOR -eq $true)
    {
        Write-Host "Updating AppVeyor build version..." -ForegroundColor Magenta

        [xml]$xml = Get-Content $project
        $version = $xml.package.metadata.version
        $buildVersion = "$version-$env:APPVEYOR_BUILD_NUMBER"
        Write-Host "Setting AppVeyor build version to $buildVersion."
        Update-AppveyorBuild -Version $buildVersion
    }
}

# ----------------------------------------------
# Main
# ----------------------------------------------

$nuspec = ".\src\giraffe-template.nuspec"

Update-AppVeyorBuildVersion $nuspec
Test-Version $nuspec

Write-Host "Building giraffe-template package..." -ForegroundColor Magenta

Invoke-Cmd "nuget pack src/giraffe-template.nuspec"