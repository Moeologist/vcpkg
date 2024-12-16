vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/georgmartius/vid.stab/archive/refs/tags/v1.1.1.tar.gz"
    FILENAME "vid.stab-v1.1.1.tar.gz"
    SHA512 b27ac95ab5302e9500af5a52cb09f557b9dacbdc4dc57a9781e2f9ae65a6ffea396f9819bca1f6a103f9d1896bf3061f1cb647166b14b8de8e89a1b15f010e5c
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_C_FLAGS=-D_USE_MATH_DEFINES
        -DUSE_OMP=OFF
        -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON
)

vcpkg_cmake_install()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
