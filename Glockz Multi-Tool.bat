@echo off
chcp 65001
color 07
title Glockz Hub

rem Set the file paths
set "user_file=userdata.txt"
set "ban_file=banned_users.txt"
set "ban_access_file=ban_access.txt"

:login_screen
cls
echo ╔══════════════════════════════════════════╗
echo ║            --REGISTER/LOGIN--            ║
echo ╚══════════════════════════════════════════╝
echo.

echo Choose an option:
echo [1] Login
echo [2] Register
echo [3] Exit

set /p "option=Enter your choice: "

if "%option%"=="1" goto login
if "%option%"=="2" goto register
if "%option%"=="3" exit

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto login_screen

:login
cls
echo ╔══════════════════════════════════════════╗
echo ║             --PLEASE LOGIN--             ║
echo ╚══════════════════════════════════════════╝
echo.
set /p "username=Username: "
set /p "password=Password: "

rem Check if the user is banned
findstr /i "\<%username%\>" "%ban_file%" >nul
if %errorlevel% equ 0 (
    echo.
    echo You are banned from accessing this system.
    pause
    goto login_screen
)

rem Check if the username exists in the user file
findstr /i "\<%username%\>" "%user_file%" >nul
if %errorlevel% neq 0 (
    echo.
    echo Username "%username%" not found. Please register first.
    pause
    goto register
)

rem Verify the password for the corresponding username
for /f "tokens=2 delims=:" %%A in ('findstr /i "\<%username%\>" "%user_file%"') do set "stored_password=%%A"
if "%password%"=="%stored_password%" (
    echo.
    echo Login successful!
    pause
    goto menu
) else (
    echo.
    echo Incorrect password. Please try again.
    pause
    goto login
)

:register
cls
echo ╔══════════════════════════════════════════╗
echo ║            --REGISTER SCREEN--           ║
echo ╚══════════════════════════════════════════╝
echo.
echo Register a new account:
set /p "new_username=New Username: "

rem Check if the user is banned before allowing registration
findstr /i "\<%new_username%\>" "%ban_file%" >nul
if %errorlevel% equ 0 (
    echo.
    echo You are banned from creating a new account.
    pause
    goto login_screen
)

set /p "new_password=New Password: "

rem Check if the username already exists in the user file
findstr /i "\<%new_username%\>" "%user_file%" >nul
if %errorlevel% equ 0 (
    echo.
    echo Username "%new_username%" already exists. Please choose a different username.
    pause
    goto register
)

rem Add the new username and password to the user file
echo %new_username%:%new_password%>>"%user_file%"
echo.
echo Account registered successfully!
pause
goto login

:menu
cls
echo ╔══════════════════════════════════════════╗
echo ║             --MENU SCREEN--              ║
echo ╚══════════════════════════════════════════╝
echo.
echo Welcome, %username%! Please select an option:
echo.
echo [1] Profile Settings
echo [2] Messages
echo [3] Friends List
echo [4] Settings
echo [5] Log Out
echo. 
echo.
echo ╔══════════════════════════════════════════╗
echo ║             --OWNER CMDS--               ║
echo ╚══════════════════════════════════════════╝
echo.
echo NOTE: Only users with permissions can use these commands.
echo.
echo [Ban] Ban User
echo [UnBan] Unban User
echo.
set /p "choice=Enter your choice: "
if "%choice%"=="1" goto profile_settings
if "%choice%"=="2" goto messages
if "%choice%"=="3" goto friends_list
if "%choice%"=="4" goto settings
if "%choice%"=="Ban" goto ban_user
if "%choice%"=="UnBan" goto unban_user
if "%choice%"=="5" goto logout
echo.
echo Invalid choice. Please try again.
pause
goto menu

:profile_settings
echo Profile settings selected.
pause
goto menu

:messages
echo Messages selected.
pause
goto menu

:friends_list
echo Friends list selected.
pause
goto menu

:settings
echo Settings selected.
pause
goto menu

:ban_user
cls
echo ╔══════════════════════════════════════════╗
echo ║             --BAN A USER--               ║
echo ╚══════════════════════════════════════════╝
echo.

rem Check if the user has access to the ban feature
findstr /i "\<%username%\>" "%ban_access_file%" >nul
if %errorlevel% neq 0 (
    echo.
    echo You do not have permission to ban users.
    pause
    goto menu
)

set /p "ban_username=Enter the username to ban: "

rem Check if the user is already banned
findstr /i "\<%ban_username%\>" "%ban_file%" >nul
if %errorlevel% equ 0 (
    echo.
    echo User "%ban_username%" is already banned.
    pause
    goto menu
)

rem Add the username to the ban file
echo %ban_username%>>"%ban_file%"
echo.
echo User "%ban_username%" has been banned successfully.
pause
goto menu

:unban_user
cls
echo ╔══════════════════════════════════════════╗
echo ║             --UNBAN A USER--             ║
echo ╚══════════════════════════════════════════╝
echo.

rem Check if the user has access to the unban feature
findstr /i "\<%username%\>" "%ban_access_file%" >nul
if %errorlevel% neq 0 (
    echo.
    echo You do not have permission to unban users.
    pause
    goto menu
)

set /p "unban_username=Enter the username to unban: "

rem Check if the user is banned
findstr /i "\<%unban_username%\>" "%ban_file%" >nul
if %errorlevel% neq 0 (
    echo.
    echo User "%unban_username%" is not banned.
    pause
    goto menu
)

rem Remove the username from the ban file
type "%ban_file%" | findstr /v "\<%unban_username%\>" >"%ban_file%.tmp" && move /y "%ban_file%.tmp" "%ban_file%" >nul
echo.
echo User "%unban_username%" has been unbanned successfully.
pause
goto menu

:logout
echo Logging out...
timeout /t 2 >nul
exit