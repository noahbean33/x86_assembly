// Example in C-like pseudocode
int a = 5;    // Operand 1
int b = 10;   // Operand 2
int result;

void fetch_decode_execute_cycle() {
    // Fetch
    instruction = memory[PC];
    PC++;

    // Decode
    if (instruction == "ADD") {
        operand1 = a;
        operand2 = b;
    }

    // Execute
    if (instruction == "ADD") {
        result = operand1 + operand2;
    }
}

int main() {
    fetch_decode_execute_cycle();
    printf("Result: %d\n", result);  // Output: Result: 15
    return 0;
}
