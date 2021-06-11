if(NOT DEFINED ENV{STEAMWORKS_SDK})
	message(FATAL_ERROR "environment variable STEAMWORKS_SDK is not set")
endif()

cmake_path(SET STEAMWORKS_SDK NORMALIZE $ENV{STEAMWORKS_SDK})

string(REGEX MATCH
	"steamworks_sdk_([0-9])([0-9]+)$"
	REGEX_SUCCESS
	${STEAMWORKS_SDK}
)
string(LENGTH ${REGEX_SUCCESS} REGEX_SUCCESS_LEN)
if(NOT REGEX_SUCCESS_LEN GREATER 0)
	message(FATAL_ERROR "failed to parse version from STEAMWORKS_SDK")
endif()

set(MAJOR ${CMAKE_MATCH_1})
set(MINOR ${CMAKE_MATCH_2})

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src)

file(
	COPY
		${STEAMWORKS_SDK}/sdk/public
		${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
		${CMAKE_CURRENT_LIST_DIR}/config.cmake.in
	DESTINATION
		${SOURCE_PATH}
)

configure_file(
	${CMAKE_CURRENT_LIST_DIR}/version.cmake.in
	${SOURCE_PATH}/version.cmake
	@ONLY
)

vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH})
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(
	PACKAGE_NAME SteamSDK
	CONFIG_PATH lib/cmake/SteamSDK
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL ${STEAMWORKS_SDK}/sdk/Readme.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
