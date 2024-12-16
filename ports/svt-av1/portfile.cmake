vcpkg_from_gitlab(
    OUT_SOURCE_PATH SOURCE_PATH
    GITLAB_URL https://gitlab.com
    REPO AOMediaCodec/SVT-AV1
    REF "v${VERSION}"
    # SHA512 ee212f05aa8299094e0b888506034be38ddb220890c8b2bc7661625ce42c64201393f6e4e78d04669668c92efd4ead0f48c81d3d51623bed310a3d7c931852dd
    SHA512 a5cd9f4867bcf0239b957f2136a16b6adee389ad1a1a5573ff9e6c6b6d1a88a936f639d2bd53005d58113a7934d592e320fd33c3b3e35f26a1694c07ca1b9301
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SVTAV1_BUILD_SHARED_LIB)

vcpkg_find_acquire_program(YASM)
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_SHARED_LIBS=${SVTAV1_BUILD_SHARED_LIB}
        -DREPRODUCIBLE_BUILDS=ON
        -DBUILD_APPS=OFF
)

vcpkg_cmake_install()
vcpkg_fixup_pkgconfig()
file(COPY "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/svt-av1")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.md")
