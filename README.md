# Compilador SpellLang

Front-end de compilador para a linguagem **SpellLang** (tema Harry Potter), usando **JFlex** + **JCup**.

## Pré-requisitos

- Java JDK 8 ou superior
- JARs em `lib/`: `jflex-full-1.9.1.jar`, `java-cup-11b.jar`, `java-cup-11b-runtime.jar`

## Executar

```bash
./run.sh
```

Ou com outro arquivo:

```bash
./run.sh meu_programa.txt
```

## Estrutura

| Arquivo | Descrição |
|---|---|
| `spelllang.flex` | Análise léxica (JFlex) |
| `spelllang.cup` | Gramática e ações semânticas (JCup) |
| `Main.java` | Ponto de entrada |
| `TabelaSimbolos.java` | Análise semântica |
| `Avaliador.java` | Avaliação de expressões |
| `input.txt` | Programa de exemplo |

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
