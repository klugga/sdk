REM best to use this script outside of the MEGA repo.  Once the libraries are built, the CMakeLists.txt can be adjusted to refer to them.
mkdir 3rdParty
cd 3rdParty
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
CALL .\bootstrap-vcpkg.bat

REM You may want to build with Checked Iterators turned off (ie. define _ITERATOR_DEBUG_LEVEL=0)
REM You would want that because otherwise some operations (eg. deleting the node tree) can be slow in debug builds
REM You can enable that by uncommenting this section below, or edit your STL headers to disable it.
REM Disabling it in the STL headers might seem extreme, but it works for WinRTC (which you need for MEGAchat if using that)

REM copy .\triplets\x86-windows-static.cmake .\triplets\x86-windows-static-uncheckediterators.cmake
REM copy .\triplets\x64-windows-static.cmake .\triplets\x64-windows-static-uncheckediterators.cmake
REM echo #comment >> .\triplets\x86-windows-static-uncheckediterators.cmake
REM echo #comment >> .\triplets\x64-windows-static-uncheckediterators.cmake
REM echo set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS} -D_ITERATOR_DEBUG_LEVEL=0") >> .\triplets\x86-windows-static-uncheckediterators.cmake
REM echo set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS} -D_ITERATOR_DEBUG_LEVEL=0") >> .\triplets\x64-windows-static-uncheckediterators.cmake
REM echo set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} -D_ITERATOR_DEBUG_LEVEL=0") >> .\triplets\x86-windows-static-uncheckediterators.cmake
REM echo set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} -D_ITERATOR_DEBUG_LEVEL=0") >> .\triplets\x64-windows-static-uncheckediterators.cmake
REM set tripletsuffix="-uncheckediterators"

CALL :build_one zlib
CALL :build_one cryptopp
CALL :build_one c-ares
CALL :build_one sqlite3
CALL :build_one libevent
CALL :build_one libsodium
CALL :build_one freeimage
CALL :build_one ffmpeg
CALL :build_one gtest
CALL :build_one openssl
CALL :build_one curl

exit /b 0

:build_one 
.\vcpkg.exe install --triplet x64-windows-static%tripletsuffix% %1%
echo %errorlevel% %1% x64-windows-static%tripletsuffix% >> buildlog
.\vcpkg.exe install --triplet x86-windows-static%tripletsuffix% %1%
echo %errorlevel% %1% x86-windows-static%tripletsuffix% >> buildlog
exit /b 0
