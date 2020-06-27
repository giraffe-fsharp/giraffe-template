rem #if (UsePaket)
dotnet tool restore
IF NOT EXIST paket.lock (
    dotnet paket install
) ELSE (
    dotnet paket restore
)
rem #endif
dotnet restore src/AppNamePlaceholder
dotnet build src/AppNamePlaceholder --no-restore

rem #if (IncludeTests)
dotnet restore tests/AppNamePlaceholder.Tests
dotnet build tests/AppNamePlaceholder.Tests --no-restore
dotnet test tests/AppNamePlaceholder.Tests --no-build
rem #endif