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
dotnet restore
dotnet build --no-restore
#if (IncludeTests)
dotnet test --no-build
#endif