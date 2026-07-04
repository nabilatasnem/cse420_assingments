%{
#include<bits/stdc++.h>
#include"symbol_info.h"
#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);
extern FILE *yyin;
using namespace std;

ofstream outlog;
extern int line_num;

void yyerror(const char *s) { }
%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE GOTO PRINTLN
%token ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON COLON ID CONST_INT CONST_FLOAT

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
start : program {
        outlog<<"At line no: "<<line_num<<" start : program \n\n"<<endl;
    }
    ;

program : program unit {
        outlog<<"At line no: "<<line_num<<" program : program unit \n\n";
        outlog<<$1->getnameofsymbol()+"\n"+$2->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+"\n"+$2->getnameofsymbol(),"program");
    }
    | unit {
        outlog<<"At line no: "<<line_num<<" program : unit \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"program");
    }
    ;

unit : variable_decl {
        outlog<<"At line no: "<<line_num<<" unit : variable_decl \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"unit");
    }
    | func_definition {
        outlog<<"At line no: "<<line_num<<" unit : func_definition \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"unit");
    }
    ;

func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement {
        outlog<<"At line no: "<<line_num<<" func_definition : type_specifier ID LPAREN param_list RPAREN compound_statement \n\n";
        outlog<<$1->getnameofsymbol()<<" "<<$2->getnameofsymbol()<<"("<<$4->getnameofsymbol()<<")\n"<<$6->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+" "+$2->getnameofsymbol()+"("+$4->getnameofsymbol()+")\n"+$6->getnameofsymbol(),"func_definition");
    }
    | type_specifier ID LPAREN RPAREN compound_statement {
        outlog<<"At line no: "<<line_num<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement \n\n";
        outlog<<$1->getnameofsymbol()<<" "<<$2->getnameofsymbol()<<"()\n"<<$5->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+" "+$2->getnameofsymbol()+"()\n"+$5->getnameofsymbol(),"func_definition");
    }
    ;

param_list : param_list COMMA type_specifier ID {
        outlog<<"At line no: "<<line_num<<" param_list : param_list COMMA type_specifier ID \n\n";
        outlog<<$1->getnameofsymbol()<<", "<<$3->getnameofsymbol()<<" "<<$4->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+","+$3->getnameofsymbol()+" "+$4->getnameofsymbol(),"param_list");
    }
    | param_list COMMA type_specifier {
        outlog<<"At line no: "<<line_num<<" param_list : param_list COMMA type_specifier \n\n";
        outlog<<$1->getnameofsymbol()<<", "<<$3->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+","+$3->getnameofsymbol(),"param_list");
    }
    | type_specifier ID {
        outlog<<"At line no: "<<line_num<<" param_list : type_specifier ID \n\n";
        outlog<<$1->getnameofsymbol()<<" "<<$2->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+" "+$2->getnameofsymbol(),"param_list");
    }
    | type_specifier {
        outlog<<"At line no: "<<line_num<<" param_list : type_specifier \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"param_list");
    }
    ;

compound_statement : LCURL statements RCURL {
        outlog<<"At line no: "<<line_num<<" compound_statement : LCURL statements RCURL \n\n";
        outlog<<"{\n"<<$2->getnameofsymbol()<<"\n}\n\n";
        $$ = new symbol_info("{\n"+$2->getnameofsymbol()+"\n}","compound_statement");
    }
    | LCURL RCURL {
        outlog<<"At line no: "<<line_num<<" compound_statement : LCURL RCURL \n\n";
        outlog<<"{\n}\n\n";
        $$ = new symbol_info("{\n}","compound_statement");
    }
    ;

variable_decl : type_specifier declaration_list SEMICOLON {
        outlog<<"At line no: "<<line_num<<" variable_decl : type_specifier declaration_list SEMICOLON \n\n";
        outlog<<$1->getnameofsymbol()<<" "<<$2->getnameofsymbol()<<";\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+" "+$2->getnameofsymbol()+";","variable_decl");
    }
    ;

