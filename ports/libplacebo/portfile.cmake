
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/haasn/libplacebo/archive/refs/tags/v6.292.0.tar.gz"
    FILENAME "v6.292.0.tar.gz"
    SHA512 19eb53b9ac0670ab34ea57712a25131f3161ce344a1f69bcfc0759b5cdae30efec6eed0132806e947d30d1577d976654744da99918ee237bff1785251dd870c7
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dtests=false
)

vcpkg_install_meson()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()
