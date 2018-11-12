#!/bin/sh
#if (UsePaket)
if [ ! -e "paket.lock" ]
then
    exec mono .paket/paket.exe install
fi
#endif
dotnet restore src/AppNamePlaceholder
dotnet build src/AppNamePlaceholder

#if (IncludeTests)
dotnet restore tests/AppNamePlaceholder.Tests
dotnet build tests/AppNamePlaceholder.Tests
dotnet test tests/AppNamePlaceholder.Tests
#endif