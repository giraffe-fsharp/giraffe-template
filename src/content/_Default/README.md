# AppName.1

A [Giraffe](https://github.com/giraffe-fsharp/Giraffe) web application, which has been created via the `dotnet new giraffe` command.

## Build and test the application

### Windows

Run the `build.bat` script in order to restore, build and test (if you've selected to include tests) the application:

```
> ./build.bat
```

### Linux/macOS

Run the `build.sh` script in order to restore, build and test (if you've selected to include tests) the application:

```
$ ./build.sh
```

## Run the application

After a successful build you can start the web application by executing the following command in your terminal:

```
dotnet run -p src/AppName.1
```

The application uses HTTPS redirection when run in production which is the default unless explicitly overridden. If you don't have a certificate configured for HTTPS, be sure to set `ASPNETCORE_ENVIRONMENT=Development`. In order to test production mode during development you can generate a self signed certificate using this guide: https://docs.microsoft.com/en-us/dotnet/core/additional-tools/self-signed-certificates-guide

After the application has started visit [http://localhost:5000](http://localhost:5000) in your preferred browser.