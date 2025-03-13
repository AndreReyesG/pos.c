#include "unity.h" 
#include "grocery.h"

void setUp(void) {}
void tearDown(void) {}

void test_hello(void) {
  TEST_ASSERT_EQUAL_STRING("Hello, World", hello());
}

int main(void) {
  UNITY_BEGIN();
  RUN_TEST(test_hello);
  return UNITY_END();
}
