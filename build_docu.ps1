dotnet run --project ..\ix\src\ix.compiler\src\ixd\Ix.ixd.csproj --framework net7.0 -x .\src\core\ctrl\ -o .\docfx\apictrl\
dotnet docfx build .\docfx\docfx.json --debug
dotnet docfx serve .\docs\
