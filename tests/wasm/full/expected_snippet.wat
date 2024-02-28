(module 
  (func (export "score") (param $x f32) (param $y f32) (result i32)

    (local $distance f32)
    (local.set $distance (f32.sqrt
      (f32.add
        (f32.mul (local.get $x) (local.get $x))
        (f32.mul (local.get $y) (local.get $y)))))

    (if (f32.gt (local.get $distance) (f32.const 10.0)) (then
