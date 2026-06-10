import java_cup.runtime.*;

%%

%class scanner
%unicode
%cup
%line
%column

WHITESPACE = [ \t\r\n]+
LETRA      = [a-zA-Z_]
ID         = {LETRA}([a-zA-Z0-9_])*
DIGIT      = [0-9]+
DECIMAL    = {DIGIT}+"."{DIGIT}+
STRING     = \"([^\\\"]|\\.)*\"

%%

<YYINITIAL> {

    {WHITESPACE}      { /* ignorar */ }

    "grimorio"        { return new Symbol(sym.GRIMORIO, yyline + 1, yycolumn + 1); }
    "feitico"         { return new Symbol(sym.FEITICO, yyline + 1, yycolumn + 1); }
    "ingrediente"     { return new Symbol(sym.INGREDIENTE, yyline + 1, yycolumn + 1); }
    "numero"          { return new Symbol(sym.NUMERO, yyline + 1, yycolumn + 1); }
    "pocao"           { return new Symbol(sym.POCAO, yyline + 1, yycolumn + 1); }
    "pergaminho"      { return new Symbol(sym.PERGAMINHO, yyline + 1, yycolumn + 1); }
    "verdadeiroFalso" { return new Symbol(sym.VERDADEIRO_FALSO, yyline + 1, yycolumn + 1); }
    "seMagico"        { return new Symbol(sym.SE_MAGICO, yyline + 1, yycolumn + 1); }
    "senaoMagico"     { return new Symbol(sym.SENAO_MAGICO, yyline + 1, yycolumn + 1); }
    "enquantoMagico"  { return new Symbol(sym.ENQUANTO_MAGICO, yyline + 1, yycolumn + 1); }
    "revelar"         { return new Symbol(sym.REVELAR, yyline + 1, yycolumn + 1); }
    "verdadeiro"      { return new Symbol(sym.VERDADEIRO, yyline + 1, yycolumn + 1); }
    "falso"           { return new Symbol(sym.FALSO, yyline + 1, yycolumn + 1); }
    "malfeito feito"  { return new Symbol(sym.MALFEITO_FEITO, yyline + 1, yycolumn + 1); }

    "=="              { return new Symbol(sym.EQ, yyline + 1, yycolumn + 1); }
    "!="              { return new Symbol(sym.NEQ, yyline + 1, yycolumn + 1); }
    ">="              { return new Symbol(sym.GTE, yyline + 1, yycolumn + 1); }
    "<="              { return new Symbol(sym.LTE, yyline + 1, yycolumn + 1); }
    ">"               { return new Symbol(sym.GT, yyline + 1, yycolumn + 1); }
    "<"               { return new Symbol(sym.LT, yyline + 1, yycolumn + 1); }

    "="               { return new Symbol(sym.ASSIGN, yyline + 1, yycolumn + 1); }
    "+"               { return new Symbol(sym.PLUS, yyline + 1, yycolumn + 1); }
    "-"               { return new Symbol(sym.MINUS, yyline + 1, yycolumn + 1); }
    "*"               { return new Symbol(sym.TIMES, yyline + 1, yycolumn + 1); }
    "/"               { return new Symbol(sym.DIVIDE, yyline + 1, yycolumn + 1); }

    ";"               { return new Symbol(sym.SEMI, yyline + 1, yycolumn + 1); }
    ","               { return new Symbol(sym.COMMA, yyline + 1, yycolumn + 1); }
    "{"               { return new Symbol(sym.LBRACE, yyline + 1, yycolumn + 1); }
    "}"               { return new Symbol(sym.RBRACE, yyline + 1, yycolumn + 1); }
    "("               { return new Symbol(sym.LPAREN, yyline + 1, yycolumn + 1); }
    ")"               { return new Symbol(sym.RPAREN, yyline + 1, yycolumn + 1); }

    {DECIMAL}         { return new Symbol(sym.DECIMAL, yyline + 1, yycolumn + 1, Double.parseDouble(yytext())); }
    {DIGIT}           { return new Symbol(sym.NUMBER, yyline + 1, yycolumn + 1, Integer.parseInt(yytext())); }
    {STRING}          {
                          String raw = yytext();
                          String valor = raw.substring(1, raw.length() - 1);
                          return new Symbol(sym.STRING, yyline + 1, yycolumn + 1, valor);
                      }
    {ID}              { return new Symbol(sym.ID, yyline + 1, yycolumn + 1, yytext()); }

    "//".*            { /* comentario de linha */ }
    "/*" ([^*] | "*" [^/])* "*"+ "/" { /* comentario multilinha */ }

    .                 { System.err.println("Feitiço quebrado! Caractere invalido: " + yytext()); }
}