type_specifier : INT {
        outlog<<"At line no: "<<line_num<<" type_specifier : INT \n\n"; outlog<<"int\n\n";
        $$ = new symbol_info("int","type_specifier");
    }
    | FLOAT {
        outlog<<"At line no: "<<line_num<<" type_specifier : FLOAT \n\n"; outlog<<"float\n\n";
        $$ = new symbol_info("float","type_specifier");
    }
    | VOID {
        outlog<<"At line no: "<<line_num<<" type_specifier : VOID \n\n"; outlog<<"void\n\n";
        $$ = new symbol_info("void","type_specifier");
    }
    | CHAR {
        outlog<<"At line no: "<<line_num<<" type_specifier : CHAR \n\n"; outlog<<"char\n\n";
        $$ = new symbol_info("char","type_specifier");
    }
    ;

declaration_list : declaration_list COMMA ID {
        outlog<<"At line no: "<<line_num<<" declaration_list : declaration_list COMMA ID \n\n";
        outlog<<$1->getnameofsymbol()<<","<<$3->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+","+$3->getnameofsymbol(),"declaration_list");
    }
    | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD {
        outlog<<"At line no: "<<line_num<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD \n\n";
        outlog<<$1->getnameofsymbol()<<","<<$3->getnameofsymbol()<<"["<<$5->getnameofsymbol()<<"]\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+","+$3->getnameofsymbol()+"["+$5->getnameofsymbol()+"]","declaration_list");
    }
    | ID {
        outlog<<"At line no: "<<line_num<<" declaration_list : ID \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"declaration_list");
    }
    | ID LTHIRD CONST_INT RTHIRD {
        outlog<<"At line no: "<<line_num<<" declaration_list : ID LTHIRD CONST_INT RTHIRD \n\n";
        outlog<<$1->getnameofsymbol()<<"["<<$3->getnameofsymbol()<<"]\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+"["+$3->getnameofsymbol()+"]","declaration_list");
    }
    ;

statements : statement {
        outlog<<"At line no: "<<line_num<<" statements : statement \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"statements");
    }
    | statements statement {
        outlog<<"At line no: "<<line_num<<" statements : statements statement \n\n";
        outlog<<$1->getnameofsymbol()<<"\n"<<$2->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+"\n"+$2->getnameofsymbol(),"statements");
    }
    ;

statement : variable_decl {
        outlog<<"At line no: "<<line_num<<" statement : variable_decl \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"statement");
    }
    | expression_statement {
        outlog<<"At line no: "<<line_num<<" statement : expression_statement \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"statement");
    }
    | compound_statement {
        outlog<<"At line no: "<<line_num<<" statement : compound_statement \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"statement");
    }
    | FOR LPAREN expression_statement expression_statement expression RPAREN statement {
        outlog<<"At line no: "<<line_num<<" statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement \n\n";
        outlog<<"for("<<$3->getnameofsymbol()<<$4->getnameofsymbol()<<$5->getnameofsymbol()<<")\n"<<$7->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info("for("+$3->getnameofsymbol()+$4->getnameofsymbol()+$5->getnameofsymbol()+")\n"+$7->getnameofsymbol(),"statement");
    }
    | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {
        outlog<<"At line no: "<<line_num<<" statement : IF LPAREN expression RPAREN statement \n\n";
        outlog<<"if("<<$3->getnameofsymbol()<<")\n"<<$5->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info("if("+$3->getnameofsymbol()+")\n"+$5->getnameofsymbol(),"statement");
    }
    | IF LPAREN expression RPAREN statement ELSE statement {
        outlog<<"At line no: "<<line_num<<" statement : IF LPAREN expression RPAREN statement ELSE statement \n\n";
        outlog<<"if("<<$3->getnameofsymbol()<<")\n"<<$5->getnameofsymbol()<<"\nelse\n"<<$7->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info("if("+$3->getnameofsymbol()+")\n"+$5->getnameofsymbol()+"\nelse\n"+$7->getnameofsymbol(),"statement");
    }
    | WHILE LPAREN expression RPAREN statement {
        outlog<<"At line no: "<<line_num<<" statement : WHILE LPAREN expression RPAREN statement \n\n";
        outlog<<"while("<<$3->getnameofsymbol()<<")\n"<<$5->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info("while("+$3->getnameofsymbol()+")\n"+$5->getnameofsymbol(),"statement");
    }
    | PRINTLN LPAREN ID RPAREN SEMICOLON {
        outlog<<"At line no: "<<line_num<<" statement : PRINTLN LPAREN ID RPAREN SEMICOLON \n\n";
        outlog<<"printf("<<$3->getnameofsymbol()<<");\n\n";
        $$ = new symbol_info("printf("+$3->getnameofsymbol()+");","statement");
    }
    | RETURN expression SEMICOLON {
        outlog<<"At line no: "<<line_num<<" statement : RETURN expression SEMICOLON \n\n";
        outlog<<"return "<<$2->getnameofsymbol()<<";\n\n";
        $$ = new symbol_info("return "+$2->getnameofsymbol()+";","statement");
    }
    ;

