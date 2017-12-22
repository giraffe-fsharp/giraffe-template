# Giraffe Template

![Giraffe](https://raw.githubusercontent.com/giraffe-fsharp/Giraffe/master/giraffe.png)

Giraffe web application template for the `dotnet new` command.

[![NuGet Info](https://buildstats.info/nuget/giraffe-template)](https://www.nuget.org/packages/giraffe-template/)

## Table of contents

- [Installation](#installation)
- [Basics](#basics)
- [Optional parameters](#optional-parameters)
    - [--ViewEngine](#--viewengine)
    - [--IncludeTests](#--includetests)
- [Updating the template](#updating-the-template)
- [Nightly builds and NuGet feed](#nightly-builds-and-nuget-feed)
- [More information](#more-information)
- [License](#license)

## Installation

The easiest way to install the Giraffe template is by running the following command in your terminal:

```
dotnet new -i "giraffe-template::*"
```

This will pull and install the [giraffe-template NuGet package](https://www.nuget.org/packages/giraffe-template/) in your .NET environment and make it available to subsequent `dotnet new` commands.

## Basics

After the template has been installed you can create a new Giraffe web application by simply running `dotnet new giraffe` in your terminal:

```
dotnet new giraffe
```

The Giraffe template only supports the F# language at the moment.

Further information and more help can be found by running `dotnet new giraffe --help` in your terminal.

## Optional parameters

### --ViewEngine

The Giraffe template supports three different view engines:

- `giraffe` (default)
- `razor`
- `dotliquid`

You can optionally specify the `--ViewEngine` parameter (short `-V`) to pass in one of the supported values:

```
dotnet new giraffe --ViewEngine razor
```

The same using the abbreviated `-V` parameter:

```
dotnet new giraffe -V razor
```

If you do not specify the `--ViewEngine` parameter then the `dotnet new giraffe` command will automatically create a Giraffe web application with the default `GiraffeViewEngine` engine.

### --IncludeTests

When creating a new Giraffe web application you can optionally specify the `--IncludeTests` (short `-I`) parameter to automatically generate a default unit test project for your application:

```
dotnet new giraffe --IncludeTests
```

This parameter can also be combined with other parameters:

```
dotnet new giraffe --ViewEngine razor --IncludeTests
```

## Updating the template

Whenever there is a new version of the Giraffe template you can update it by re-running the [instructions from the installation](#installation).

You can also explicitly set the version when installing the template:

```
dotnet new -i "giraffe-template::0.11.0"
```

## Nightly builds and NuGet feed

All official Giraffe packages are published to the official and public NuGet feed.

Unofficial builds (such as pre-release builds from the `develop` branch and pull requests) produce unofficial pre-release NuGet packages which can be pulled from the project's public NuGet feed on AppVeyor:

```
https://ci.appveyor.com/nuget/giraffe-template
```

If you add this source to your NuGet CLI or project settings then you can pull unofficial NuGet packages for quick feature testing or urgent hot fixes.

## More information

For more information about Giraffe, how to set up a development environment, contribution guidelines and more please visit the [main documentation](https://github.com/giraffe-fsharp/Giraffe#table-of-contents) page.

## License

[Apache 2.0](https://raw.githubusercontent.com/giraffe-fsharp/Giraffe.DotLiquid/master/LICENSE)