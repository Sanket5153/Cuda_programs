#include <stdio.h>

void helper(int x) {
    if (x <= 0) return;
    printf("helper: %d\n", x);
    helper(x-1);
}

int compute(int a, int b) {
    int result = 0;
    for (int i = 0; i < 1000000; i++) {
        result += (a * b + i) % (a + 1);
    }
    return result;
}

int main(void) {
    int val = compute(10, 20);
    printf("Val = %d\n", val);
    helper(5);
    return 0;
}
