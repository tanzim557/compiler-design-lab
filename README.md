# âš™ï¸ Compiler Design Laboratory & Rules Engine

[![C Language](https://img.shields.io/badge/C-A8B9CC?style=for-the-badge&logo=c&logoColor=black)](https://en.wikipedia.org/wiki/C_(programming_language))
[![Flex](https://img.shields.io/badge/Flex-Lexer-informational?style=for-the-badge)](https://github.com/westes/flex)
[![Bison](https://img.shields.io/badge/Bison-LALR_Parser-blue?style=for-the-badge)](https://www.gnu.org/software/bison/)
[![HTML5](https://img.shields.io/badge/HTML5-Interactive_UI-E34F26?style=for-the-badge&logo=html5&logoColor=white)](https://developer.mozilla.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> An academic and practical compiler engineering repository featuring complete Lexical Analysis and LALR Syntax Parsing implementations using Flex and Bison, accompanied by an interactive browser-based Financial Rules Engine.

---

## ðŸŒŸ Key Components

- **ðŸ”¤ Lexical Analyzer (lexer.l)**: Tokenizes complex input streams including identifiers, keywords, arithmetic/logical operators, and numeric literals with line tracking.
- **ðŸŒ³ Syntactic Parser (parser.y)**: LALR(1) grammar specification enforcing syntactic rules, building abstract parse trees, and executing semantic actions.
- **ðŸ“Š Financial Rules Engine (inancial-rules-engine.html)**: Interactive web UI demonstrating practical compiler rules applied to financial transactions, tax calculations, and discount qualification.
- **ðŸ§ª Comprehensive Test Suites**: Test cases for tax calculations (input_tax.txt), e-commerce discounts (input_ecommerce.txt), and senior citizen allowances (input_senior.txt).

---

## ðŸš€ Building & Running

### Requirements
- GCC / Clang
- Flex (Fast Lexical Analyzer)
- Bison (GNU Parser Generator)

### Compilation
`ash
cd flex_bison_engine

# Compile Lexer & Parser
flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -o compiler_engine.exe

# Execute with test inputs
./compiler_engine.exe < input_tax.txt
`
Or run the provided Windows helper script: uild.bat.

---

## ðŸ‘¤ Author

Developed by **[Mubassher Alam Tanzim](https://github.com/tanzim557)**  
GitHub: [@tanzim557](https://github.com/tanzim557) â€¢ Email: mubassheralam0@gmail.com

---

## ðŸ“„ License
This project is licensed under the MIT License.
