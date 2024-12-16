vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO OpenVisualCloud/SVT-HEVC
    REF "v${VERSION}"
    SHA512 f5b9d9a090cb04ada0a3f310522f00b619ae628b8474fe7e1c7f562a017b5a9d0c8c58ab9a35b43cb19f2568fbc59e0395dcd517b7983924b175393ad2ba4299
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SVTHEVC_BUILD_SHARED_LIB)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" SVTHEVC_BUILD_STATIC_LIB)

vcpkg_find_acquire_program(YASM)
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_SHARED_LIBS=${SVTHEVC_BUILD_SHARED_LIB}
        -DBUILD_APP=OFF
)

vcpkg_cmake_install()
file(COPY "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/svt-hevc")
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.md")
