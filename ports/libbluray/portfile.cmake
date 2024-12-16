vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/ShiftMediaProject/libbluray/archive/refs/tags/1.3.4-1.zip"
    FILENAME "libbluray-1.3.4-1.zip"
    SHA512 6c8cd5c4719143d2d81ba6a7b6cd43a93907c465dc0d7d9154044022e58613626f2294929228ee8fbdf2d19ce054b440bd032eb1fb6690743b0b1d8ddd4953ae
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

file(GLOB SOURCE_FILES ${SOURCE_PATH}/SMP/contrib/libudfread/src/*)
foreach(SOURCE_FILE ${SOURCE_FILES})
   file(COPY ${SOURCE_FILE} DESTINATION "${SOURCE_PATH}/contrib/libudfread/src")
endforeach()

if("${VCPKG_LIBRARY_LINKAGE}" STREQUAL "dynamic")
    set(ENABLE_SHARED yes)
    set(ENABLE_STATIC no)
else()
    set(ENABLE_SHARED no)
    set(ENABLE_STATIC yes)
endif()

list(APPEND OPTIONS
    --enable-shared=${ENABLE_SHARED}
    --enable-static=${ENABLE_STATIC})

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    DETERMINE_BUILD_TRIPLET
    USE_WRAPPERS
    OPTIONS
        "--prefix=${CURRENT_INSTALLED_DIR}"
        --without-external-libudfread
        --disable-examples
        --disable-bdjava-jar
        ${OPTIONS}
)

vcpkg_install_make()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(READ "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libbluray.pc" _content)
string(REPLACE "-lgdi32" "-lgdi32 -luser32 -ladvapi32 -lshell32" _content ${_content})
file(WRITE "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libbluray.pc" ${_content})

file(READ "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libbluray.pc" _content)
string(REPLACE "-lgdi32" "-lgdi32 -luser32 -ladvapi32 -lshell32" _content ${_content})
file(WRITE "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libbluray.pc" ${_content})

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
