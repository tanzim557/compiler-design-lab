# Compiler Design Laboratory and Rules Engine

[![C Language](https://img.shields.io/badge/C-A8B9CC?style=for-the-badge&logo=c&logoColor=black)](https://en.wikipedia.org/wiki/C_(programming_language))
[![Flex](https://img.shields.io/badge/Flex-Lexer-informational?style=for-the-badge)](https://github.com/westes/flex)
[![Bison](https://img.shields.io/badge/Bison-LALR_Parser-blue?style=for-the-badge)](https://www.gnu.org/software/bison/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

An academic and practical compiler engineering repository featuring complete Lexical Analysis and LALR Syntax Parsing implementations using Flex and Bison, accompanied by an interactive browser-based Financial Rules Engine.

---

## Key Components

- Lexical Analyzer (lexer.l): Tokenizes complex input streams including identifiers, keywords, arithmetic/logical operators, and numeric literals with line tracking.
- Syntactic Parser (parser.y): LALR(1) grammar specification enforcing syntactic rules, building abstract parse trees, and executing semantic actions.
- Financial Rules Engine (financial-rules-engine.html): Interactive web UI demonstrating practical compiler rules applied to financial transactions and tax calculations.
- Comprehensive Test Suites: Test cases for tax calculations (input_tax.txt), e-commerce discounts (input_ecommerce.txt), and senior allowances (input_senior.txt).

---

## Building and Running

### Requirements
- GCC / Clang
- Flex (Fast Lexical Analyzer)
- Bison (GNU Parser Generator)

### Compilation
```bash
cd flex_bison_engine

# Compile Lexer and Parser
flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -o compiler_engine.exe

# Execute with test inputs
./compiler_engine.exe < input_tax.txt
```
Or run the provided Windows helper script: build.bat.

---

## Author

Developed by Mubassher Alam Tanzim
- GitHub: https://github.com/tanzim557
- Email: mubassheralam0@gmail.com

---

## License
This project is licensed under the MIT License.
