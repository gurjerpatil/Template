:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: create T4 Template links for: 
::
:: Validation.T4
:: DbContext.T4 
:: DataTransferObject.T4
::
:: Requirement
:: your must execute this command within the 
:: folder: ..\<module>.BusinessComponents\EntityModel
:: T4 Templates must be remove from subversion first....
::
:: Author: Rolf Eisenhut, RIB Stuttgart
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
cls

set svnexe="..\..\..\..\..\BinPool\BuildTools\svn\bin\svn.exe"

set undersvnControl=0
set abort=

:: Check if directory is under version control
%svnexe% info 1>svninfo.templog 2>&1
::findstr /N /A:fc /C:"E155007:" svninfo.log
findstr /N /C:"Path: ." svninfo.templog >nul
if %errorlevel% equ 0  set undersvnControl=1
del /q svninfo.templog

if %undersvnControl% equ 1 echo i'm under svn control
if %undersvnControl% equ 0 (
 echo.
 echo ############################################################
 echo Current folder is not under svn version Control!!!
 echo Please first check in the whole solution 
 echo and then try again
 echo ############################################################
 echo.
 set abort=1
 goto :AbortMessage
)

set currentfolder=%~p0
set currentfolder=%currentfolder:~0,-1%
set EntityModelFolder=%currentfolder:~-11%

if /i "%EntityModelFolder%" neq "EntityModel" ( 
	echo you'r not in the 'EntityModel' Folder, 
	echo but in '%EntityModelFolder%'. 
	echo Execution not allowed
	set abort=1
)	

if exist Validation.T4 ( 
echo please first delete file:  Validation.T4
set abort=1
)	
if exist DbContext.T4 ( 
echo please first delete file:  DbContext.T4
set abort=1
)	
if exist DataTransferObject.T4 ( 
echo please first delete file:  DataTransferObject.T4
set abort=1
)	
if exist GroupingAttributes.T4 ( 
echo please first delete file:  GroupingAttributes.T4
set abort=1
)	
if exist LookupFilterKeysAttributes.T4 ( 
echo please first delete file:  LookupFilterKeysAttributes.T4
set abort=1
)	

:AbortMessage
if defined abort (
	echo.
	echo ###################################################
	echo !!!!!!!!!!!!!!!! processing stopped !!!!!!!!!!!!!!!
	echo !!!!!!!!!!!!!!!! First fix open issues !!!!!!!!!!!!
	echo ###################################################
	echo.
  pause
  goto  :eof
)

if exist svn.externals del /q svn.externals

:::::::::::::::::::::::::::::::::::::::::::::::::::
:: write  links into a temporary file
:::::::::::::::::::::::::::::::::::::::::::::::::::
echo ../../../../../BinPool/BuildTools/T4.Templates/Validation.T4 Validation.T4>svn.externals
echo ../../../../../BinPool/BuildTools/T4.Templates/DbContext.T4 DbContext.T4>>svn.externals
echo ../../../../../BinPool/BuildTools/T4.Templates/DataTransferObject.T4 DataTransferObject.T4>>svn.externals
echo ../../../../../BinPool/BuildTools/T4.Templates/GroupingAttributes.T4 GroupingAttributes.T4>>svn.externals
echo ../../../../../BinPool/BuildTools/T4.Templates/LookupFilterKeysAttributes.T4 LookupFilterKeysAttributes.T4>>svn.externals


:::::::::::::::::::::::::::::::::::::::::::::::::::
:: create the links in current directory
:::::::::::::::::::::::::::::::::::::::::::::::::::
"..\..\..\..\..\BinPool\BuildTools\svn\bin\svn" propset -F ".\svn.externals" svn:externals .

echo.
echo IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
echo I n f o -- following properties added:
%svnexe% propget svn:externals 
echo.
:::::::::::::::::::::::::::::::::::::::::::::::::::
:: delete temporary file
:::::::::::::::::::::::::::::::::::::::::::::::::::
del /q svn.externals

echo.
echo ###################################################
echo processing done .... 
echo ###################################################
pause