expression_statement : SEMICOLON {
        outlog<<"At line no: "<<line_num<<" expression_statement : SEMICOLON \n\n";
        outlog<<";\n\n";
        $$ = new symbol_info(";","expression_statement");
    }
    | expression SEMICOLON {
        outlog<<"At line no: "<<line_num<<" expression_statement : expression SEMICOLON \n\n";
        outlog<<$1->getnameofsymbol()<<";\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+";","expression_statement");
    }
    ;

variable : ID {
        outlog<<"At line no: "<<line_num<<" variable : ID \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"variable");
    }
    | ID LTHIRD expression RTHIRD {
        outlog<<"At line no: "<<line_num<<" variable : ID LTHIRD expression RTHIRD \n\n";
        outlog<<$1->getnameofsymbol()<<"["<<$3->getnameofsymbol()<<"]\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+"["+$3->getnameofsymbol()+"]","variable");
    }
    ;

expression : logic_expression {
        outlog<<"At line no: "<<line_num<<" expression : logic_expression \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"expression");
    }
    | variable ASSIGNOP logic_expression {
        outlog<<"At line no: "<<line_num<<" expression : variable ASSIGNOP logic_expression \n\n";
        outlog<<$1->getnameofsymbol()<<"="<<$3->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+"="+$3->getnameofsymbol(),"expression");
    }
    ;

logic_expression : rel_expression {
        outlog<<"At line no: "<<line_num<<" logic_expression : rel_expression \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"logic_expression");
    }
    | rel_expression LOGICOP rel_expression {
        outlog<<"At line no: "<<line_num<<" logic_expression : rel_expression LOGICOP rel_expression \n\n";
        outlog<<$1->getnameofsymbol()<<$2->getnameofsymbol()<<$3->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+$2->getnameofsymbol()+$3->getnameofsymbol(),"logic_expression");
    }
    ;

rel_expression : simple_expression {
        outlog<<"At line no: "<<line_num<<" rel_expression : simple_expression \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"rel_expression");
    }
    | simple_expression RELOP simple_expression {
        outlog<<"At line no: "<<line_num<<" rel_expression : simple_expression RELOP simple_expression \n\n";
        outlog<<$1->getnameofsymbol()<<$2->getnameofsymbol()<<$3->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+$2->getnameofsymbol()+$3->getnameofsymbol(),"rel_expression");
    }
    ;

simple_expression : term {
        outlog<<"At line no: "<<line_num<<" simple_expression : term \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"simple_expression");
    }
    | simple_expression ADDOP term {
        outlog<<"At line no: "<<line_num<<" simple_expression : simple_expression ADDOP term \n\n";
        outlog<<$1->getnameofsymbol()<<$2->getnameofsymbol()<<$3->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+$2->getnameofsymbol()+$3->getnameofsymbol(),"simple_expression");
    }
    ;

