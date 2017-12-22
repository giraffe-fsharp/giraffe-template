dotnet restore src/AppNamePlaceholder
dotnet build src/AppNamePlaceholder

rem #if (IncludeTests)
dotnet restore tests/AppNamePlaceholder.Tests
dotnet build tests/AppNamePlaceholder.Tests
dotnet test tests/AppNamePlaceholder.Tests
rem #endif