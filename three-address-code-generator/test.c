// Sample C-like program for three-address code generation
int main() {
    int x, y, result;
    x = 15;
    y = 25;
    
    // Arithmetic operations
    result = x + y * 2;
    
    // Conditional statement
    if (result >= 50) {
        result = result - 10;
    } else {
        result = result + 5;
    }
    
    // Loop example
    for (int i = 0; i < 3; i = i + 1) {
        result = result + i;
    }
    
    return result;
}
