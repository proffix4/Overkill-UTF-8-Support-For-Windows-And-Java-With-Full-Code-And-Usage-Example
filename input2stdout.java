import javax.swing.JOptionPane;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;

public class input2stdout{
  public static void main(String[] args) throws UnsupportedEncodingException{
    String s_input;
    
    s_input = JOptionPane.showInputDialog("Text:");                   //get input from user.
    s_input = (s_input instanceof java.lang.String) ? s_input : "";   //normalize to string (from null?).
    s_input = s_input.replaceAll("\\[\r\n]+$",     "")                //remove multi-line (Unix, shell, sh, bash  - '\' before end-of-line)
                     .replaceAll("\u005E[\r\n]+$", "")                //remove multi-line (Windows - rarly used   - '^' before end-of-line) - Unicode representation is used instead of just "\^[\r\n]+$" since Java seems to call it "unescape'able character" for some reason...
                     .replaceAll("[\r\n]+",        "")                //remove multi-line - normalize to one-line - generic.
                     ;
    s_input = new String(s_input.getBytes(), "UTF-8");                //store explicitly as UTF-8 string (mostly used for storing in DB..).

    final PrintStream printstream = new PrintStream(System.out, true, "UTF-8");
    printstream.print(s_input);

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