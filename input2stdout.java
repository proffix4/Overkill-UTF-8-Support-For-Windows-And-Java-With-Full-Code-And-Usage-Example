import javax.swing.JOptionPane;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;

public class input2stdout{
  public static void main(String[] args) throws UnsupportedEncodingException{
    final String s = new String(JOptionPane.showInputDialog("Text:").getBytes(), "UTF-8");
    final PrintStream printstream = new PrintStream(System.out, true, "UTF-8");
    printstream.print(s);

    Thread.yield();
    System.exit(0);
  }
}


/*
* https://docs.oracle.com/javase/8/docs/technotes/guides/intl/encoding.doc.html
* https://docs.oracle.com/javase/7/docs/api/java/io/PrintStream.html
* https://docs.oracle.com/javase/7/docs/api/java/nio/charset/Charset.html - j7 supports UTF-8 and not UTF8.
* https://docs.oracle.com/javase/tutorial/i18n/text/string.html
* https://stackoverflow.com/questions/10933620/display-special-characters-using-system-out-println
* https://docs.oracle.com/javase/tutorial/deployment/jar/appman.html
* https://www.geeksforgeeks.org/java-concurrency-yield-sleep-and-join-methods/
* https://github.com/macagua/example.java.helloworld
* https://stackoverflow.com/questions/3747155/why-am-i-getting-must-be-caught-or-declared-to-be-thrown-on-my-program  ---- handling the exception due to manipulating streams directly (can be avoided by using System.out.print and implicit encoding).
* https://docs.oracle.com/javase/7/docs/api/java/io/UnsupportedEncodingException.html
*/