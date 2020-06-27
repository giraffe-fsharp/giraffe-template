#!/bin/sh
#if (UsePaket)
dotnet tool restore
if [ ! -e "paket.lock" ]
then
    dotnet paket install
else
    dotnet paket restore
fi
#endif
dotnet restore src/AppName
dotnet build src/AppName --no-restore

#if (IncludeTests)
dotnet restore tests/AppName.Tests
dotnet build tests/AppName.Tests --no-restore
dotnet test tests/AppName.Tests --no-build
#endif