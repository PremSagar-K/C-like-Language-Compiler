# Three-Address Code Generator

This directory contains an advanced compiler implementation that generates three-address code (intermediate representation) for a C-like programming language.

## Overview

This component demonstrates advanced compiler techniques:
- **Lexical Analysis**: Enhanced tokenization with comment support
- **Syntax Analysis**: Comprehensive grammar with semantic actions
- **Intermediate Code Generation**: Three-address code generation
- **Symbol Table Management**: Scope-aware symbol tables
- **Control Flow**: Proper handling of conditional and loop constructs

## Files

- `lexer.l` - Advanced Flex lexer specification
- `parser.y` - Bison parser with code generation
- `Makefile` - Build configuration with optimization flags
- `test.c` - Sample input file demonstrating features
- `README.md` - This documentation

## Advanced Features

### Enhanced Language Support
- **Comments**: Single-line comments (`//`)
- **String and Character Literals**: Better handling with escape sequences
- **Logical Operators**: `&&` (AND), `||` (OR), `!` (NOT)
- **Enhanced Control Flow**: More robust if-else, for, while constructs

### Code Generation
- **Three-Address Code**: Intermediate representation suitable for optimization
- **Temporary Variables**: Automatic generation (`t1`, `t2`, etc.)
- **Label Generation**: For control flow (`L1`, `L2`, etc.)
- **Jump Instructions**: Conditional and unconditional jumps

### Symbol Table Features
- **Scope Management**: Global and local scope handling
- **Function Parameters**: Parameter passing and tracking
- **Variable Tracking**: Enhanced variable declaration and usage analysis

## Three-Address Code Format

The compiler generates three-address code in the form:
```
result = operand1 operator operand2
```

### Example Transformations

**Input C Code:**
```c
int x = 10;
int y = 20;
int z = x + y * 2;
```

**Generated Three-Address Code:**
```
x = 10
y = 20
t1 = y * 2
z = x + t1
```

**Control Flow Example:**
```c
if (x > y) {
    z = x;
} else {
    z = y;
}
```

**Generated Code:**
```
if x > y goto L1
z = y
goto L2
L1: z = x
L2:
```

## Data Structures

### Node Class
```cpp
class Node {
    public:
    string value;           // Node value
    string label;          // Label for jumps
    vector<string> V;      // Additional data
    Node *left, *right, *parent;  // Tree structure
};
```

### Symbol Management
- **Scope Stack**: `stack<set<string>> S_scope`
- **Global Scope**: `set<string> global_scope`
- **Parameter Stack**: `stack<vector<string>> S`
- **Variable Stack**: `stack<vector<pair<string, Node*>>> V_stack`

## Building

### Prerequisites
- Flex (lexical analyzer generator)
- Bison (parser generator)
- GCC/G++ compiler with C++11 support
- Make

### Build Commands
```bash
# Build the compiler (optimized)
make

# Build individual components
make parser.tab.c    # Generate parser
make lex.yy.c       # Generate lexer

# Clean generated files
make clean
```

### Build Process
1. `bison -d parser.y` → Generates `parser.tab.c` and `parser.tab.h`
2. `flex lexer.l` → Generates `lex.yy.c`
3. `g++ -O3 lex.yy.c parser.tab.c` → Compiles with optimization

## Running

```bash
# Run with input file
./a.out < test.c

# Run interactively
./a.out
# Type your code and press Ctrl+D
```

## Sample Input (`test.c`)

```c
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
```

## Output Features

The compiler provides:
- **Three-Address Code**: Intermediate representation
- **Symbol Table**: Variable and function declarations
- **Scope Information**: Global vs local variable tracking
- **Control Flow**: Label and jump generation
- **Error Reporting**: Enhanced syntax error messages

## Advanced Grammar Features

### Expression Handling
- **Precedence**: Proper operator precedence
- **Associativity**: Left and right associative operators
- **Type Propagation**: Basic type information flow

### Control Structures
- **Nested Scopes**: Proper scope entry and exit
- **Short-Circuit Evaluation**: Logical operator optimization
- **Loop Constructs**: For and while loop code generation

## Technical Implementation

### Key Functions
- `find_and()`: Handles logical AND operations
- Scope management with push/pop operations
- Temporary variable generation
- Label generation for control flow

### Memory Management
- Stack-based scope management
- Dynamic node allocation
- String duplication for token values

## Optimizations

- **Compiler Flags**: Built with `-O3` optimization
- **Efficient Data Structures**: STL containers for symbol management
- **Minimal Temporary Variables**: Smart temporary generation

## Error Handling

Enhanced error reporting includes:
- Line number tracking
- Scope-aware error messages
- Better recovery from syntax errors
- Semantic error detection

## Comparison with Basic Parser

| Feature | Basic Parser | Three-Address Generator |
|---------|-------------|------------------------|
| Comments | No | Yes (`//`) |
| Code Generation | No | Yes (3-address) |
| Scope Management | Basic | Advanced |
| Logical Operators | No | Yes (`&&`, `||`, `!`) |
| Optimization | None | `-O3` compile flag |
| Symbol Tables | Simple sets | Stack-based scopes |

## Future Enhancements

- **Code Optimization**: Dead code elimination, constant folding
- **Target Code Generation**: Assembly or machine code output
- **Type Checking**: Enhanced semantic analysis
- **Error Recovery**: Better error recovery mechanisms
