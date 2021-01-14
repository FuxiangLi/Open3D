# Adapted from: https://github.com/opencv/opencv/blob/master/3rdparty/ippicv/ippicv.cmake
# Downloads IPPICV libraries from the OpenCV 3rd party repo

include(ExternalProject)
# Commit SHA in the opencv_3rdparty repo
set(IPPICV_COMMIT "a56b6ac6f030c312b2dce17430eef13aed9af274")
# Define actual ICV versions
if(APPLE)
    set(OPENCV_ICV_PLATFORM "macosx")
    set(OPENCV_ICV_PACKAGE_SUBDIR "ippicv_mac")
    set(OPENCV_ICV_NAME "ippicv_2020_mac_intel64_20191018_general.tgz")
    set(OPENCV_ICV_HASH "1c3d675c2a2395d094d523024896e01b")
elseif((UNIX AND NOT ANDROID) OR (UNIX AND ANDROID_ABI MATCHES "x86"))
    set(OPENCV_ICV_PLATFORM "linux")
    set(OPENCV_ICV_PACKAGE_SUBDIR "ippicv_lnx")
    if(X86_64)
        set(OPENCV_ICV_NAME "ippicv_2020_lnx_intel64_20191018_general.tgz")
        set(OPENCV_ICV_HASH "7421de0095c7a39162ae13a6098782f9")
    else()
        set(OPENCV_ICV_NAME "ippicv_2020_lnx_ia32_20191018_general.tgz")
        set(OPENCV_ICV_HASH "ad189a940fb60eb71f291321322fe3e8")
    endif()
elseif(WIN32 AND NOT ARM)
    set(OPENCV_ICV_PLATFORM "windows")
    set(OPENCV_ICV_PACKAGE_SUBDIR "ippicv_win")
    if(X86_64)
        set(OPENCV_ICV_NAME "ippicv_2020_win_intel64_20191018_general.zip")
        set(OPENCV_ICV_HASH "879741a7946b814455eee6c6ffde2984")
    else()
        set(OPENCV_ICV_NAME "ippicv_2020_win_ia32_20191018_general.zip")
        set(OPENCV_ICV_HASH "cd39bdf0c2e1cac9a61101dad7a2413e")
    endif()
else()
    set(WITH_IPPICV OFF)
    message(WARNING "IPP-ICV: Unsupported Platform.")
endif()

set_local_or_remote_url(
    IPPICV_URL
    LOCAL_URL "${THIRD_PARTY_DOWNLOAD_DIR}/${OPENCV_ICV_NAME}"
    REMOTE_URLS "https://raw.githubusercontent.com/opencv/opencv_3rdparty/${IPPICV_COMMIT}/ippicv/${OPENCV_ICV_NAME}"
    )

ExternalProject_Add(ext_ippicv
    PREFIX ippicv
    URL "${IPPICV_URL}"
    URL_HASH MD5=${OPENCV_ICV_HASH}
    UPDATE_COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/ippicv/CMakeLists.txt <SOURCE_DIR>
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    )

ExternalProject_Get_Property(ext_ippicv INSTALL_DIR)
set(IPPICV_INCLUDE_DIR "${INSTALL_DIR}/include/icv/")
set(IPPIW_INCLUDE_DIR "${INSTALL_DIR}/include/")
set(IPPICV_LIBRARY ippicv)
set(IPPIW_LIBRARY ippiw)
set(IPPICV_LIB_DIR "${INSTALL_DIR}/lib")
set(IPPICV_VERSION_STRING "2020.0.0 Gold")  # From icv/ippversion.h