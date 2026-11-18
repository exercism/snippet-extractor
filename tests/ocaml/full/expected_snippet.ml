type field =
  | Mine
  | Empty of int (* Empty spot, number is adjacent mines *)

type board = { fields: field array array; width: int; height: int }

let neighbours board x y =
  List.filter_map
    [ (-1, -1); (0, -1); (1, -1); (-1, 0); (1, 0); (-1, 1); (0, 1); (1, 1) ]
    ~f:(fun (dx, dy) ->
