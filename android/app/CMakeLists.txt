cmake_minimum_required(VERSION 3.4.1)
include_directories(../../include)

add_library(lib_opencv SHARED IMPORTED)
set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libopencv_java4.so)

add_library(filters SHARED ../../open_cv/image_editor.cpp)

find_library(log-lib log)

target_link_libraries(filters lib_opencv ${log-lib})