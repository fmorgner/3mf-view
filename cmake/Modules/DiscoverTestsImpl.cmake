#[=[
Discover all tests in our test suites.

This implementation is adapted vom GoogleTestAddTests.cmake
#]=]

set(SCRIPT)

function(add_command CMD EXE TEST)
endfunction()

if(NOT EXISTS "${TEST_EXECUTABLE}")
  message(FATAL_ERROR "The test driver ${TEST_EXECUTABLE} does not exist.")
endif()

execute_process(COMMAND ${TEST_EXECUTABLE} "--tests"
  WORKING_DIRECTORY "${TEST_WORKING_DIR}"
  TIMEOUT "5"
  OUTPUT_VARIABLE "TEST_LIST_OUTPUT"
  RESULT_VARIABLE "TEST_LIST_RESULT"
)

if(NOT ${TEST_LIST_RESULT} EQUAL 0)
  message(FATAL_ERROR "Error while discovering tests:\n"
    "Executable: ${TEST_EXECUTABLE}\n"
    "Result: ${TEST_LIST_RESULT}\n"
    "Output:\n"
    "  ${TEST_LIST_OUTPUT}\n"
  )
endif()

string(REPLACE "\n" ";" TEST_LIST_OUTPUT "${TEST_LIST_OUTPUT}")

foreach(LINE ${TEST_LIST_OUTPUT})
  string(REPLACE "#" ": " TEST_NAME "${LINE}")
  set(SCRIPT "${SCRIPT}add_test(\"${TEST_NAME}\" \"${TEST_EXECUTABLE}\" \"${LINE}\")\n")
endforeach()

file(WRITE "${CTEST_FILE}" "${SCRIPT}")