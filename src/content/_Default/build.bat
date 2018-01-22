rem #if (UsePaket)
IF NOT EXIST paket.lock (
    START /WAIT .paket/paket.exe install
)
rem #endif
dotnet restore src/AppNamePlaceholder
dotnet build src/AppNamePlaceholder

rem #if (IncludeTests)
dotnet restore tests/AppNamePlaceholder.Tests
dotnet build tests/AppNamePlaceholder.Tests
dotnet test tests/AppNamePlaceholder.Tests
rem #endif