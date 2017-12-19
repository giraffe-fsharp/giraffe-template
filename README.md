# Giraffe Template

![Giraffe](https://raw.githubusercontent.com/giraffe-fsharp/Giraffe/master/giraffe.png)

Giraffe web application template for the `dotnet new` command.

[![NuGet Info](https://buildstats.info/nuget/giraffe-template)](https://www.nuget.org/packages/giraffe-template/)

## Table of contents

- [Documentation](#documentation)
    - [Installation](#installation)
    - [Usage](#usage)
    - [Updating the template](#updating-the-template)
- [More information](#more-information)
- [License](#license)

## Documentation

### Installation

The easiest way to install the Giraffe template is by running the following command in your terminal:

```
dotnet new -i "giraffe-template::*"
```

This will pull and install the [giraffe-template NuGet package](https://www.nuget.org/packages/giraffe-template/) in your .NET environment and make it available to subsequent `dotnet new` commands.

### Usage

After the template has been installed you can create a new Giraffe web application by simply running `dotnet new giraffe` in your terminal:

```
dotnet new giraffe
```

After successfully running this command you should be able to restore, build and run your Giraffe web application without any further doing:

##### Windows example:

```
mkdir GiraffeSampleApp
cd GiraffeSampleApp

dotnet new giraffe

dotnet restore
dotnet build
dotnet run
```


### Updating the template

Whenever there is a new version of the Giraffe template you can update it by re-running the [instructions from the installation](#installation).

You can also explicitly set the version when installing the template:

```
dotnet new -i "giraffe-template::0.9.0"
```

## More information

For more information about Giraffe, how to set up a development environment, contribution guidelines and more please visit the [main documentation](https://github.com/giraffe-fsharp/Giraffe#table-of-contents) page.

## License

[Apache 2.0](https://raw.githubusercontent.com/giraffe-fsharp/Giraffe.DotLiquid/master/LICENSE)