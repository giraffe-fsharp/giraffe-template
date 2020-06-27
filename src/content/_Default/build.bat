rem #if (UsePaket)
IF NOT EXIST paket.lock (
    START /WAIT .paket/paket.exe install
)
rem #endif
dotnet restore src/AppNamePlaceholder
dotnet build src/AppNamePlaceholder --no-restore

rem #if (IncludeTests)
dotnet restore tests/AppNamePlaceholder.Tests
dotnet build tests/AppNamePlaceholder.Tests --no-restore
dotnet test tests/AppNamePlaceholder.Tests --no-build
rem #endif