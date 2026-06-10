public class Avaliador {

    private Avaliador() {
    }

    public static Object aplicar(Object a, String op, Object b) {
        if (!(a instanceof Integer) || !(b instanceof Integer)) {
            throw new ErroSemantico("operacao invalida.");
        }

        int x = (Integer) a;
        int y = (Integer) b;
        switch (op) {
            case "+": return x + y;
            case "-": return x - y;
            case ">": return x > y;
            default: throw new ErroSemantico("operacao invalida.");
        }
    }
}
