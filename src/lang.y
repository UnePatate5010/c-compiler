%{

#include "Table_des_symboles.h"

#include <stdio.h>
#include <stdlib.h>

#define MAX_ARG 10
#define MAX_FCT 10
  
extern int yylex();
extern int yyparse();

void yyerror (char* s) {
  printf ("%s\n",s);
  exit(0);
  }
		
 int depth=0; // block depth
 int fonction_offset = 0;
 int fonction_compteur = 1;
 
 int tab_fct[MAX_FCT][MAX_ARG+1]; //le nombre d'argument de chaque fonction est stocké en position [x][0]
%}

%union { 
  struct ATTRIBUTE * symbol_value;
  char * string_value;
  int int_value;
  float float_value;
  int type_value;
  int label_value;
  int offset_value;
}

%token <int_value> NUM
%token <float_value> DEC


%token INT FLOAT VOID

%token <string_value> ID
%token AO AF PO PF PV VIR
%token RETURN  EQ
%token <label_value> IF ELSE WHILE

%token <label_value> AND OR NOT DIFF EQUAL SUP INF
%token PLUS MOINS STAR DIV
%token DOT ARR

%nonassoc IFX
%left OR                       // higher priority on ||
%left AND                      // higher priority on &&
%left DIFF EQUAL SUP INF       // higher priority on comparison
%left PLUS MOINS               // higher priority on + - 
%left STAR DIV                 // higher priority on * /
%left DOT ARR                  // higher priority on . and -> 
%nonassoc UNA                  // highest priority on unary operator
%nonassoc ELSE


%{
char * type2string (int c) {
  switch (c)
    {
    case INT:
      return("int");
    case FLOAT:
      return("float");
    case VOID:
      return("void");
    default:
      return("type error");
    }  
};


void print_calc(char * op, int one, int three) {
  if (one == INT && three == INT) {
    printf("%sI\n", op);
    }
  else if (one == FLOAT && three == FLOAT) {
    printf("%sF\n", op);
    }
  else if (one == FLOAT && three == INT) {
    printf("I2F\n%sF\n", op);
    }
  else if (one == INT && three == FLOAT) {
    printf("I2F2\n%sF\n", op);  
  }
  else {
    printf("error print calc\n");
    printf("type 1 : %d \ttype 2 : %d\n", one, three);
  }
}



int makeIf ()
{
  static int n = 0;
  return n++;
}

int makeWhile ()
{
  static int n = 0;
  return n++;
}


void load_var(int dollar_zero, char * x, int offset)
{
  attribute r;
  if (dollar_zero == FLOAT) {
    r = makeSymbol(FLOAT, offset, depth);
    set_symbol_value(x, r);
    printf("LOADF(0.0)\n");
  }
  else if (dollar_zero == INT) {
    r = makeSymbol(INT, offset, depth);
    set_symbol_value(x, r);
    printf("LOADI(0)\n");
  }
  else (printf("%d :\t %s\n", dollar_zero, type2string(dollar_zero)));
}

void print_bp(int relative_depth) {
  int i = relative_depth;
  while (i > 1) {
    printf("stack[");
    i--;
  }
  printf("bp");
  while (relative_depth > 1) {
    printf("]");
    relative_depth--;
  }
}


void store_var(attribute r) {
  if (r->depth == 0) 
    printf("STOREP(%d)\n", r->offset);
  else {
    int relative_depth = depth - r->depth;
    printf("STOREP(");
    print_bp(relative_depth+1);
    printf(" + %d)\n", r->offset);
  }
}

int load_var_aff(attribute r) {
  if (r->offset < 0)
    printf("LOADP(bp + %d)\n",r->offset);
  else if (r->depth == 0)
    printf("LOADP(%d)\n", r->offset);
  else {
    int relative_depth = depth - r->depth;
    printf("LOADP(");
    print_bp(relative_depth+1);
    printf(" + %d)\n", r->offset);
  }
    if (r->type == FLOAT) {
    return FLOAT;
    }
    else if (r->type == INT) {
    return INT;
    }
}


  %}




%start prog  

