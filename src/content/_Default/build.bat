rem #if (UsePaket)
dotnet tool restore
IF NOT EXIST paket.lock (
    dotnet paket install
) ELSE (
    dotnet paket restore
)
rem #endif
dotnet restore src/AppName
dotnet build src/AppName --no-restore

rem #if (IncludeTests)
dotnet restore tests/AppName.Tests
dotnet build tests/AppName.Tests --no-restore
dotnet test tests/AppName.Tests --no-build
rem #endif