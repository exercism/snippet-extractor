(def alphabet (map char (range (int \A) (inc (int \Z)))))

(defn- row
  "Builds one row of the diamond."
  [letter width]
  (let [idx (.indexOf alphabet letter)]
    (str/join (repeat idx \space))))

(defn diamond [letter]
  (let [rows (map #(row % 5) alphabet)]
