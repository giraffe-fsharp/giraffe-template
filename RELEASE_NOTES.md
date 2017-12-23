Release Notes
=============

## Next version

#### Enhancements

- Updated the default Giraffe tempalte to the latest version of Giraffe and made use of the new HTML attributes from the `GiraffeViewEngine`.

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