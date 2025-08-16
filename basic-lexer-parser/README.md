# Basic Lexer-Parser

This directory contains a fundamental implementation of a lexical analyzer and parser for a C-like programming language using Flex and Bison.

## Overview

This component demonstrates the core concepts of compiler frontend design:
- **Lexical Analysis** (Tokenization): Converting source code into tokens
- **Syntax Analysis** (Parsing): Analyzing token sequences according to grammar rules

## Files

- `lexer.l` - Flex lexer specification file
- `parser.y` - Bison parser specification file
- `Makefile` - Build configuration
- `test.c` - Sample input file for testing
- `README.md` - This documentation

## Supported Language Features

### Data Types
- `int` - Integer type
- `float` - Floating-point type
- `char` - Character type
- `void` - Void type (for functions)

### Operators
- **Arithmetic**: `+`, `-`, `*`, `/`, `**` (power)
- **Comparison**: `==`, `!=`, `<`, `<=`, `>`, `>=`
- **Assignment**: `=`

### Control Structures
- `if-else` statements
- `for` loops
- `while` loops
- `return` statements

### Other Features
- Function declarations with parameters
- Variable declarations and assignments
- String literals (quoted strings)
- `printf` statements for output
- Comments and whitespace handling

## Grammar Rules

The parser recognizes the following grammar structure:

```
program → lines

lines → Fun lines 
      | stmts lines
      | ε

Fun → TYPE VAR '(' ARG ')' '{' stmts '}'
    | TYPE VAR '(' ')' '{' stmts '}'

stmts → stmt
      | stmts stmt
      | ε

stmt → declaration
     | assignment
     | if_statement
     | loop_statement
     | return_statement
     | print_statement
```

## Token Types

The lexer recognizes these token types:
- `TYPE` - Data type keywords (int, float, char, void)
- `VAR` - Variable identifiers
- `INT` - Integer literals
- `STRING` - String literals
- `COND_OP` - Comparison operators
- `IF`, `ELSE`, `FOR`, `WHILE`, `RET`, `PRINT` - Keywords
- `EQ` - Assignment operator
- `POW` - Power operator
- Various punctuation: `()`, `[]`, `{}`, `,`

## Building

### Prerequisites
- Flex (lexical analyzer generator)
- Bison (parser generator)
- GCC/G++ compiler
- Make

### Build Commands
```bash
# Build the parser
make

# Clean generated files
make clean  # Note: clean target not defined, only removes a.out
```

### Manual Build Steps
```bash
# Generate parser from Bison file
bison -d parser.y

# Generate lexer from Flex file
flex lexer.l

# Compile and link
g++ -o a.out parser.tab.c lex.yy.c -lfl
```

## Running

```bash
# Run with input file
./a.out < test.c

# Or run interactively
./a.out
# Then type your C-like code and press Ctrl+D when done
```

## Sample Input (`test.c`)

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

## Output

This basic implementation focuses on parsing and will output:
- Parse success/failure messages
- Syntax error reporting with line numbers
- Symbol table information for declared variables

## Error Handling

The parser includes error handling for:
- Syntax errors with line number reporting
- Invalid token sequences
- Undeclared variables (tracked in symbol table)

## Symbol Table Management

The parser maintains symbol tables for:
- **A0D**: Zero-dimensional arrays (simple variables)
- **A1D**: One-dimensional arrays
- **A2D**: Two-dimensional arrays

## Technical Details

- **Lexer**: Uses Flex with `%option yylineno` for line number tracking
- **Parser**: Uses Bison with C++ integration
- **Memory Management**: Basic string and integer value handling
- **Precedence**: Left-associative arithmetic operators with proper precedence

## Limitations

- No semantic analysis or type checking
- No code generation
- Limited error recovery
- Basic symbol table without scope management

## Next Steps

For more advanced features like intermediate code generation and optimization, see the `three-address-code-generator` component in the parent directory.