term : unary_expression {
        outlog<<"At line no: "<<line_num<<" term : unary_expression \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"term");
    }
    | term MULOP unary_expression {
        outlog<<"At line no: "<<line_num<<" term : term MULOP unary_expression \n\n";
        outlog<<$1->getnameofsymbol()<<$2->getnameofsymbol()<<$3->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+$2->getnameofsymbol()+$3->getnameofsymbol(),"term");
    }
    ;

unary_expression : ADDOP unary_expression {
        outlog<<"At line no: "<<line_num<<" unary_expression : ADDOP unary_expression \n\n";
        outlog<<$1->getnameofsymbol()<<$2->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+$2->getnameofsymbol(),"unary_expression");
    }
    | NOT unary_expression {
        outlog<<"At line no: "<<line_num<<" unary_expression : NOT unary_expression \n\n";
        outlog<<"!"<<$2->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info("!"+$2->getnameofsymbol(),"unary_expression");
    }
    | factor_info {
        outlog<<"At line no: "<<line_num<<" unary_expression : factor \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"unary_expression");
    }
    ;

factor_info : factor {
        outlog<<"At line no: "<<line_num<<" factor_info : factor \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"factor_info");
    }
    ;

factor : variable {
        outlog<<"At line no: "<<line_num<<" factor : variable \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"factor");
    }
    | ID LPAREN argument_list RPAREN {
        outlog<<"At line no: "<<line_num<<" factor : ID LPAREN argument_list RPAREN \n\n";
        outlog<<$1->getnameofsymbol()<<"("<<$3->getnameofsymbol()<<")\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+"("+$3->getnameofsymbol()+")","factor");
    }
    | LPAREN expression RPAREN {
        outlog<<"At line no: "<<line_num<<" factor : LPAREN expression RPAREN \n\n";
        outlog<<"("<<$2->getnameofsymbol()<<")\n\n";
        $$ = new symbol_info("("+$2->getnameofsymbol()+")","factor");
    }
    | CONST_INT {
        outlog<<"At line no: "<<line_num<<" factor : CONST_INT \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"factor");
    }
    | CONST_FLOAT {
        outlog<<"At line no: "<<line_num<<" factor : CONST_FLOAT \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"factor");
    }
    | variable INCOP {
        outlog<<"At line no: "<<line_num<<" factor : variable INCOP \n\n";
        outlog<<$1->getnameofsymbol()<<"++\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+"++","factor");
    }
    | variable DECOP {
        outlog<<"At line no: "<<line_num<<" factor : variable DECOP \n\n";
        outlog<<$1->getnameofsymbol()<<"--\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+"--","factor");
    }
    ;

argument_list : arguments {
        outlog<<"At line no: "<<line_num<<" argument_list : arguments \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"argument_list");
    }
    ;

arguments : arguments COMMA logic_expression {
        outlog<<"At line no: "<<line_num<<" arguments : arguments COMMA logic_expression \n\n";
        outlog<<$1->getnameofsymbol()<<","<<$3->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol()+","+$3->getnameofsymbol(),"arguments");
    }
    | logic_expression {
        outlog<<"At line no: "<<line_num<<" arguments : logic_expression \n\n";
        outlog<<$1->getnameofsymbol()<<"\n\n";
        $$ = new symbol_info($1->getnameofsymbol(),"arguments");
    }
    ;
%%

int main(int c, char *v[])
{
    if(c != 2) 
    {
        cout<<"Provide input file"<<endl;
        return 0;
    }
    yyin = fopen(v[1], "r");
    outlog.open("22201770_23101188_log.txt", ios::trunc); // Opening log file properly named with both student IDs
    
    if(yyin == NULL)
    {
        cout<<"Couldn't open file"<<endl;
        return 0;
    }
    
    yyparse();
    
    // Print number of total lines at the end of the file
    outlog << "\nTotal lines: " << line_num << endl;
    
    outlog.close();
    fclose(yyin);
    
    return 0;
}