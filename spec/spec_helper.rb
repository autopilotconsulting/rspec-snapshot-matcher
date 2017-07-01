$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec_snapshot_matcher'
require 'rspec/matchers/fail_matchers'

RSpec.configure do |config|
  config.include RSpec::Matchers::FailMatchers
end
