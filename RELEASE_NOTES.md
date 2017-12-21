Release Notes
=============

## 0.10.0

#### New features

The `griaffe` template supports three different view engine types at creation now:

- `xmlviewengine` (default)
- `razor`
- `dotliquid`

When you run `dotnet new giraffe` it will automatically create a new Giraffe project with the default `Giraffe.XmlViewEngine` engine.

You can optionally specify the `--ViewEngine` (or short `-V`) parameter and select a different view engine when creating a new Giraffe project:

```
dotnet new giraffe --ViewEngine razor
```

or

```
dotnet new giraffe -V dotliquid
```

## 0.9.0 and before

Previous releases of this library were documented in [Giraffe's release notes](https://github.com/giraffe-fsharp/Giraffe/blob/master/RELEASE_NOTES.md).