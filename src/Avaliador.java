public class Avaliador {

    private Avaliador() {
    }

    public static Object aplicar(Object a, String op, Object b) {
        if (a instanceof Integer && b instanceof Integer) {
            int x = (Integer) a;
            int y = (Integer) b;
            switch (op) {
                case "+": return x + y;
                case "-": return x - y;
                case "*": return x * y;
                case "/": return x / y;
                case "==": return x == y;
                case "!=": return x != y;
                case ">": return x > y;
                case "<": return x < y;
                case ">=": return x >= y;
                case "<=": return x <= y;
            }
        }
        if (a instanceof Double || b instanceof Double) {
            double x = toDouble(a);
            double y = toDouble(b);
            switch (op) {
                case "+": return x + y;
                case "-": return x - y;
                case "*": return x * y;
                case "/": return x / y;
                case "==": return x == y;
                case "!=": return x != y;
                case ">": return x > y;
                case "<": return x < y;
                case ">=": return x >= y;
                case "<=": return x <= y;
            }
        }
        if ("==".equals(op)) {
            return a.equals(b);
        }
        if ("!=".equals(op)) {
            return !a.equals(b);
        }
        throw new ErroSemantico("operacao invalida.");
    }

    private static double toDouble(Object value) {
        if (value instanceof Double) {
            return (Double) value;
        }
        if (value instanceof Integer) {
            return ((Integer) value).doubleValue();
        }
        throw new ErroSemantico("valor numerico invalido.");
    }
}
