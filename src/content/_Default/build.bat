rem #if (Paket)
dotnet tool restore
if errorlevel 1 exit /b %errorlevel%
IF NOT EXIST paket.lock (
    dotnet paket install
) ELSE (
    dotnet paket restore
)
if errorlevel 1 exit /b %errorlevel%
rem #endif
dotnet restore
if errorlevel 1 exit /b %errorlevel%
dotnet build --no-restore
if errorlevel 1 exit /b %errorlevel%
rem #if (!ExcludeTests)
dotnet test --no-build
if errorlevel 1 exit /b %errorlevel%
rem #endif