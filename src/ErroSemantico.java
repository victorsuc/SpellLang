public class ErroSemantico extends RuntimeException {
    public ErroSemantico(String mensagem) {
        super("Feitiço quebrado! " + mensagem);
    }
}
