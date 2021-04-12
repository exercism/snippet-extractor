# This must happen above the env require below
if ENV["CAPTURE_CODE_COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

gem 'minitest'

require "minitest/autorun"
require 'minitest/pride'
require "mocha/minitest"
require 'pathname'

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp/output')
  SOLUTION_PATH = Pathname.new('/tmp')
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
Dir[File.join(".", "**/*.rb")].each { |f| require f unless f[/^\.\/test\//]}

class Minitest::Test
end
