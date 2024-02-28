package example;

/**
* Multiline comment
*/

//Inline comment

/* Block comment */

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;
import java.util.stream.Collectors;

public class Solution {
  public static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
  public static void main(String[] args) throws Exception {
    var num = readInt();
    System.out.println(num);
  }
  private static int readInt() throws IOException {
    return Integer.parseInt(in.readLine());
  }
}
