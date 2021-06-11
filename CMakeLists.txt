cmake_minimum_required(VERSION 3.20)

macro(set_from_environment VARIABLE)
	if(NOT DEFINED ${VARIABLE} AND DEFINED ENV{${VARIABLE}})
		set(${VARIABLE} $ENV{${VARIABLE}})
	endif()
endmacro()

set_from_environment(VCPKG_ROOT)

if(DEFINED VCPKG_ROOT)
	set(CMAKE_TOOLCHAIN_FILE "${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
	set(VCPKG_OVERLAY_PORTS "${CMAKE_CURRENT_SOURCE_DIR}/ports" CACHE STRING "")
	set(VCPKG_OVERLAY_TRIPLETS "${CMAKE_CURRENT_SOURCE_DIR}/triplets" CACHE STRING "")
	set(VCPKG_TARGET_TRIPLET "x64-windows-static-md-custom" CACHE STRING "")
else()
	message(
		WARNING
		"Variable VCPKG_ROOT is not set. Continuing without vcpkg."
	)
endif()

project(Example LANGUAGES CXX)

add_executable(${PROJECT_NAME} main.cpp)

find_package(SteamSDK REQUIRED CONFIG)

target_link_libraries(
	${PROJECT_NAME}
	PRIVATE
		SteamSDK::SteamSDK
)
