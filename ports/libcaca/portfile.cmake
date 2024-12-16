vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/cacalabs/libcaca/releases/download/v0.99.beta20/libcaca-0.99.beta20.tar.gz"
    FILENAME "libcaca-0.99.beta20.tar.gz"
    SHA512 ab03e6c7d17fd152b2d5e9161799531f5e87322e174cb9d25874700f5bc1acfaf8bc2736e733998dad906f793c5a0304740dd39eec04a5e4c3d181bb109b4f23
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(ENABLE_SHARED yes)
    set(ENABLE_STATIC no)
else()
    set(ENABLE_SHARED no)
    set(ENABLE_STATIC yes)
    set(CFLAGS -DCACA_STATIC=1)
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" AND VCPKG_CRT_LINKAGE STREQUAL "dynamic")
    list(APPEND CFLAGS_DEBUG -MDd)
    list(APPEND CFLAGS_RELEASE -MD)
endif()

list(APPEND OPTIONS
    --enable-shared=${ENABLE_SHARED}
    --enable-static=${ENABLE_STATIC}
    --enable-csharp=no
    --enable-java=no
    --enable-python=no
    --enable-ruby=no)

list(APPEND OPTIONS_DEBUG --enable-debug LDFLAGS=-lzlibd)
list(APPEND OPTIONS_RELEASE LDFLAGS=-lzlib)

set(CFLAGS "${CFLAGS} -Dstrcasecmp=_stricmp -Dpopen=_popen -D_USE_MATH_DEFINES -utf-8")
set(CFLAGS_DEBUG "${CFLAGS_DEBUG} ${CFLAGS}")
set(CFLAGS_RELEASE "${CFLAGS_RELEASE} ${CFLAGS}")

list(APPEND OPTIONS_DEBUG "CFLAGS=${CFLAGS_DEBUG}")
list(APPEND OPTIONS_DEBUG "CXXFLAGS=${CFLAGS_DEBUG}")
list(APPEND OPTIONS_RELEASE "CFLAGS=${CFLAGS_RELEASE}")
list(APPEND OPTIONS_RELEASE "CXXFLAGS=${CFLAGS_RELEASE}")


if (CMAKE_HOST_WIN32)
    list(APPEND msys_require_packages binutils libtool autoconf automake-wrapper automake1.16 m4 which)
    vcpkg_acquire_msys(MSYS_ROOT PACKAGES ${msys_require_packages})
    set(ENV{PATH} "${MSYS_ROOT}/usr/bin;$ENV{PATH}")
    set(base_cmd "${MSYS_ROOT}/usr/bin/bash.exe" --noprofile --norc --debug)

    vcpkg_execute_required_process(
        COMMAND ${base_cmd} -c "./bootstrap"
        WORKING_DIRECTORY "${SOURCE_PATH}"
        LOGNAME "bootstrap-${TARGET_TRIPLET}"
    )
else()
    vcpkg_execute_required_process(
        COMMAND "./bootstrap"
        WORKING_DIRECTORY "${SOURCE_PATH}"
        LOGNAME "bootstrap-${TARGET_TRIPLET}"
    )
endif()

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    DETERMINE_BUILD_TRIPLET
    USE_WRAPPERS
    OPTIONS
        ${OPTIONS}
    OPTIONS_DEBUG ${OPTIONS_DEBUG}
    OPTIONS_RELEASE ${OPTIONS_RELEASE}
    AUTOCONFIG
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(GLOB_RECURSE _pkg_components "${CURRENT_PACKAGES_DIR}/*.pc")
    foreach(_pkg_comp ${_pkg_components})
        file(READ ${_pkg_comp} _content)
        string(REPLACE "Requires:" "Requires: zlib" _content ${_content})
        string(REPLACE "Cflags: \"-I\${includedir}\"" "Cflags: \"-I\${includedir}\" -DCACA_STATIC" _content ${_content})
        file(WRITE ${_pkg_comp} ${_content})
    endforeach()
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
