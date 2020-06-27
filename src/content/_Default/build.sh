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
dotnet restore src/AppNamePlaceholder
dotnet build src/AppNamePlaceholder --no-restore

#if (IncludeTests)
dotnet restore tests/AppNamePlaceholder.Tests
dotnet build tests/AppNamePlaceholder.Tests --no-restore
dotnet test tests/AppNamePlaceholder.Tests --no-build
#endif