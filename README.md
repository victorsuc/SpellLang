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
./run.sh examples/meu_programa.txt
```

## Estrutura

```
CompiladorFrontEnd/
├── src/              Código Java (Main, análise semântica)
├── grammar/          Especificações JFlex e JCup
├── examples/         Programas de exemplo
├── scripts/          Scripts de build e execução
├── build/            Artefatos gerados e compilados (ignorado pelo git)
├── lib/              Dependências (JFlex, JCup)
└── docs/             Documentação adicional
```

| Pasta / arquivo | Descrição |
|---|---|
| `grammar/spelllang.flex` | Análise léxica (JFlex) |
| `grammar/spelllang.cup` | Gramática e ações semânticas (JCup) |
| `src/Main.java` | Ponto de entrada |
| `src/TabelaSimbolos.java` | Análise semântica |
| `src/Avaliador.java` | Avaliação de expressões |
| `examples/input.txt` | Programa de exemplo |

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
