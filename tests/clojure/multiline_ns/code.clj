;; Counting
(ns counting
  (:require [clojure.string :as str]
            [clojure.set :as set])
  (:import (java.util Date)))

(defn count-it [x]
  ; trailing comment
  (inc x))
