import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TabelaSimbolos {

    public enum TipoIngrediente {
        NUMERO("numero"),
        POCAO("pocao"),
        PERGAMINHO("pergaminho"),
        VERDADEIRO_FALSO("verdadeiroFalso");

        private final String nome;

        TipoIngrediente(String nome) {
            this.nome = nome;
        }

        public String getNome() {
            return nome;
        }

        public static TipoIngrediente fromString(String tipo) {
            for (TipoIngrediente t : values()) {
                if (t.nome.equals(tipo)) {
                    return t;
                }
            }
            throw new ErroSemantico("tipo desconhecido: " + tipo);
        }
    }

    public static class Parametro {
        public final TipoIngrediente tipo;
        public final String nome;

        public Parametro(TipoIngrediente tipo, String nome) {
            this.tipo = tipo;
            this.nome = nome;
        }
    }

    public static class AssinaturaFeitico {
        public final List<TipoIngrediente> parametros;

        public AssinaturaFeitico(List<TipoIngrediente> parametros) {
            this.parametros = parametros;
        }
    }

    private static class EntradaIngrediente {
        TipoIngrediente tipo;
        Object valor;

        EntradaIngrediente(TipoIngrediente tipo, Object valor) {
            this.tipo = tipo;
            this.valor = valor;
        }
    }

    private final Map<String, AssinaturaFeitico> feiticos = new HashMap<>();
    private final Deque<Map<String, EntradaIngrediente>> escopos = new ArrayDeque<>();

    public TabelaSimbolos() {
        novaEscopo();
    }

    public void novaEscopo() {
        escopos.push(new HashMap<>());
    }

    public void sairEscopo() {
        if (escopos.size() > 1) {
            escopos.pop();
        }
    }

    public void registrarAssinatura(String nome, List<Parametro> params) {
        if (feiticos.containsKey(nome)) {
            throw new ErroSemantico("feitico '" + nome + "' ja foi definido.");
        }
        List<TipoIngrediente> tipos = new ArrayList<>();
        if (params != null) {
            for (Parametro p : params) {
                tipos.add(p.tipo);
            }
        }
        feiticos.put(nome, new AssinaturaFeitico(tipos));
    }

    public void validarChamada(String nome, int numArgs) {
        AssinaturaFeitico assinatura = feiticos.get(nome);
        if (assinatura == null) {
            throw new ErroSemantico("feitico '" + nome + "' nao foi definido.");
        }
        if (assinatura.parametros.size() != numArgs) {
            throw new ErroSemantico("feitico '" + nome + "' esperava "
                    + assinatura.parametros.size() + " argumento(s), encontrado " + numArgs + ".");
        }
    }

    public void entrarFeitico(List<Parametro> params, List<Object> args) {
        novaEscopo();
        for (int i = 0; i < params.size(); i++) {
            Parametro p = params.get(i);
            Object valor = args.get(i);
            verificarTipo(p.tipo.getNome(), valor);
            Map<String, EntradaIngrediente> escopo = escopos.peek();
            escopo.put(p.nome, new EntradaIngrediente(p.tipo, normalizarValor(p.tipo, valor)));
        }
    }

    public void sairFeitico() {
        sairEscopo();
    }

    public void declararIngrediente(String nome, String tipoDecl, Object valor) {
        TipoIngrediente tipo = TipoIngrediente.fromString(tipoDecl);
        verificarTipo(tipoDecl, valor);
        Map<String, EntradaIngrediente> escopo = escopos.peek();
        if (escopo.containsKey(nome)) {
            throw new ErroSemantico("ingrediente '" + nome + "' ja foi declarado.");
        }
        escopo.put(nome, new EntradaIngrediente(tipo, normalizarValor(tipo, valor)));
    }

    public Object usarIngrediente(String nome) {
        EntradaIngrediente entrada = buscar(nome);
        if (entrada == null) {
            throw new ErroSemantico("ingrediente '" + nome + "' nao foi declarado.");
        }
        return entrada.valor;
    }

    public void atribuirIngrediente(String nome, Object valor) {
        EntradaIngrediente entrada = buscar(nome);
        if (entrada == null) {
            throw new ErroSemantico("ingrediente '" + nome + "' nao foi declarado.");
        }
        verificarTipo(entrada.tipo.getNome(), valor);
        entrada.valor = normalizarValor(entrada.tipo, valor);
    }

    public void verificarTipo(String tipoDecl, Object valor) {
        String encontrado = tipoDe(valor);
        if (!tiposCompativeis(tipoDecl, encontrado)) {
            throw new ErroSemantico("tipo invalido. Esperado " + tipoDecl + ", encontrado " + encontrado + ".");
        }
    }

    public void verificarCondicaoBooleana(Object valor, String contexto) {
        if (!(valor instanceof Boolean)) {
            throw new ErroSemantico("condicao de " + contexto + " deve retornar verdadeiro ou falso.");
        }
    }

    private EntradaIngrediente buscar(String nome) {
        for (Map<String, EntradaIngrediente> escopo : escopos) {
            EntradaIngrediente entrada = escopo.get(nome);
            if (entrada != null) {
                return entrada;
            }
        }
        return null;
    }

    private String tipoDe(Object valor) {
        if (valor instanceof Integer) {
            return "numero";
        }
        if (valor instanceof Double) {
            return "pocao";
        }
        if (valor instanceof String) {
            return "pergaminho";
        }
        if (valor instanceof Boolean) {
            return "verdadeiroFalso";
        }
        return "desconhecido";
    }

    private boolean tiposCompativeis(String esperado, String encontrado) {
        if (esperado.equals(encontrado)) {
            return true;
        }
        return "pocao".equals(esperado) && "numero".equals(encontrado);
    }

    private Object normalizarValor(TipoIngrediente tipo, Object valor) {
        if (tipo == TipoIngrediente.POCAO && valor instanceof Integer) {
            return ((Integer) valor).doubleValue();
        }
        return valor;
    }
}
