# Relatório — Compilador SpellLang (JFlex + JCup)

> Rascunho para conversão em PDF. Preencher com capturas de tela e trechos adicionais conforme a apresentação.

## 1. Introdução

Este trabalho implementa o front-end de um compilador para a linguagem **SpellLang**, uma linguagem fictícia com tema Harry Potter. O objetivo é demonstrar análise léxica, sintática e semântica utilizando **JFlex** (scanner) e **JCup** (parser), integrados por um programa Java (`Main.java`).

Ferramentas: JFlex 1.9.1, Java CUP 11b, Java JDK.

## 2. Análise Léxica

### 2.1 Tabela de tokens

| Categoria | Tokens |
|---|---|
| Keywords | `GRIMORIO`, `FEITICO`, `INGREDIENTE`, `NUMERO`, `POCAO`, `PERGAMINHO`, `VERDADEIRO_FALSO`, `SE_MAGICO`, `SENAO_MAGICO`, `ENQUANTO_MAGICO`, `REVELAR`, `VERDADEIRO`, `FALSO`, `MALFEITO_FEITO` |
| Literais | `NUMBER`, `DECIMAL`, `STRING` |
| Identificadores | `ID` |
| Operadores | `PLUS`, `MINUS`, `TIMES`, `DIVIDE`, `ASSIGN`, `EQ`, `NEQ`, `GT`, `LT`, `GTE`, `LTE` |
| Delimitadores | `SEMI`, `COMMA`, `LBRACE`, `RBRACE`, `LPAREN`, `RPAREN` |

### 2.2 Regras críticas

- `"malfeito feito"` reconhecido antes de `{ID}`
- Operadores compostos (`==`, `!=`, `>=`, `<=`) antes dos simples
- Decimais (`{DECIMAL}`) antes de inteiros (`{DIGIT}`)
- Comentários `//` e `/* */` ignorados
- Erro léxico: `Feitiço quebrado! Caractere invalido: X`

### 2.3 Trecho de `spelllang.flex`

Ver arquivo `spelllang.flex` — keywords temáticas, literais e delimitadores.

### 2.4 Exemplo de tokenização

Executar `./run.sh` e copiar a seção `=== Analise lexica ===` para o relatório.

## 3. Análise Sintática

### 3.1 Gramática principal

```
programa        → GRIMORIO ID { lista_feiticos }
lista_feiticos  → lista_feiticos feitico | feitico
feitico         → FEITICO ID ( lista_params_opt ) { comandos }
comandos        → comandos comando | ε
comando         → declaracao | atribuicao | condicional | repeticao | retorno | chamada | encerramento
declaracao      → INGREDIENTE tipo ID = expr ;
atribuicao      → ID = expr ;
condicional     → seMagico ( expr ) { comandos } senaoMagico { comandos }
repeticao       → enquantoMagico ( expr ) { comandos }
retorno         → revelar expr ;
chamada         → ID ( lista_args_opt ) ;
encerramento    → malfeito feito ;
tipo            → numero | pocao | pergaminho | verdadeiroFalso
expr            → expressões aritméticas, relacionais e unárias (UMINUS)
```

### 3.2 Precedência

- `UMINUS` (menor unário)
- `TIMES`, `DIVIDE`
- `PLUS`, `MINUS`
- Operadores relacionais

### 3.3 Comparação com `calc.cup`

| Aspecto | Calculadora | SpellLang |
|---|---|---|
| Entrada | Lista de expressões | Grimório com feitiços |
| Keywords | Nenhuma | Palavras temáticas |
| Estruturas | Apenas expr | if/while/declaração/chamada |

## 4. Análise Semântica

Implementada em `TabelaSimbolos.java` com cinco regras:

| Regra | Mensagem |
|---|---|
| Variável declarada antes do uso | `ingrediente 'X' nao foi declarado.` |
| Tipos compatíveis na declaração | `tipo invalido. Esperado numero, encontrado pergaminho.` |
| Feitiço existe antes da chamada | `feitico 'X' nao foi definido.` |
| Condição booleana | `condicao de seMagico deve retornar verdadeiro ou falso.` |
| Encerramento obrigatório | `feitico 'X' nao encerrou com 'malfeito feito'.` |

### 4.1 Programas inválidos para teste

Incluir capturas com programas que violam cada regra acima.

## 5. Integração (`Main.java`)

```
input.txt → scanner (JFlex) → tokens → parser (JCup) → análise sintática/semântica → saída
```

Executa `input.txt` por padrão (ou o arquivo passado como argumento).

## 6. Demonstração

Anexar log completo de `./demo.sh` ou `./run.sh` processando `input.txt`.

## 7. Conclusão

O projeto adapta o material base do professor (`calc.flex`, `calc.cup`, `Main.java`) para a SpellLang, adicionando keywords temáticas, estruturas de controle, análise semântica e mensagens de erro no estilo "Feitiço quebrado!". A estrutura JFlex + JCup + Main foi preservada, facilitando a comparação com o projeto original.

## Arquivos de entrega

- `spelllang.flex`, `spelllang.cup`
- `scanner.java`, `parser.java`, `sym.java` (gerados)
- `Main.java`, `TabelaSimbolos.java`, `Avaliador.java`, `ErroSemantico.java`
- `input.txt`, `README.md`, `run.sh`, `demo.sh`
- Este relatório (PDF)
