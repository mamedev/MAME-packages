:: Find root dir
@if not defined MSYS2_ROOT (
    for /f %%i in ("%~dp0\..") do @set MSYS2_ROOT=%%~fi
)

:: Add aliases
@doskey /macrofile="%MSYS2_ROOT%\win32\aliases"

@set MINGW32=
@set MINGW64=
@set ADD_PATH=
@set PATH=C:\Windows\System32;C:\Windows
:: Enhance Path
@if "%CONFIG_ARCHITECTURE%"=="x86" (
	@set MINGW32=%MSYS2_ROOT%\mingw32
	@set MINGW=%MSYS2_ROOT%\mingw32
	@set prompt=[MINGW32] $p$g
) else (
	@set MINGW64=%MSYS2_ROOT%\mingw64
	@set MINGW=%MSYS2_ROOT%\mingw64
	@set prompt=[MINGW64] $p$g
)
@if not defined VS_DISABLE (
	@if defined VS120COMNTOOLS (
		@call "%VS120COMNTOOLS%vsvars32.bat"
	)
	@if defined VS140COMNTOOLS (
		@call "%VS140COMNTOOLS%vsvars32.bat"
	)
)
@set MINGW_PATH=%MINGW%\bin

@IF EXIST "%MSYS2_ROOT%\vendor\python" (
	@set ADD_PATH=%MSYS2_ROOT%\vendor\python;%MSYS2_ROOT%\vendor\python\Scripts;%ADD_PATH%
)
@IF EXIST "%MSYS2_ROOT%\vendor\nodejs" (
	@set ADD_PATH=%appdata%\npm;%MSYS2_ROOT%\vendor\nodejs;%ADD_PATH%
)
@IF EXIST "%MSYS2_ROOT%\vendor\android-ndk" (
	@set ADD_PATH=%MSYS2_ROOT%\vendor\android-ndk;%ADD_PATH%
	@set ANDROID_NDK_ROOT=%MSYS2_ROOT%\vendor\android-ndk
	@set ANDROID_NDK_ARM=%MSYS2_ROOT%\vendor\android-ndk\toolchains\arm-linux-androideabi-4.9\prebuilt\windows-x86_64
	@set ANDROID_NDK_ARM64=%MSYS2_ROOT%\vendor\android-ndk\toolchains\aarch64-linux-android-4.9\prebuilt\windows-x86_64
	@set ANDROID_NDK_MIPS=%MSYS2_ROOT%\vendor\android-ndk\toolchains\mipsel-linux-android-4.9\prebuilt\windows-x86_64
	@set ANDROID_NDK_MIPS64=%MSYS2_ROOT%\vendor\android-ndk\toolchains\mips64el-linux-android-4.9\prebuilt\windows-x86_64
	@set ANDROID_NDK_X86=%MSYS2_ROOT%\vendor\android-ndk\toolchains\x86-4.9\prebuilt\windows-x86_64
	@set ANDROID_NDK_X64=%MSYS2_ROOT%\vendor\android-ndk\toolchains\x86_64-4.9\prebuilt\windows-x86_64
)
@IF EXIST "%MSYS2_ROOT%\vendor\emsdk" (
	@IF NOT EXIST "%USERPROFILE%\.emscripten" (
		@echo Creating file .emscripten
		@call "%MSYS2_ROOT%\vendor\emsdk\emsdk.bat" activate > nul
	)
	@set EMSCRIPTEN=%MSYS2_ROOT%\vendor\emsdk\emscripten\1.35.0
	@call "%MSYS2_ROOT%\vendor\emsdk\emsdk.bat" construct_env > nul
)
@IF EXIST "%MSYS2_ROOT%\vendor\nacl_sdk" (
	@set NACL_SDK_ROOT=%MSYS2_ROOT%\vendor\nacl_sdk\pepper_47
	@set CYGWIN=nodosfilewarning
)
@IF EXIST "%MSYS2_ROOT%\vendor\java" (
	@set JAVA_HOME=%MSYS2_ROOT%\vendor\java
)
@IF EXIST "%MSYS2_ROOT%\vendor\android-sdk" (
	@set ANDROID_HOME=%MSYS2_ROOT%\vendor\android-sdk
)

@set PATH=%ADD_PATH%;%MSYS2_ROOT%\win32;%MINGW_PATH%;%MSYS2_ROOT%\usr\bin;%PATH%

@set PYTHON_EXECUTABLE=%MINGW%\bin\python.exe
@bash --login /init.sh
