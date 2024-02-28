// Skipping imports
import * as example from "example.js";
import * as example from "example.js";

import { get_data, get_data2 } from "example.js";

function getJSON(url, callback) {
  let xhr = new XMLHttpRequest();
  xhr.onload = function () {
    callback(this.responseText);
  };

  /// Saying things over
  /// multiple lines of code

  /* Multiline comments */
  /**
   * Multiline comments 2
   *
   */

  xhr.open("GET", /*hi*/ url, true);
  xhr.send(); //Sending
} //:O
