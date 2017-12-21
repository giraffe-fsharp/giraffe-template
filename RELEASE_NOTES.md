Release Notes
=============

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