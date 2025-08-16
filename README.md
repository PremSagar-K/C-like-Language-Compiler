# C-like Language Compiler

This project implements a compiler for a C-like programming language using Flex (lexical analyzer) and Bison (parser generator). The project contains two main components that demonstrate different levels of compiler functionality.

## Project Structure

```
├── basic-lexer-parser/          # Basic lexical analysis and parsing
│   ├── lexer.l                 # Flex lexer specification
│   ├── parser.y                # Bison parser specification
│   └── Makefile               # Build configuration
│
├── three-address-code-generator/ # Advanced compiler with code generation
│   ├── lexer.l                 # Flex lexer specification
│   ├── parser.y                # Bison parser specification with code generation
│   └── Makefile               # Build configuration
│
└── README.md                   # This file
```

## Components

### 1. Basic Lexer-Parser (`basic-lexer-parser/`)

A fundamental implementation that demonstrates:
- **Lexical Analysis**: Tokenization of C-like language constructs
- **Syntax Analysis**: Grammar rules and parsing for basic language features

**Supported Features:**
- Data types: `int`, `float`, `char`, `void`
- Control structures: `if-else`, `for`, `while`
- Operators: Arithmetic (`+`, `-`, `*`, `/`, `**`), Comparison (`==`, `!=`, `<`, `<=`, `>`, `>=`)
- Functions with parameters and return statements
- Variable declarations and assignments
- String literals and printf statements

### 2. Three-Address Code Generator (`three-address-code-generator/`)

An advanced implementation that includes:
- **Lexical Analysis**: Enhanced tokenization with better error handling
- **Syntax Analysis**: Comprehensive grammar rules
- **Intermediate Code Generation**: Generates three-address code for optimization and code generation

**Additional Features:**
- Three-address code generation
- Symbol table management with scope handling
- Support for complex expressions and control flow
- Better handling of logical operations (`&&`, `||`, `!`)
- Comments support (`//` single-line comments)
- Enhanced string and character literal support

## Prerequisites

- **Flex**: Lexical analyzer generator
- **Bison**: Parser generator (GNU version of Yacc)
- **GCC/G++**: C++ compiler
- **Make**: Build automation tool

### Installation on Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install flex bison build-essential
```

### Installation on macOS:
```bash
brew install flex bison
```

## Building and Running

### Basic Lexer-Parser
```bash
cd basic-lexer-parser
make
./a.out < input_file.c
```

### Three-Address Code Generator
```bash
cd three-address-code-generator
make
./a.out < input_file.c
```

## Sample Input

Create a test file `test.c`:
```c
int main() {
    int a, b, c;
    a = 10;
    b = 20;
    c = a + b;
    
    if (c > 25) {
        printf("Sum is greater than 25");
    } else {
        printf("Sum is less than or equal to 25");
    }
    
    return c;
}
```

## Cleaning Build Files

To clean generated files:
```bash
make clean
```

## Language Grammar

The compiler supports a subset of C language features including:

- **Variable Declarations**: `type variable_name;`
- **Function Definitions**: `type function_name(parameters) { body }`
- **Expressions**: Arithmetic and logical expressions with proper precedence
- **Control Structures**: if-else, for loops, while loops
- **Return Statements**: `return expression;`
- **Print Statements**: `printf("string");`

## Development

This project was developed as part of compiler design coursework, demonstrating:
1. Lexical analysis using Flex
2. Syntax analysis using Bison
3. Intermediate code generation
4. Symbol table management
5. Error handling and reporting

## License

This project is for educational purposes.

## Author

Prem Sagar K
