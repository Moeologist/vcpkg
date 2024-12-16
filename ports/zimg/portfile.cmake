vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/sekrit-twc/zimg/archive/refs/tags/release-3.0.5.tar.gz"
    FILENAME "zimg-3.0.5.tar.gz"
    SHA512 85467ec9fcf81ea1ae3489b539ce751772a1dab6c6159928b3c5aa9f1cb029f0570b4624a254d4620886f3376fbf80f9bb829a88c3fe543f99f38947951dc500
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
        ${OPTIONS}
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
