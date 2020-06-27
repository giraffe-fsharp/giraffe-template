rem #if (UsePaket)
dotnet tool restore
IF NOT EXIST paket.lock (
    dotnet paket install
) ELSE (
    dotnet paket restore
)
rem #endif
dotnet restore
dotnet build --no-restore
rem #if (!ExcludeTests)
dotnet test --no-build
rem #endif