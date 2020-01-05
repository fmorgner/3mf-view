#[=[
Discover all tests in our test suites.

This implementation is adapted vom GoogleTest.cmake
#]=]

function(discover_tests)
  set(OPTIONS "")
  set(SINGLE_VALUE_KEYWORDS "TARGET")
  set(MULTI_VALUE_KEYWORDS "")

  cmake_parse_arguments(DISCOVER_TESTS
    "${OPTIONS}"
    "${SINGLE_VALUE_KEYWORDS}"
    "${MULTI_VALUE_KEYWORDS}"
    ${ARGN}
  )

  if(NOT DISCOVER_TESTS_TARGET)
    message(FATAL_ERROR "Missing argument TARGET")
  endif()

  if(NOT TARGET "${DISCOVER_TESTS_TARGET}")
    message(FATAL_ERROR "${DISCOVER_TESTS_TARGET} does not name a target known to CMake")
  endif()

  set(CTEST_FILE_BASE "${CMAKE_CURRENT_BINARY_DIR}/${DISCOVER_TESTS_TARGET}")
  set(CTEST_INCLUDE_FILE "${CTEST_FILE_BASE}_include.cmake")
  set(CTEST_TESTS_FILE "${CTEST_FILE_BASE}_tests.cmake")

  add_custom_command(TARGET "${DISCOVER_TESTS_TARGET}"
    POST_BUILD
    BYPRODUCTS "${CTEST_TESTS_FILE}"
    COMMAND "${CMAKE_COMMAND}"
    "-D" "TEST_TARGET=${DISCOVER_TESTS_TARGET}"
    "-D" "TEST_EXECUTABLE=$<TARGET_FILE:${DISCOVER_TESTS_TARGET}>"
    "-D" "TEST_WORKING_DIR=${CMAKE_CURRENT_BINARY_DIR}"
    "-D" "CTEST_FILE=${CTEST_TESTS_FILE}"
    "-P" "${PROJECT_SOURCE_DIR}/cmake/Modules/DiscoverTestsImpl.cmake"
    VERBATIM
  )

  file(WRITE "${CTEST_INCLUDE_FILE}"
    "if(EXISTS \"${CTEST_TESTS_FILE}\")\n"
    "  include(\"${CTEST_TESTS_FILE}\")\n"
    "else()\n"
    "  add_test(${TARGET}_NOT_BUILT ${TARGET}_NOT_BUILT)\n"
    "endif()\n"
  )

  set_property(DIRECTORY
    APPEND
    PROPERTY TEST_INCLUDE_FILES "${CTEST_INCLUDE_FILE}"
  )
endfunction()