import java.net.URL;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;

public class Main {
    /**
     *   Connects to github and reads the front page.
     *   This test should not throw
     */
    public static void main(String[] args) throws IOException {
        URL url = new URL("https://github.com");
        InputStream stream = url.openStream();
        BufferedReader reader =
            new BufferedReader(new InputStreamReader(stream));
        while (reader.readLine()!=null){
        }

    }
}