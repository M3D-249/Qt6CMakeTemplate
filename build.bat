
@echo off
setlocal

set "ENV_FILE=.env"

if not exist "%ENV_FILE%" (
    echo Error: env file not found.
    echo add .env file to project root directory.
    exit /b 1
)

for /f "usebackq tokens=1,* delims==" %%A in ("%ENV_FILE%") do (
    if not "%%A"=="" (
        set "%%A=%%B"
    )
)

if not defined BUILD_DIR set "BUILD_DIR=build"
if not defined INSTALL_DIR set "INSTALL_DIR=dist"
if not defined BUILD_TYPE set "BUILD_TYPE=Release"
if not defined BUILD_TESTING set "BUILD_TESTING=OFF"
if not defined CMAKE_GENERATOR set "CMAKE_GENERATOR=Ninja"

echo ================================
echo         Scripto Build
echo ================================
echo.
echo Qt:         %QT_DIR%
echo Generator:  %CMAKE_GENERATOR%
echo Build Type: %BUILD_TYPE%
echo Tests:      %BUILD_TESTING%
echo.

if not defined QT_DIR (
    echo Error: QT_DIR is not set in .env file.
    exit /b 1
)

if not exist "%QT_DIR%" (
    echo Error: Qt directory does not exist.
    echo %QT_DIR%
    exit 1
)

echo Configuring...

cmake -S . -B "%BUILD_DIR%" ^
    -G "%CMAKE_GENERATOR%" ^
    -DCMAKE_BUILD_TYPE="%BUILD_TYPE%" ^
    -DCMAKE_PREFIX_PATH="%QT_DIR%" ^
    -DBUILD_TESTING="%BUILD_TESTING%" ^
    -Wno-author

if errorlevel 1 (
    echo.
    echo CMake configuration failed.
    exit /b 1
)

echo.
echo Building...

cmake --build %BUILD_DIR%

if errorlevel 1 (
    echo.
    echo Build failed.
    exit /b 1
)

echo.
echo Installing...

if exist "%INSTALL_DIR%" rmdir /s /q "%INSTALL_DIR%"

cmake --install "%BUILD_DIR%" --prefix "%CD%\%INSTALL_DIR%"

if errorlevel 1 (
    echo.
    echo Installation failed.
    exit /b 1
)

echo.
echo ================================
echo Build completed successfully!
echo Output: %CD%\%INSTALL_DIR%

endlocal