// liste de tous les non terminaux dont vous voulez manipuler l'attribut
%type <type_value> type exp  typename
%type <string_value> fun_head

 /* Attention, la rêgle de calcul par défaut $$=$1 
    peut créer des demandes/erreurs de type d'attribut */

%%

 // O. Déclaration globale

prog : glob_decl_list              {}

glob_decl_list : glob_decl_list fun {}
| glob_decl_list decl PV       {$<int_value>$ = $<int_value>2;}
|                              {$<int_value>$ = 0;} // empty glob_decl_list shall be forbidden, but usefull for offset computation

// I. Functions

fun : type fun_head fun_body   {}
;

fun_head : ID PO PF            {
  // Pas de déclaration de fonction à l'intérieur de fonctions !
  if (depth>0) yyerror("Function must be declared at top level~!\n");
  printf("\npcode_%s()", $1);
  }

| ID PO params PF              {
   // Pas de déclaration de fonction à l'intérieur de fonctions !
  if (depth>0) yyerror("Function must be declared at top level~!\n");
  printf("\npcode_%s()", $1);
  attribute r = makeSymbol($<int_value>0, fonction_offset, 0);
  fonction_offset++;
  set_symbol_value($1, r);
  fonction_compteur = 1;
  }
;

params: type ID vir params     {$<int_value>$ = $<int_value>4 - 1;
                                attribute r = makeSymbol($1, $<int_value>$, depth);
                                set_symbol_value($2, r);
                                tab_fct[fonction_offset][0]++;
                                tab_fct[fonction_offset][fonction_compteur] = $1;
                                fonction_compteur++;} // récursion droite pour numéroter les paramètres du dernier au premier
| type ID                      {$<int_value>$ = -1;
                                attribute r = makeSymbol($1, $<int_value>$, depth);
                                set_symbol_value($2, r);
                                tab_fct[fonction_offset][0] = 1;
                                tab_fct[fonction_offset][fonction_compteur] = $1;
                                fonction_compteur++;}


vir : VIR                      {}
;

fun_body : fao block faf       {}
;

fao : AO                       {depth = depth + 1;
                                printf(" {\n");
                                $<int_value>$ = 0;}
;
faf : AF                       {depth = depth - 1;
                                printf("}\n");}
;


// II. Block
block:
decl_list inst_list            {$<int_value>$ = $<int_value>0;}
;

// III. Declarations

decl_list : decl_list decl PV   {$<int_value>$ = $<int_value>2;} 
|                               {$<int_value>$ = 1;}
;

decl: var_decl                  {$<int_value>$ = $<int_value>1;}
;

var_decl : type vlist          {$<int_value>$ = $<int_value>2;}
;

vlist: vlist vir ID            {$<int_value>$ = $<int_value>1;
                                load_var(($<int_value>0), $3, $<int_value>$);
                                $<int_value>$++;} // récursion gauche pour traiter les variables déclararées de gauche à droite
| ID                           {$<int_value>$ = $<int_value>-1;
                                load_var(($<int_value>0), $1, $<int_value>$);
                                $<int_value>$++;}
;

type
: typename                     {}
;

typename
: INT                          {$$=INT;}
| FLOAT                        {$$=FLOAT;}
| VOID                         {$$=VOID;}
;

// IV. Intructions

inst_list: inst_list inst   {} 
| inst                      {}
;

pv : PV                       {}
;
 
inst:
ao block af                   {}
| aff pv                      {}
| ret pv                      {}
| cond                        {}
| loop                        {}
| pv                          {}
;

// Accolades explicites pour gerer l'entrée et la sortie d'un sous-bloc

ao : AO                       {depth = depth + 1;
                               printf("SAVEBP\n");}
;

af : AF                       {depth = depth - 1;
                               printf("RESTOREBP\n");
                               //clear_symbol_value(depth);
                               }
;


// IV.1 Affectations

aff : ID EQ exp               {attribute r = get_symbol_value($1);
                               store_var(r);}
;


// IV.2 Return
ret : RETURN exp              {printf("return;\n");}
| RETURN PO PF                {printf("return();\n");}
;

// IV.3. Conditionelles
//           N.B. ces rêgles génèrent un conflit déclage reduction
//           qui est résolu comme on le souhaite par un décalage (shift)
//           avec ELSE en entrée (voir y.output)

