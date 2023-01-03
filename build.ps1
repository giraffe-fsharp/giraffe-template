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

Import-module "$PSScriptRoot/.psscripts/build-functions.ps1" -Force

Write-BuildHeader "Starting giraffe-template build script"

$nuspec = "./src/giraffe-template.nuspec"
$version = Get-NuspecVersion $nuspec

Update-AppVeyorBuildVersion $version

if (Test-IsAppVeyorBuildTriggeredByGitTag)
{
    $gitTag = Get-AppVeyorGitTag
    Test-CompareVersions $version $gitTag
}

Write-DotnetVersions
Remove-OldBuildArtifacts

# Test Giraffe template
Write-Host "Building and testing Giraffe tempalte..." -ForegroundColor Magenta
$giraffeApp     = "src/content/Giraffe/src/AppName.1/AppName.1.fsproj"
$giraffeTests   = "src/content/Giraffe/tests/AppName.1.Tests/AppName.1.Tests.fsproj"

dotnet-restore $giraffeApp
dotnet-build   $giraffeApp
dotnet-restore $giraffeTests
dotnet-build   $giraffeTests
dotnet-test    $giraffeTests

# Test Razor template
# Write-Host "Building and testing Razor tempalte..." -ForegroundColor Magenta
# $razorApp       = "src/content/Razor/src/AppName.1/AppName.1.fsproj"
# $razorTests     = "src/content/Razor/tests/AppName.1.Tests/AppName.1.Tests.fsproj"

# dotnet-restore $razorApp
# dotnet-build   $razorApp
# dotnet-restore $razorTests
# dotnet-build   $razorTests
# dotnet-test    $razorTests

# Test DotLiquid template
Write-Host "Building and testing DotLiquid tempalte..." -ForegroundColor Magenta
$dotLiquidApp   = "src/content/DotLiquid/src/AppName.1/AppName.1.fsproj"
$dotLiquidTests = "src/content/DotLiquid/tests/AppName.1.Tests/AppName.1.Tests.fsproj"

dotnet-restore $dotLiquidApp
dotnet-build   $dotLiquidApp
dotnet-restore $dotLiquidTests
dotnet-build   $dotLiquidTests
dotnet-test    $dotLiquidTests

# Test None template
Write-Host "Building and testing None tempalte..." -ForegroundColor Magenta
$noneApp   = "src/content/None/src/AppName.1/AppName.1.fsproj"
$noneTests = "src/content/None/tests/AppName.1.Tests/AppName.1.Tests.fsproj"

dotnet-restore $noneApp
dotnet-build   $noneApp
dotnet-restore $noneTests
dotnet-build   $noneTests
dotnet-test    $noneTests

# Create template NuGet package
Remove-OldBuildArtifacts
Write-Host "Building NuGet package..." -ForegroundColor Magenta
Invoke-Cmd "nuget pack src/giraffe-template.nuspec"

if ($UpdatePaketDependencies.IsPresent -or $TestPermutations.IsPresent -or $CreatePermutations.IsPresent -or $InstallTemplate.IsPresent)
{
    # Uninstalling Giraffe tempalte
    Write-Host "Uninstalling existing Giraffe template..." -ForegroundColor Magenta
    $giraffeInstallation = Invoke-UnsafeCmd "dotnet new giraffe --list"
    $giraffeInstallation
    if ($giraffeInstallation[$giraffeInstallation.Length - 2].StartsWith("Giraffe Web App"))
    {
        Invoke-Cmd "dotnet new -u giraffe-template"
    }
    # if ($giraffeInstallation.Length -lt 6) { Invoke-Cmd "dotnet new -u giraffe-template" }

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

        $viewEngines = "Giraffe", "DotLiquid", "None"
        foreach ($viewEngine in $viewEngines)
        {
            Write-Host "Creating templates for view engine: $viewEngine..." -ForegroundColor Magenta

            $engine = $viewEngine.ToLower()

            Invoke-Cmd ("dotnet new giraffe -lang F# -V $engine -o $tempFolder/$viewEngine" + "RawApp")
            Invoke-Cmd ("dotnet new giraffe -lang F# -P -V $engine -o $tempFolder/$viewEngine" + "RawPaketApp")
            Invoke-Cmd ("dotnet new giraffe -lang F# -S -V $engine -o $tempFolder/$viewEngine" + "TestsApp")
            Invoke-Cmd ("dotnet new giraffe -lang F# -S -E -V $engine -o $tempFolder/$viewEngine" + "App")
            Invoke-Cmd ("dotnet new giraffe -lang F# -S -P -V $engine -o $tempFolder/$viewEngine" + "TestsPaketApp")
            Invoke-Cmd ("dotnet new giraffe -lang F# -S -E -P -V $engine -o $tempFolder/$viewEngine" + "PaketApp")
        }

        if ($UpdatePaketDependencies.IsPresent -or $TestPermutations.IsPresent)
        {
            # Building and testing all permutations
            Write-Host "Building and testing all permutations of the giraffe-tempalte..." -ForegroundColor Magenta
            $isWin = Test-IsWindows

            Get-ChildItem ".temp" -Directory | ForEach-Object {
                $name    = $_.Name
                $isRaw   = $name.Contains("Raw")
                $isPaket = $name.Contains("Paket")

                Write-Host "Running build script for $name..." -ForegroundColor Magenta
                Push-Location $_.FullName

                if ($UpdatePaketDependencies.IsPresent -and $isPaket)
                {
                    Remove-Item -Path "paket.lock" -Force
                }

                if ($isRaw) {
                    if ($isPaket) {
                        if ($UpdatePaketDependencies.IsPresent) {
                            Invoke-Cmd "dotnet paket install"
                        } else {
                            Invoke-Cmd "dotnet paket restore"
                        }
                    }
                    Invoke-Cmd "dotnet build"
                }
                elseif ($isWin) {
                    Invoke-Cmd ("./build.bat")
                }
                else {
                    Invoke-Cmd ("sh ./build.sh")
                }

                if ($UpdatePaketDependencies.IsPresent -and $isPaket)
                {
                    $viewEngine = $name.Replace("App", "").Replace("Paket", "").Replace("Tests", "")
                    Copy-Item -Path "paket.lock" -Destination "../../src/content/$viewEngine/paket.lock" -Force
                }

                Pop-Location
            }
        }
    }
}

Write-SuccessFooter "The giraffe-template has been successfully built!"