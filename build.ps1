# ----------------------------------------------
# Build script
# ----------------------------------------------

param
(
    [switch] $InstallTemplate,
    [switch] $CreatePermutations,
    [switch] $TestPermutations,
    [switch] $UpdatePaketDependencies
)

# ----------------------------------------------
# Main
# ----------------------------------------------

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "-----------------------------------------" -ForegroundColor DarkYellow
Write-Host " Starting giraffe-template build script  " -ForegroundColor DarkYellow
Write-Host "-----------------------------------------" -ForegroundColor DarkYellow
Write-Host ""

Import-module "$PSScriptRoot/.psscripts/build-functions.ps1" -Force

$nuspec = "./src/giraffe-template.nuspec"

Update-AppVeyorBuildVersion $nuspec

if (Test-IsAppVeyorBuildTriggeredByGitTag)
{
    $gitTag = Get-AppVeyorGitTag
    $nuspecVersion = Get-NuspecVersion $nuspec
    Test-CompareVersions $nuspecVersion $gitTag
}

Write-DotnetCoreVersions
Remove-BuildArtifacts

# Test Giraffe template
Write-Host "Building and testing Giraffe tempalte..." -ForegroundColor Magenta
$giraffeApp     = "src/content/Giraffe/src/AppNamePlaceholder/AppNamePlaceholder.fsproj"
$giraffeTests   = "src/content/Giraffe/tests/AppNamePlaceholder.Tests/AppNamePlaceholder.Tests.fsproj"

dotnet-restore $giraffeApp
dotnet-build   $giraffeApp
dotnet-restore $giraffeTests
dotnet-build   $giraffeTests
dotnet-test    $giraffeTests

# Test Razor template
Write-Host "Building and testing Razor tempalte..." -ForegroundColor Magenta
$razorApp       = "src/content/Razor/src/AppNamePlaceholder/AppNamePlaceholder.fsproj"
$razorTests     = "src/content/Razor/tests/AppNamePlaceholder.Tests/AppNamePlaceholder.Tests.fsproj"

dotnet-restore $razorApp
dotnet-build   $razorApp
dotnet-restore $razorTests
dotnet-build   $razorTests
dotnet-test    $razorTests

# Test DotLiquid template
Write-Host "Building and testing DotLiquid tempalte..." -ForegroundColor Magenta
$dotLiquidApp   = "src/content/DotLiquid/src/AppNamePlaceholder/AppNamePlaceholder.fsproj"
$dotLiquidTests = "src/content/DotLiquid/tests/AppNamePlaceholder.Tests/AppNamePlaceholder.Tests.fsproj"

dotnet-restore $dotLiquidApp
dotnet-build   $dotLiquidApp
dotnet-restore $dotLiquidTests
dotnet-build   $dotLiquidTests
dotnet-test    $dotLiquidTests

# Test None template
Write-Host "Building and testing None tempalte..." -ForegroundColor Magenta
$noneApp   = "src/content/None/src/AppNamePlaceholder/AppNamePlaceholder.fsproj"
$noneTests = "src/content/None/tests/AppNamePlaceholder.Tests/AppNamePlaceholder.Tests.fsproj"

dotnet-restore $noneApp
dotnet-build   $noneApp
dotnet-restore $noneTests
dotnet-build   $noneTests
dotnet-test    $noneTests

# Create template NuGet package
Remove-BuildArtifacts
Write-Host "Building NuGet package..." -ForegroundColor Magenta
Invoke-Cmd "nuget pack src/giraffe-template.nuspec"

if ($UpdatePaketDependencies.IsPresent -or $TestPermutations.IsPresent -or $CreatePermutations.IsPresent -or $InstallTemplate.IsPresent)
{
    # Uninstalling Giraffe tempalte
    Write-Host "Uninstalling existing Giraffe template..." -ForegroundColor Magenta
    $giraffeInstallation = Invoke-UnsafeCmd "dotnet new giraffe --list"
    $giraffeInstallation
    if ($giraffeInstallation.Length -lt 6) { Invoke-Cmd "dotnet new -u giraffe-template" }

    $version   = Get-NuspecVersion $nuspec
    $nupkg     = Get-ChildItem "./giraffe-template.$version.nupkg"
    $nupkgPath = $nupkg.FullName

    # Installing Giraffe template
    Write-Host "Installing newly built Giraffe tempalte..." -ForegroundColor Magenta
    Invoke-Cmd "dotnet new -i $nupkgPath"

    if ($UpdatePaketDependencies.IsPresent -or $TestPermutations.IsPresent -or $CreatePermutations.IsPresent)
    {
        # Creating new .temp folder for permutation tests
        Write-Host "Creating new .temp folder for template tests..." -ForegroundColor Magenta
        $tempFolder = ".temp"
        if (Test-Path $tempFolder) { Remove-Item $tempFolder -Recurse -Force }
        New-Item -Name ".temp" -ItemType Directory

        # Creating all permutations
        Write-Host "Creating all permutations of the giraffe-tempalte..." -ForegroundColor Magenta

        $viewEngines = "Giraffe", "Razor", "DotLiquid", "None"
        foreach ($viewEngine in $viewEngines)
        {
            Write-Host "Creating templates for view engine: $viewEngine..." -ForegroundColor Magenta

            $engine = $viewEngine.ToLower()

            Invoke-Cmd ("dotnet new giraffe -lang F# -V $engine -o $tempFolder/$viewEngine" + "App")
            Invoke-Cmd ("dotnet new giraffe -lang F# -I -V $engine -o $tempFolder/$viewEngine" + "TestsApp")
            Invoke-Cmd ("dotnet new giraffe -lang F# -U -V $engine -o $tempFolder/$viewEngine" + "PaketApp")
            Invoke-Cmd ("dotnet new giraffe -lang F# -I -U -V $engine -o $tempFolder/$viewEngine" + "TestsPaketApp")
        }

        if ($UpdatePaketDependencies.IsPresent -or $TestPermutations.IsPresent)
        {
            # Building and testing all permutations
            Write-Host "Building and testing all permutations of the giraffe-tempalte..." -ForegroundColor Magenta
            $isWin = Test-IsWindows

            Get-ChildItem ".temp" -Directory | ForEach-Object {
                $name = $_.Name
                Write-Host "Running build script for $name..." -ForegroundColor Magenta
                Push-Location $_.FullName

                if ($UpdatePaketDependencies.IsPresent -and $name.Contains("Paket"))
                {
                    Remove-Item -Path "paket.lock" -Force
                }

                if ($isWin) {
                    Invoke-Cmd ("./build.bat")
                }
                else {
                    Invoke-Cmd ("sh ./build.sh")
                }

                if ($UpdatePaketDependencies.IsPresent -and $name.Contains("Paket"))
                {
                    $viewEngine = $name.Replace("App", "").Replace("Paket", "").Replace("Tests", "")
                    Copy-Item -Path "paket.lock" -Destination "../../src/content/$viewEngine/paket.lock" -Force
                }

                Pop-Location
            }
        }
    }
}

Write-Host ""
Write-Host " .~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~. " -ForegroundColor Green
Write-Host "   giraffe-template build completed successfully!  " -ForegroundColor Green
Write-Host " '~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~' " -ForegroundColor Green
Write-Host ""