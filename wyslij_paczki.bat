@echo off
rem Wysyla najnowsze wersje texturepackow na GitHub (PanPoppo/wificraft-txt).
rem Kazda paczka trafia do swojego folderu w repozytorium. Zeby dodac kolejna paczke,
rem dopisz ponizej nowa linie:  call :paczka "nazwa_folderu" "pelna sciezka do folderu paczki" || goto :blad
setlocal
cd /d "%~dp0"

call :paczka "boxpvp" "%APPDATA%\.ogulniega\shared\default\resourcepacks\wificraft - TXT\wificraft" || goto :blad

git add -A
git diff --cached --quiet && (echo Brak zmian - nic do wyslania.& goto :koniec)
for /f "usebackq delims=" %%t in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm'"`) do set "CZAS=%%t"
git commit -q -m "Aktualizacja paczek %CZAS%" || goto :blad
git -c credential.helper= -c "credential.helper=!gh auth git-credential" push -u origin main || goto :blad
echo.
echo Gotowe - wyslano na https://github.com/PanPoppo/wificraft-txt
goto :koniec

:paczka
echo Kopiuje paczke %~1 ...
if not exist "%~2\pack.mcmeta" (echo Nie ma paczki w: %~2& exit /b 1)
rem /MIR = folder w repo jest dokladna kopia paczki; pomijane: stary zip, kopie .bak i plik stanu TXManagera
robocopy "%~2" "%~dp0%~1" /MIR /XF wificraft.zip *.bak .txmanager.json /NFL /NDL /NJH /NJS /NP >nul
if %ERRORLEVEL% GEQ 8 (echo Blad kopiowania paczki %~1& exit /b 1)
exit /b 0

:blad
echo.
echo Cos poszlo nie tak - sprawdz komunikat wyzej.
if not defined BEZ_PAUZY pause
exit /b 1

:koniec
if not defined BEZ_PAUZY pause
exit /b 0
