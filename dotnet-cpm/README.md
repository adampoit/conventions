# dotnet-cpm

Enables NuGet Central Package Management via `Directory.Packages.props`.

## Settings

None.

## Behavior

- Creates `Directory.Packages.props` if it doesn't exist
- Sets `ManagePackageVersionsCentrally` to `true`
- Preserves existing central `PackageVersion` items and other project settings

## Usage

After applying this convention, add `<PackageReference Include="PackageName" />` (without `Version`) in your `.csproj` files, and add the version centrally in `Directory.Packages.props`:

```xml
<ItemGroup>
  <PackageVersion Include="PackageName" Version="1.0.0" />
</ItemGroup>
```