cond :
if bool_cond inst  elsop       {}
;

elsop : else inst              {printf("end_%d:\n", $<int_value>-2);}
|                  %prec IFX   {} // juste un "truc" pour éviter le message de conflit shift / reduce
;

bool_cond : PO exp PF         {printf("IFN(False_%d)\n", $<int_value>0);}
;

if : IF                       {$<int_value>$ = makeIf();}
;

else : ELSE                   {printf("GOTO(End_%d)\n", $<int_value>-2); 
                               printf("False_%d:\n", $<int_value>-2);}
;

// IV.4. Iterations

loop : while while_cond inst  {printf("GOTO(StartLoop_%d)\n", $<int_value>$); 
                               printf("EndLoop_%d:\n", $<int_value>$);}
;

while_cond : PO exp PF        {printf("IFN(EndLoop_%d)\n", $<int_value>0);}

while : WHILE                 {$<int_value>$ = makeWhile();
                               printf("StartLoop_%d:\n", $<int_value>$); }
;


// V. Expressions

exp
// V.1 Exp. arithmetiques
: MOINS exp %prec UNA         {}
         // -x + y lue comme (- x) + y  et pas - (x + y)
| exp PLUS exp                {print_calc("ADD", $1, $3);}
| exp MOINS exp               {print_calc("SUB", $1, $3);}
| exp STAR exp                {print_calc("MULT", $1, $3);}
| exp DIV exp                 {print_calc("DIV", $1, $3);}
| PO exp PF                   {}
| ID                          {attribute r = get_symbol_value($1);
                               $$ = load_var_aff(r);}
| app                         {}
| NUM                         {printf("LOADI(%d)\n", $1); $$=INT;}
| DEC                         {printf("LOADF(%f)\n", $1); $$=FLOAT;}


// V.2. Booléens

| NOT exp %prec UNA           {}
| exp INF exp                 {print_calc("LT", $1, $3);}
| exp SUP exp                 {print_calc("GT", $1, $3);}
| exp EQUAL exp               {print_calc("EQ", $1, $3);}
| exp DIFF exp                {print_calc("NEQ", $1, $3);}
| exp AND exp                 {printf("AND\n");}
| exp OR exp                  {printf("OR\n");}

;

// V.3 Applications de fonctions


app : fid PO args PF          {printf("SAVEBP\n");
                               printf("CALL(pcode_%s)\n", $<string_value>1);
                               printf("RESTOREBP\n");
                               printf("ENDCALL(%d)\n", $<int_value>3);
                               attribute r = get_symbol_value($<string_value>1);
                               $<int_value>$ = r->type;}
;

fid : ID                      {$<string_value>$ = $1;}

args :  arglist               {$<int_value>$ = $<int_value>1;}
|                             {$<int_value>$ = 0;}
;

arglist : arglist VIR exp     {$<int_value>$ = $<int_value>1 + 1;
                               attribute r = get_symbol_value($<string_value>-1);
                               if (tab_fct[r->offset][fonction_compteur] == FLOAT && $3 == INT) {
                                printf("I2F\n");
                               }
                               fonction_compteur--;
                               } // récursion gauche pour empiler les arguements de la fonction de gauche à droite
| exp                         {$<int_value>$ = 1;
                               attribute r = get_symbol_value($<string_value>-1);
                               fonction_compteur = tab_fct[r->offset][0];
                               if (tab_fct[r->offset][fonction_compteur] == FLOAT && $1 == INT) {
                                printf("I2F\n");
                               }
                               fonction_compteur--;
                               }
;



%% 
int main () {

  /* Ici on peut ouvrir le fichier source, avec les messages 
     d'erreur usuel si besoin, et rediriger l'entrée standard 
     sur ce fichier pour lancer dessus la compilation.
   */

char * header=
"// PCode Header\n\
#include \"PCode.h\"\n\
\n\
int main() {\n\
pcode_main();\n\
return stack[sp-1].int_value;\n\
}\n";  

 printf("%s\n",header); // ouput header
  
return yyparse ();
 
 
} 

