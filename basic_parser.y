%{
#include <iostream>
#include <map>
#include <cstdlib>
#include <string>

void yyerror(const char* s);
extern int yylex();
extern int yylineno;

std::map<std::string, int> variables; // Tabela de variáveis

void executeCommand(const std::string& command);

%}

%union {
    int num;
    char* id;
}

%token PRINT LET IF THEN GOTO HALT INPUT
%token <num> NUMBER
%token <id> IDENTIFIER
%left '+' '-'
%left '*' '/'

%%

program:
    program statement '\n'
    | /* vazio */
    ;

statement:
    PRINT expression { std::cout << "Resultado: " << $2 << std::endl; }
    | LET IDENTIFIER '=' expression { variables[$2] = $4; std::cout << $2 << " = " << $4 << std::endl; }
    | IF condition THEN statement
    | GOTO NUMBER { /* Implementar salto de linha aqui */ }
    | HALT { exit(0); }
    | INPUT IDENTIFIER { int val; std::cin >> val; variables[$2] = val; }
    ;

condition:
    expression '=' expression { $$ = ($1 == $3); }
    | expression '<' expression { $$ = ($1 < $3); }
    | expression '>' expression { $$ = ($1 > $3); }
    ;

expression:
    expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { $$ = $1 / $3; }
    | NUMBER { $$ = $1; }
    | IDENTIFIER { $$ = variables[$1]; }
    ;

%%

void yyerror(const char* s) {
    std::cerr << "Erro: " << s << " na linha " << yylineno << std::endl;
    exit(1);
}
