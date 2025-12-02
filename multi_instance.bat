@echo off
setlocal enabledelayedexpansion

:: Define the base registry path
set "basePath=HKEY_CURRENT_USER\SOFTWARE\Classes\Extensions\ContractId\Windows.Launch\PackageId"

:: Find the Minecraft UWP PackageId
for /f "tokens=*" %%a in ('reg query "%basePath%" /f "Microsoft.MinecraftUWP_" /k 2^>nul') do (
    set "packageId=%%a"
    set "packageId=!packageId:%basePath%\=!"
    if "!packageId!" neq "" (
        echo Found Minecraft UWP PackageId: !packageId!
        goto :apply_registry_change
    )
)

echo Minecraft UWP PackageId not found in the registry.
goto :end

:apply_registry_change
:: Define the full registry path
set "fullPath=%basePath%\!packageId!\ActivatableClassId\App\CustomProperties"

:: Create the CustomProperties key if it doesn't exist
reg add "%fullPath%" /f >nul 2>&1

:: Add or update the SupportsMultipleInstances DWORD value
reg add "%fullPath%" /v "SupportsMultipleInstances" /t REG_DWORD /d 1 /f >nul

echo Successfully enabled multiple instances for Minecraft UWP (PackageId: !packageId!).

:end
pause