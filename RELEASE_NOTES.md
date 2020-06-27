Release Notes
=============

## 1.0.0

- Updated Giraffe to version `4.1.x`
- Set `netcoreapp3.1` as default target framework
- Upgraded all templates to use .NET Core's generic host
- Updated Paket to use `dotnet tools` distribution
- Fixed cyclic dependency issue when `dotnet new giraffe` is run from within a folder named `Giraffe`
- Added `paket.references` files to `*.fsproj` files when `-UsePaket` is enabled
- Creating a `.sln` file referencing the created projects as part of the template
- Fixed bug where hyphens in project name caused builds to fail (e.g. `dotnet new giraffe -n foo-bar`)
- Fixed build some warnings
-

## 0.20.0

- Added shebang and fixed shellcheck warnings
- Updated Giraffe to version 3.4.x
- Updated TestHost to version 2.1.x for test projects

## 0.19.0

- Updated Giraffe to version 3.2.x
- Updated Giraffe.Razor to version 2.0.x
- Added TaskBuilder.fs as dependency to all templates

## 0.18.0

- Updated all templates to latest Giraffe version
- Updates all templates to .NET Core 2.1 apps
- Updated paket to latest version
- Fixed minor bugs with the generation of the `None` view engine template
- Fixed line ending issue in *.sh files
- Added post action to set read permissions to the build.sh file

## 0.17.0

Updated paket.exe to latest Paket release (fixes #12).

## 0.16.0

Updated all templates to use the latest `Giraffe 1.1.*` release.

## 0.15.0

Updated all templates to use the latest `Giraffe 1.0.0` release.

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