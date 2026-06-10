# Compilador SpellLang

Front-end de compilador para a linguagem **SpellLang** (tema Harry Potter), demonstrando análise léxica, sintática e semântica com **JFlex** + **JCup** + Java.

**Ferramentas:** JFlex 1.9.1, Java CUP 11b, Java JDK 8+.

## Apresentação em vídeo

Demonstração do compilador em funcionamento: [Gravação de Tela (Google Drive)](https://drive.google.com/file/d/19tPWMDHEU1FG6JuDi7PYRiDZGkWnirXo/view?usp=drive_link).

## Pré-requisitos

- Java JDK 8 ou superior
- JARs em `lib/`: `jflex-full-1.9.1.jar`, `java-cup-11b.jar`, `java-cup-11b-runtime.jar`

## Executar

```bash
./scripts/run.sh
```

Ou com outro arquivo:

```bash
./scripts/run.sh examples/meu_programa.txt
```

## Estrutura

```
SpellLang/
├── src/              Main, TabelaSimbolos, Avaliador
├── grammar/          spelllang.flex, spelllang.cup
├── examples/         Programas de exemplo
├── scripts/          Build e execução (run.sh, cleanup.sh)
├── build/            Artefatos gerados (ignorado pelo git)
├── lib/              JFlex e JCup
└── docs/             Documentação adicional
```

| Arquivo | Descrição |
|---|---|
| `grammar/spelllang.flex` | Análise léxica (JFlex) |
| `grammar/spelllang.cup` | Gramática e ações semânticas (JCup) |
| `src/Main.java` | Ponto de entrada |
| `src/TabelaSimbolos.java` | Análise semântica |
| `src/Avaliador.java` | Avaliação de expressões |
| `examples/input.txt` | Programa de exemplo |

## Análise léxica

### Tokens

| Categoria | Tokens |
|---|---|
| Keywords | `GRIMORIO`, `FEITICO`, `INGREDIENTE`, `NUMERO`, `PERGAMINHO`, `VERDADEIRO_FALSO`, `SE_MAGICO`, `SENAO_MAGICO`, `ENQUANTO_MAGICO`, `REVELAR`, `VERDADEIRO`, `FALSO`, `MALFEITO_FEITO` |
| Literais | `NUMBER`, `DECIMAL`, `STRING` |
| Identificadores | `ID` |
| Operadores | `PLUS`, `MINUS`, `TIMES`, `DIVIDE`, `ASSIGN`, `EQ`, `NEQ`, `GT`, `LT`, `GTE`, `LTE` |
| Delimitadores | `SEMI`, `COMMA`, `LBRACE`, `RBRACE`, `LPAREN`, `RPAREN` |

### Regras críticas

- `"malfeito feito"` reconhecido antes de `{ID}`
- Operadores compostos (`==`, `!=`, `>=`, `<=`) antes dos simples
- Decimais (`{DECIMAL}`) antes de inteiros (`{DIGIT}`)
- Comentários `//` e `/* */` ignorados
- Erro léxico: `Feitiço quebrado! Caractere invalido: X`

## Análise sintática

### Gramática principal

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
tipo            → numero | pergaminho | verdadeiroFalso
expr            → aritméticas, relacionais e unárias (UMINUS)
```

### Precedência

`UMINUS` → `TIMES`/`DIVIDE` → `PLUS`/`MINUS` → operadores relacionais.

Em relação à calculadora base (`calc.flex`/`calc.cup`): SpellLang adiciona keywords temáticas, estruturas de controle (if/while), declarações e chamadas de feitiço.

## Análise semântica

Implementada em `TabelaSimbolos.java`:

| Regra | Mensagem |
|---|---|
| Variável declarada antes do uso | `ingrediente 'X' nao foi declarado.` |
| Tipos compatíveis na declaração | `tipo invalido. Esperado numero, encontrado pergaminho.` |
| Feitiço existe antes da chamada | `feitico 'X' nao foi definido.` |
| Condição booleana | `condicao de seMagico deve retornar verdadeiro ou falso.` |
| Encerramento obrigatório | `feitico 'X' nao encerrou com 'malfeito feito'.` |

## Integração

```
examples/input.txt → scanner (JFlex) → tokens → parser (JCup) → análise sintática/semântica → saída
```

## Exemplo de saída

```
grimorio QuadribolHogwarts
ingrediente rodada inicializado = 10
ingrediente pomoDeOuro inicializado = false
chamando feitico lumos
revelar: "Lumos!"
enquantoMagico: rodada 1
revelar: 10
...
malfeito feito.
```

## Conclusão

O projeto adapta o material base do professor (`calc.flex`, `calc.cup`, `Main.java`) para a SpellLang, preservando a estrutura JFlex + JCup + Main e adicionando keywords temáticas, estruturas de controle, análise semântica e mensagens de erro no estilo "Feitiço quebrado!".
