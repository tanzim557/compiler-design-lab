%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

typedef enum {
    NODE_NUM, NODE_ID, NODE_OP, NODE_ASSIGN, NODE_PRINT, NODE_PRINT_STR, NODE_IF, NODE_SEQ, NODE_INPUT
} NodeType;

typedef struct ASTNode {
    NodeType type;
    double val;
    char* str;
    struct ASTNode* left;
    struct ASTNode* right;
    struct ASTNode* cond;
    struct ASTNode* then_branch;
    struct ASTNode* else_branch;
} ASTNode;

ASTNode* make_num(double val) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_NUM; n->val = val; return n;
}
ASTNode* make_id(char* str) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_ID; n->str = strdup(str); return n;
}
ASTNode* make_op(int op, ASTNode* left, ASTNode* right) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_OP; n->val = op; n->left = left; n->right = right; return n;
}
ASTNode* make_assign(char* str, ASTNode* right) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_ASSIGN; n->str = strdup(str); n->right = right; return n;
}
ASTNode* make_input(char* str) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_INPUT; n->str = strdup(str); return n;
}
ASTNode* make_print(ASTNode* right) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_PRINT; n->right = right; return n;
}
ASTNode* make_print_str(char* str) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_PRINT_STR; n->str = strdup(str); return n;
}
ASTNode* make_if(ASTNode* cond, ASTNode* then_b, ASTNode* else_b) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_IF; n->cond = cond; n->then_branch = then_b; n->else_branch = else_b; return n;
}
ASTNode* make_seq(ASTNode* left, ASTNode* right) {
    if (!left) return right;
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = NODE_SEQ; n->left = left; n->right = right; return n;
}

double eval(ASTNode* node);
ASTNode* root = NULL;

struct Symbol {
    char name[100];
    double value;
};
struct Symbol symtab[100];
int sym_count = 0;

double get_symbol(char* name) {
    for(int i=0; i<sym_count; i++) {
        if(strcmp(symtab[i].name, name) == 0) return symtab[i].value;
    }
    return 0.0;
}
void set_symbol(char* name, double value) {
    for(int i=0; i<sym_count; i++) {
        if(strcmp(symtab[i].name, name) == 0) { symtab[i].value = value; return; }
    }
    strcpy(symtab[sym_count].name, name);
    symtab[sym_count].value = value;
    sym_count++;
}
%}

%union {
    double val;
    char* str;
    struct ASTNode* node;
}

%token <val> NUM
%token <str> IDENTIFIER STRING_LITERAL
%token IF ELSE PRINT INPUT
%token EQ NEQ LEQ GEQ

%type <node> program stmt_list stmt if_stmt block assign_stmt print_stmt input_stmt expr

%left '+' '-'
%left '*' '/'
%nonassoc '>' '<' EQ NEQ LEQ GEQ

%%

program:
    stmt_list { root = $1; }
    ;

stmt_list:
    stmt_list stmt { $$ = make_seq($1, $2); }
    | stmt         { $$ = $1; }
    ;

stmt:
    assign_stmt ';' { $$ = $1; }
    | print_stmt ';' { $$ = $1; }
    | input_stmt ';' { $$ = $1; }
    | if_stmt       { $$ = $1; }
    ;

assign_stmt:
    IDENTIFIER '=' expr { $$ = make_assign($1, $3); }
    ;

input_stmt:
    INPUT IDENTIFIER { $$ = make_input($2); }
    ;

print_stmt:
    PRINT expr { $$ = make_print($2); }
    | PRINT STRING_LITERAL { $$ = make_print_str($2); }
    ;

block:
    '{' stmt_list '}' { $$ = $2; }
    ;

if_stmt:
    IF '(' expr ')' block { $$ = make_if($3, $5, NULL); }
    | IF '(' expr ')' block ELSE block { $$ = make_if($3, $5, $7); }
    | IF '(' expr ')' block ELSE if_stmt { $$ = make_if($3, $5, $7); }
    ;

expr:
    NUM { $$ = make_num($1); }
    | IDENTIFIER { $$ = make_id($1); }
    | expr '+' expr { $$ = make_op('+', $1, $3); }
    | expr '-' expr { $$ = make_op('-', $1, $3); }
    | expr '*' expr { $$ = make_op('*', $1, $3); }
    | expr '/' expr { $$ = make_op('/', $1, $3); }
    | expr '<' expr { $$ = make_op('<', $1, $3); }
    | expr '>' expr { $$ = make_op('>', $1, $3); }
    | expr EQ expr { $$ = make_op(EQ, $1, $3); }
    | expr NEQ expr { $$ = make_op(NEQ, $1, $3); }
    | expr LEQ expr { $$ = make_op(LEQ, $1, $3); }
    | expr GEQ expr { $$ = make_op(GEQ, $1, $3); }
    | '(' expr ')' { $$ = $2; }
    ;

%%

double eval(ASTNode* node) {
    if(!node) return 0.0;
    switch(node->type) {
        case NODE_NUM: return node->val;
        case NODE_ID: return get_symbol(node->str);
        case NODE_ASSIGN: {
            double v = eval(node->right);
            set_symbol(node->str, v);
            return v;
        }
        case NODE_PRINT: {
            double v = eval(node->right);
            printf("> Output: %.2f\n", v);
            return v;
        }
        case NODE_PRINT_STR: {
            printf("> %s\n", node->str);
            return 0.0;
        }
        case NODE_INPUT: {
            double v;
            printf("Enter value for %s: ", node->str);
            scanf("%lf", &v);
            set_symbol(node->str, v);
            return v;
        }
        case NODE_SEQ: {
            eval(node->left);
            return eval(node->right);
        }
        case NODE_IF: {
            if(eval(node->cond)) {
                return eval(node->then_branch);
            } else if (node->else_branch) {
                return eval(node->else_branch);
            }
            return 0.0;
        }
        case NODE_OP: {
            double l = eval(node->left);
            double r = eval(node->right);
            int op = (int)node->val;
            switch(op) {
                case '+': return l + r;
                case '-': return l - r;
                case '*': return l * r;
                case '/': return l / r;
                case '<': return l < r;
                case '>': return l > r;
                case EQ: return l == r;
                case NEQ: return l != r;
                case LEQ: return l <= r;
                case GEQ: return l >= r;
            }
        }
    }
    return 0.0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

int main(int argc, char** argv) {
    if(argc > 1) {
        FILE* f = fopen(argv[1], "r");
        if(!f) {
            perror(argv[1]);
            return 1;
        }
        yyin = f;
    }
    
    printf("=========================================\n");
    printf(" Financial Rules Engine (Flex & Bison)\n");
    printf("=========================================\n\n");
    
    yyparse();
    
    if(root) {
        eval(root);
    }
    
    printf("\n--- Final Symbol Table (Variables) ---\n");
    for(int i=0; i<sym_count; i++) {
        printf("  %s = %.2f\n", symtab[i].name, symtab[i].value);
    }
    printf("=========================================\n");
    
    return 0;
}
