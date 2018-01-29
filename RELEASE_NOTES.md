Release Notes
=============

## 0.14.0

#### New features

- Added the ASP.NET Core default developer exception page when environment is development.

## 0.13.0

#### New features

- Added a default `web.config` file to all templates to support Azure deployments.

## 0.12.0

#### New features

- Added `none` as a new option to the `--ViewEngine` parameter, which will create a Giraffe web application without any view engine (Web API only).
- Added a new parameter called `--UsePaket` which will use Paket instead of NuGet as the package manager for the Giraffe web application.

#### Enhancements

- Updated the default Giraffe template to the latest version of Giraffe and made use of the new HTML attributes from the `GiraffeViewEngine`.

## 0.11.0

#### New features

Added an additional parameter called `IncludeTests` which can be added to auto generate an accompanying test project to your Giraffe web application.

#### Examples:

Default Giraffe web application with the `GiraffeViewEngine` and no tests:

```
dotnet new giraffe
```

Default Giraffe web application with the `GiraffeViewEngine` and a default test project:

```
dotnet new giraffe --IncludeTests
```

Giraffe web application with the Razor view engine and a default test project:

```
dotnet new giraffe --ViewEngine razor --IncludeTests
```

## 0.10.0

#### New features

The Giraffe template supports three different view engines now:

- `giraffe` (default)
- `razor`
- `dotliquid`

You can optionally specify the `--ViewEngine` (or short `-V`) parameter and select one of the supported options when creating a new Giraffe project:

```
dotnet new giraffe --ViewEngine razor
```

When you run `dotnet new giraffe` it will automatically create a new Giraffe project with the default `GiraffeViewEngine` engine.

## 0.9.0 and before

Previous releases of this library were documented in [Giraffe's release notes](https://github.com/giraffe-fsharp/Giraffe/blob/master/RELEASE_NOTES.md).