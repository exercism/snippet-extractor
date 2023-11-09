require "test_helper"

class SnippetExtractor::Languages::WasmTest < Minitest::Test
  def test_full_example
    code = <<~CODE
      (module ;; in-line comment
        (func (export "score") (param $x f32) (param $y f32) (result i32)

          ;; Calculate the distance from the center
          (local $distance f32)
          (local.set $distance (f32.sqrt
            (f32.add
              (f32.mul (local.get $x) (local.get $x))
              (f32.mul (local.get $y) (local.get $y)))))
      
          ;; We're outside the outer circle, OR
          (if (f32.gt (local.get $distance) (f32.const 10.0)) (then
            (return (i32.const 0))
          ))
      
          ;; We're outside the middle circle, OR
          (if (f32.gt (local.get $distance) (f32.const 5.0)) (then
            (return (i32.const 1))
          ))
      
          ;; We're outside the inner circle, OR
          (if (f32.gt (local.get $distance) (f32.const 1.0)) (then
            (return (i32.const 5))
          ))
      
          ;; We've hit the bullseye
          (return (i32.const 10))
        )
      )      
    CODE

    expected = <<~CODE
      (module 
        (func (export "score") (param $x f32) (param $y f32) (result i32)

          (local $distance f32)
          (local.set $distance (f32.sqrt
            (f32.add
              (f32.mul (local.get $x) (local.get $x))
              (f32.mul (local.get $y) (local.get $y)))))
      
          (if (f32.gt (local.get $distance) (f32.const 10.0)) (then
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, 'wasm')
  end
end
