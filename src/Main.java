import java.io.*;

public class Main {

    public static void main(String[] args) {
        try {
            String arquivo = args.length > 0 ? args[0] : "examples/input.txt";
            FileReader reader = new FileReader(arquivo);
            parser parserObj = new parser(new scanner(reader));
            parserObj.parse();
            reader.close();
        } catch (ErroSemantico e) {
            System.err.println(e.getMessage());
            System.exit(1);
        } catch (Exception e) {
            System.err.println("Feitico quebrado!");
            e.printStackTrace();
            System.exit(1);
        }
    }
}
