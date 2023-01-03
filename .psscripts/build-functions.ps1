# ----------------------------------------------
# Generic functions
# ----------------------------------------------

function Test-IsWindows
{
    <#
        .DESCRIPTION
        Checks to see whether the current environment is Windows or not.

        .EXAMPLE
        if (Test-IsWindows) { Write-Host "Hello Windows" }
    #>

    [environment]::OSVersion.Platform -ne "Unix"
}

function Get-UbuntuVersion
{
    <#
        .DESCRIPTION
        Gets the Ubuntu version.

        .EXAMPLE
        $ubuntuVersion = Get-UbuntuVersion
    #>

    $version = Invoke-Cmd "lsb_release -r -s" -Silent
    return $version
}

function Invoke-UnsafeCmd (
    [string] $Cmd,
    [switch] $Silent)
{
    <#
        .DESCRIPTION
        Runs a shell or bash command, but doesn't throw an error if the command didn't exit with 0.

        .PARAMETER cmd
        The command to be executed.

        .EXAMPLE
        Invoke-Cmd -Cmd "dotnet new classlib"

        .NOTES
        Use this PowerShell command to execute any CLI commands which might not exit with 0 on a success.
    #>

    if (!($Silent.IsPresent)) { Write-Host $cmd -ForegroundColor DarkCyan }
    if (Test-IsWindows) { $cmd = "cmd.exe /C $cmd" }
    Invoke-Expression -Command $cmd
}

function Invoke-Cmd (
    [string] $Cmd,
    [switch] $Silent)
{
    <#
        .DESCRIPTION
        Runs a shell or bash command and throws an error if the command didn't exit with 0.

        .PARAMETER cmd
        The command to be executed.

        .EXAMPLE
        Invoke-Cmd -Cmd "dotnet new classlib"

        .NOTES
        Use this PowerShell command to execute any dotnet CLI commands in order to ensure that they behave the same way in the case of an error across different environments (Windows, OSX and Linux).
    #>

    if ($Silent.IsPresent) { Invoke-UnsafeCmd $cmd -Silent } else { Invoke-UnsafeCmd $cmd }
    if ($LastExitCode -ne 0) { Write-Error "An error occured when executing '$Cmd'."; return }
}

function Remove-OldBuildArtifacts
{
    <#
        .DESCRIPTION
        Deletes all the bin and obj folders from the current- and all sub directories.
    #>

    Write-Host "Deleting old build artifacts..." -ForegroundColor Magenta

    Get-ChildItem -Include "bin", "obj" -Recurse -Directory `
    | ForEach-Object {
        Write-Host "Removing folder $_" -ForegroundColor DarkGray
        Remove-Item $_ -Recurse -Force }
}

function Get-Version ($csprojFile) {
    <#
        .DESCRIPTION
        Gets the <version> value of a .csproj file.

        .PARAMETER cmd
        The relative or absolute path to the .csproj file.
    #>

    [xml] $xml = Get-Content $csprojFile
    [string] $version = $xml.Project.PropertyGroup.PackageVersion
    $version
}

function Test-CompareVersions ($version, [string]$gitTag)
{
    Write-Host "Matching version against git tag..." -ForegroundColor Magenta
    Write-Host "Project version: $version" -ForegroundColor Cyan
    Write-Host "Git tag version: $gitTag" -ForegroundColor Cyan

    if (!$gitTag.EndsWith($version))
    {
        Write-Error "Version and Git tag do not match."
    }
}

# ----------------------------------------------
# .NET functions
# ----------------------------------------------

function dotnet-info                      { Invoke-Cmd "dotnet --info" -Silent }
function dotnet-version                   { Invoke-Cmd "dotnet --version" -Silent }
function dotnet-restore ($project, $argv) { Invoke-Cmd "dotnet restore $project $argv" }
function dotnet-build   ($project, $argv) { Invoke-Cmd "dotnet build $project $argv" }
function dotnet-test    ($project, $argv) { Invoke-Cmd "dotnet test $project $argv"  }
function dotnet-run     ($project, $argv) { Invoke-Cmd "dotnet run --project $project $argv" }
function dotnet-pack    ($project, $argv) { Invoke-Cmd "dotnet pack $project $argv" }
function dotnet-publish ($project, $argv) { Invoke-Cmd "dotnet publish $project $argv" }

function Get-DotNetRuntimeVersion
{
    <#
        .DESCRIPTION
        Runs the dotnet --info command and extracts the .NET Runtime version number.
        .NOTES
        The .NET Runtime version can sometimes be useful for other dotnet CLI commands (e.g. dotnet xunit -fxversion ".NET Runtime version").
    #>

    $info = dotnet-info
    [System.Array]::Reverse($info)
    $version = $info | Where-Object { $_.Contains("Version")  } | Select-Object -First 1
    $version.Split(":")[1].Trim()
}

function Write-DotnetVersions
{
    <#
        .DESCRIPTION
        Writes the .NET SDK and Runtime version to the current host.
    #>

    $sdkVersion     = dotnet-version
    $runtimeVersion = Get-DotNetRuntimeVersion
    Write-Host ".NET SDK version:      $sdkVersion" -ForegroundColor Cyan
    Write-Host ".NET Runtime version:  $runtimeVersion" -ForegroundColor Cyan
}

function Get-DesiredSdk
{
    <#
        .DESCRIPTION
        Gets the desired .NET SDK version from the global.json file.
    #>

    Get-Content "global.json" `
    | ConvertFrom-Json `
    | ForEach-Object { $_.sdk.version.ToString() }
}


# ----------------------------------------------
# AppVeyor functions
# ----------------------------------------------

function Test-IsAppVeyorBuild                  { return ($env:APPVEYOR -eq $true) }
function Test-IsAppVeyorBuildTriggeredByGitTag { return ($env:APPVEYOR_REPO_TAG -eq $true) }
function Get-AppVeyorGitTag                    { return $env:APPVEYOR_REPO_TAG_NAME }

function Update-AppVeyorBuildVersion ($version)
{
    if (Test-IsAppVeyorBuild)
    {
        Write-Host "Updating AppVeyor build version..." -ForegroundColor Magenta
        $buildVersion = "$version-$env:APPVEYOR_BUILD_NUMBER"
        Write-Host "Setting AppVeyor build version to $buildVersion."
        Update-AppveyorBuild -Version $buildVersion
    }
}

# ----------------------------------------------
# Host Writing functions
# ----------------------------------------------

function Write-BuildHeader ($projectTitle)
{
    $header = "  $projectTitle  ";
    $bar = ""
    for ($i = 0; $i -lt $header.Length; $i++) { $bar += "-" }

    Write-Host ""
    Write-Host $bar -ForegroundColor DarkYellow
    Write-Host $header -ForegroundColor DarkYellow
    Write-Host $bar -ForegroundColor DarkYellow
    Write-Host ""
}

function Write-SuccessFooter ($msg)
{
    $footer = "  $msg  ";
    $bar = ""
    for ($i = 0; $i -lt $footer.Length; $i++) { $bar += "-" }

    Write-Host ""
    Write-Host $bar -ForegroundColor Green
    Write-Host $footer -ForegroundColor Green
    Write-Host $bar -ForegroundColor Green
    Write-Host ""
}
