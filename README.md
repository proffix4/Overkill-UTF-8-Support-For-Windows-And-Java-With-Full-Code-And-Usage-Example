<h1>Overkill UTF-8 Support For Windows And Java With Full Code And Usage Example</h1>

The <code>input2stdout.java</code> accepts an input from an inputbox, 
which is a more friendly way that reading from the console directly (also supports Copy/Paste).

The input is explicitly handled as UTF-8, 
and written back to the STDOUT (standard-output).

<hr/>

Windows-console will support extended Unicode presenting and inputing by <code>chcp 65001 2&gt;nul 1&gt;nul</code>.

Java will be pre-prepared for UTF-8 input (both from STDIN and/or files) due to various combinations of system global environment variables.

<hr/>

the <code>_compile.cmd</code> shows additional switches uses to make sure the compilation with <code>javac</code> is also explicitly awared of the usage of UTF-8.


<hr/>

It is best to use <code>UTF-8</code> (and not <code>UTF8</code> nor <code>utf8</code> nor <code>utf-8</code>) due to compatibility with Java7-based products.

<hr/>

You can learn how to generate a keystore and sign your own JAR files very easily with: https://gist.github.com/eladkarako/caa019c0ee5abff8e14ad26f44236c3a