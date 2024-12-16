vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO clMathLibraries/clFFT
    REF c59712e136fa6207956af22f5c0e4cee7d05340e
    SHA512 db7ae2dfed12312ef5ce4c42b63a30bf2421c7726afa6d18f87f7db3bdf56b2f4ecb81331f26e4474416c87159344d2ba247d7fb1325c65ad9853d5dbc1395c0
    HEAD_REF master
    PATCHES
        tweak-install.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/src"
    OPTIONS
        -DCMAKE_CXX_STANDARD=11 # 17 removes std::unary_function
        -DBUILD_LOADLIBRARIES=OFF
        -DBUILD_EXAMPLES=OFF
        -DSUFFIX_LIB=
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_cmake_config_fixup(CONFIG_PATH CMake)
else()
    vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/clFFT)
endif()

vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
