![Giraffe](https://raw.githubusercontent.com/giraffe-fsharp/Giraffe/master/giraffe.png)

# Giraffe Template

Giraffe web application template for the `dotnet new` command.

[![NuGet Info](https://buildstats.info/nuget/giraffe-template)](https://www.nuget.org/packages/giraffe-template/)

[![Build History](https://buildstats.info/appveyor/chart/dustinmoris/giraffe-template?branch=develop)](https://ci.appveyor.com/project/dustinmoris/giraffe-template/history?branch=develop)

## Table of contents

- [Installation](#installation)
- [Updating the template](#updating-the-template)
- [Basics](#basics)
- [Template Options](#template-options)
    - [ViewEngine](#viewengine)
    - [Solution](#solution)
    - [ExcludeTests](#excludetests)
    - [Paket](#paket)
- [Known Issues](#known-issues)
    - [Cyclic reference](#cyclic-reference)
    - [.NET Core 2.0 issues](#net-core-20-issues)
    - [Using Visual Studio](#using-visual-studio)
- [Nightly builds and NuGet feed](#nightly-builds-and-nuget-feed)
- [Contributing](#contributing)
- [More information](#more-information)
- [License](#license)

## Installation

The easiest way to install the Giraffe template is by running the following command in your terminal:

```
dotnet new install "giraffe-template::*"
```

This will pull and install the latest [giraffe-template NuGet package](https://www.nuget.org/packages/giraffe-template/) into your .NET environment and make it available to subsequent `dotnet new` commands.

## Updating the template

Whenever there is a new version of the Giraffe template you can update it by re-running the [instructions from the installation](#installation).

You can also explicitly set the version when installing the template:

```
dotnet new install "giraffe-template::1.4.0"
```

## Basics

After the template has been installed you can create a new Giraffe web application by simply running `dotnet new giraffe` in your terminal:

```
dotnet new giraffe
```

If you wish to use [Paket](https://fsprojects.github.io/Paket/) for your dependency management use the `--Paket` or `-P` parameter when creating a new application:

```
dotnet new giraffe --Paket
```

The template uses HTTPS redirection when run in production which is the default unless explicitly overridden. If you don't have a certificate configured for HTTPS, be sure to set `ASPNETCORE_ENVIRONMENT=Development`. In order to test production mode during development you can generate a self signed certificate using this guide: https://docs.microsoft.com/en-us/dotnet/core/additional-tools/self-signed-certificates-guide

The Giraffe template only supports the F# language at the moment (given that Giraffe is an F# web framework this is on purpose).

Further information and more help can be found by running `dotnet new giraffe --help` in your terminal.

## Template Options

### ViewEngine

The Giraffe template supports four project templates, three different view engines and one API only template:

- `giraffe` (default)
- `razor`
- `dotliquid`
- `none`

Use the `--ViewEngine` parameter (short `-V`) to set one of the supported values from above:

```
dotnet new giraffe --ViewEngine razor
```

The same command can be abbreviated using the `-V` parameter:

```
dotnet new giraffe -V razor
```

If you do not specify the `--ViewEngine` parameter then the `dotnet new giraffe` command will automatically create a Giraffe web application with the `Giraffe.ViewEngine` templating engine.

### Solution

When running `dotnet new giraffe` the created project will only be a single Giraffe project which can be added to an existing .NET Core solution. However, when generating a new Giraffe project from a blank sheet then the `--Solution` (or short `-S`) parameter can simplify the generation of an entire solution, including a `.sln` file and accompanied test projects:

```
dotnet new giraffe --Solution
```

This will create the following structure:

```
src/
  - AppName/
      - Views/
          - ...
      - WebRoot/
          - ...
      - Models.fs
      - Program.fs
      ...
tests/
  - AppName.Tests/
      - Tests.fs
      ...
build.bat
build.sh
AppName.sln
README.md
```

### ExcludeTests

When creating a new Giraffe application with the `--Solution` (`-S`) flag enabled, then by default the outputted project structure will include a unit test project as well. If this is not desired then add the `--ExcludeTests` or short handed `-E` parameter to prevent tests from being created:

```
dotnet new giraffe -S -E
```

### Paket

If you prefer [Paket](https://fsprojects.github.io/) for managing your project dependencies then specify the `--Paket` (or `-P`) parameter to do so:

```
dotnet new giraffe --Paket
```

This will exclude the package references from the `.fsproj` files and include the needed `paket.dependencies` and `paket.references` files.

For more information regarding the NuGet management and restore options via Paket please see the official [Paket documentation](https://fsprojects.github.io/) for details.

## Known Issues

### Cyclic reference

Please be aware that you cannot name your project "giraffe" (`dotnet new giraffe -o giraffe`) as this will lead the .NET Core CLI to fail with the error `NU1108-Cycle detected` when trying to resolve the project's dependencies.

The same happens if you run a blanket `dotnet new giraffe` from within a folder which is called `Giraffe` as well.

### .NET Core 2.0 issues

The `dotnet new giraffe` command was temporarily broken in certain versions of .NET Core 2.x where all templates with a single supported language (e.g. like Giraffe which only supports F#) were throwing an error.

The affected SDKs are `2.1.x` where `x < 300`. The issue has been fixed in the SDK versions `2.1.300+`.

If you do run into this issue the workaround is to explicitly specify the language:

```
dotnet new giraffe -lang F#
```

### Using Visual Studio

The basic giraffe template doesn't work with `IIS Express` which may be the default IIS used by Visual Studio 2017 to build & publish your application. Make sure to change your drop-down (the top of your window, next to the other Configuration Manager settings) IIS setting to be the name of your project and *NOT* `IIS Express`.

##### Example:

![IIS Express Giraffe Template](https://user-images.githubusercontent.com/3818802/39714515-5535b446-51f8-11e8-9b76-9c89a3e70eea.png)

## Nightly builds and NuGet feed

All official Giraffe packages are published to the official and public NuGet feed.

Unofficial builds (such as pre-release builds from the `develop` branch and pull requests) produce unofficial pre-release NuGet packages which can be pulled from the project's public NuGet feed on AppVeyor:

```
https://ci.appveyor.com/nuget/giraffe-template
```

If you add this source to your NuGet CLI or project settings then you can pull unofficial NuGet packages for quick feature testing or urgent hot fixes.

## Contributing

Please use the `./build.ps1` PowerShell script to build and test the Giraffe template before submitting a PR.

The `./build.ps1` PowerShell script comes with the following feature switches:

| Switch | Description |
| :----- | :---------- |
| No switch | The default script without a switch will build all projects and run all tests before producing a Giraffe template NuGet package. | `./build.ps1` |
| `InstallTemplate` | After successfully creating a new NuGet package for the Giraffe template the `-InstallTemplate` switch will uninstall any existing Giraffe templates before installing the freshly built template again. |
| `CreatePermutations` | The `-CreatePermutations` switch does everything what the `-InstallTemplate` switch does plus it will create a new test project for each individual permutation of the Giraffe template options. All test projects will be created under the `.temp` folder. An existing folder of the same name will be cleared before creating all test projects. |
| `TestPermutations` | The `-TestPermutations` switch does everything what the `-CreatePermutations` switch does plus it will build all test projects and execute their unit tests. This is the most comprehensive build and will likely take several minutes before completing. It is recommended to run this build before submitting a PR. |
| `UpdatePaketDependencies` | The `-UpdatePaketDependencies` switch does everything what the `-TestPermutations` switch does plus it will update the Giraffe NuGet dependencies for all Paket enabled test projects. After updating the Giraffe dependency it will automatically copy the upated `paket.lock` file into the correct template of the `./src` folder. It is recommended to run this build when changing any dependencies for one or many templates. |

### Examples

#### Default:

Windows:

```powershell
> ./build.ps1
```

macOS and Linux:

```powershell
$ pwsh ./build.ps1
```

#### Installing the new template:

Windows:

```powershell
> ./build.ps1 -InstallTemplate
```

macOS and Linux:

```powershell
$ pwsh ./build.ps1 -InstallTemplate
```

#### Creating a test project for each permutation:

Windows:

```powershell
> ./build.ps1 -CreatePermutations
```

macOS and Linux:

```powershell
$ pwsh ./build.ps1 -CreatePermutations
```

#### Creating and testing all test projects for all permutations:

Windows:

```powershell
> ./build.ps1 -TestPermutations
```

macOS and Linux:

```powershell
$ pwsh ./build.ps1 -TestPermutations
```

#### Creating and testing all permutations and updating the `paket.lock` file afterwards:

Windows:

```powershell
> ./build.ps1 -UpdatePaketDependencies
```

macOS and Linux:

```powershell
$ pwsh ./build.ps1 -UpdatePaketDependencies
```

## More information

For more information about Giraffe, how to set up a development environment, contribution guidelines and more please visit the [main documentation](https://github.com/giraffe-fsharp/Giraffe#table-of-contents) page.

## License

[Apache 2.0](https://raw.githubusercontent.com/giraffe-fsharp/giraffe-template/master/LICENSE)
