// Example of a simple ALU operation in C
int ALU(int operand1, int operand2, char operation) {
    switch(operation) {
        case '+': return operand1 + operand2;
        case '-': return operand1 - operand2;
        case '&': return operand1 & operand2;
        case '|': return operand1 | operand2;
        default: return 0;
    }
}
