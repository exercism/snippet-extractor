require 'parser/current'

Dir.glob('test/languages/*_test.rb').each do |f|
  p f
  track = File.basename(f, '_test.rb').tr('_', '-')
  file = File.read(f)
  ast = Parser::CurrentRuby.parse(file).to_sexp_array
  c = ast.find { |n| n.is_a?(Array) && n[0] == :class }

  beg = c.find { |n| n.is_a?(Array) && n[0] == :begin }
  test_methods = (beg || c).select { |n| n.is_a?(Array) && n[0] == :def }
  test_methods.each do |test_method|
    name = test_method[1].to_s.gsub(/test_|_example/, '')
    extension = File.extname(
      `jq -r '.files.solution[0]' ~/exercism/tracks/#{track}/exercises/practice/hello-world/.meta/config.json`.strip
    )

    code, expected = test_method.
      find { |n| n.is_a?(Array) && n[0] == :begin }.
      select { |n| n.is_a?(Array) && n[0] == :lvasgn }.
      map { |n| n[2].drop(1).map { |m| m[1] }.join }
    
    dir = "tests/#{track}/#{name}"
    `mkdir -p #{dir}`
    File.write("#{dir}/code#{extension}", code)
    File.write("#{dir}/expected_snippet#{extension}", expected)
  end
end
