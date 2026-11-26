(def alphabet (map char (range (int \A) (inc (int \Z)))))

;;; Helpers

(defn- row
  "Builds one row of the diamond."
  [letter width]
  (let [idx (.indexOf alphabet letter)] ; position in the alphabet
    (str/join (repeat idx \space))))

(defn diamond [letter]
  (let [rows (map #(row % 5) alphabet)]
    (str/join ";" rows)))
