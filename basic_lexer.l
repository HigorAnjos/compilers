%{
    #include <iostream>
    #include <string>
    #include <map>
    #include <cstdlib>

// Funções externas e variáveis globais
extern int yylex();
extern int yylineno;
extern char* yytext;
std::map<std::string, int> variables;

// Função para lidar com erros
void yyerror(const char* s) {
    std::cerr << "Erro de sintaxe: " << s << " na linha " << yylineno << std::endl;
    exit(1);
}
%}

%option noyywrap

// Expressões regulares para palavras-chave, identificadores e operadores
DIGIT       [0-9]+
ID          [A-Za-z_][A-Za-z0-9_]*

%%

// Palavras-chave
"PRINT"       { return PRINT; }
"LET"         { return LET; }
"IF"          { return IF; }
"THEN"        { return THEN; }
"GOTO"        { return GOTO; }
"HALT"        { return HALT; }
"INPUT"       { return INPUT; }
"REM"         { /* Ignorar comentário até o final da linha */ while (*yytext != '\n') yylex(); }
{DIGIT}       { yylval.num = atoi(yytext); return NUMBER; }
{ID}          { yylval.id = strdup(yytext); return IDENTIFIER; }

// Operadores
"="           { return '='; }
"<"           { return '<'; }
">"           { return '>'; }
"+"           { return '+'; }
"-"           { return '-'; }
"*"           { return '*'; }
"/"           { return '/'; }

[ \t\r\n]+    { /* Ignorar espaços em branco e quebras de linha */ }
.             { printf("Caractere não reconhecido: %s\n", yytext); }

%%

// Função principal que inicia o lexer
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if (!file) {
            std::cerr << "Erro ao abrir o arquivo: " << argv[1] << std::endl;
            return 1;
        }
        yyin = file;
    }

    // Executa o lexer
    yylex();
    
    return 0;
}
