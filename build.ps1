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

function dotnet-restore ($project, $argv) { Invoke-Cmd "dotnet restore $project $argv" }
function dotnet-build   ($project, $argv) { Invoke-Cmd "dotnet build $project $argv" }
function dotnet-run     ($project, $argv) { Invoke-Cmd "dotnet run --project $project $argv" }
function dotnet-test    ($project, $argv) { Invoke-Cmd "dotnet test $project $argv" }
function dotnet-pack    ($project, $argv) { Invoke-Cmd "dotnet pack $project $argv" }

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

function Remove-BuildArtifacts
{
    Write-Host "Deleting build artifacts..." -ForegroundColor Magenta

    Get-ChildItem -Include "bin", "obj" -Recurse -Directory `
    | ForEach-Object {
        Write-Host "Removing folder $_" -ForegroundColor DarkGray
        Remove-Item $_ -Recurse -Force }

    Remove-Item -Path "giraffe-template.*.nupkg" -Force
}

# ----------------------------------------------
# Main
# ----------------------------------------------

$nuspec = ".\src\giraffe-template.nuspec"

Update-AppVeyorBuildVersion $nuspec
Test-Version $nuspec

Write-Host "Building giraffe-template package..." -ForegroundColor Magenta

Remove-BuildArtifacts

# Test Giraffe template
$giraffeApp     = "src/content/Giraffe/src/AppNamePlaceholder/AppNamePlaceholder.fsproj"
$giraffeTests   = "src/content/Giraffe/tests/AppNamePlaceholder.Tests/AppNamePlaceholder.Tests.fsproj"

dotnet-restore $giraffeApp
dotnet-build   $giraffeApp
dotnet-restore $giraffeTests
dotnet-build   $giraffeTests
dotnet-test    $giraffeTests

# Test Razor template
$razorApp       = "src/content/Razor/src/AppNamePlaceholder/AppNamePlaceholder.fsproj"
$razorTests     = "src/content/Razor/tests/AppNamePlaceholder.Tests/AppNamePlaceholder.Tests.fsproj"

dotnet-restore $razorApp
dotnet-build   $razorApp
dotnet-restore $razorTests
dotnet-build   $razorTests
dotnet-test    $razorTests

# Test DotLiquid template
$dotLiquidApp   = "src/content/DotLiquid/src/AppNamePlaceholder/AppNamePlaceholder.fsproj"
$dotLiquidTests = "src/content/DotLiquid/tests/AppNamePlaceholder.Tests/AppNamePlaceholder.Tests.fsproj"

dotnet-restore $dotLiquidApp
dotnet-build   $dotLiquidApp
dotnet-restore $dotLiquidTests
dotnet-build   $dotLiquidTests
dotnet-test    $dotLiquidTests

# Test None template
$noneApp   = "src/content/None/src/AppNamePlaceholder/AppNamePlaceholder.fsproj"
$noneTests = "src/content/None/tests/AppNamePlaceholder.Tests/AppNamePlaceholder.Tests.fsproj"

dotnet-restore $noneApp
dotnet-build   $noneApp
dotnet-restore $noneTests
dotnet-build   $noneTests
dotnet-test    $noneTests

# Create template NuGet package
Remove-BuildArtifacts
Invoke-Cmd "nuget pack src/giraffe-template.nuspec"