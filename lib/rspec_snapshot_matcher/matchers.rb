require 'rspec'
require 'rspec_snapshot_matcher/matchers/snapshot_matcher.rb'

RSpec.configure do |config|
  config.include(RSpecSnapshotMatcher::Matchers)

  config.around(:all) do |example|
    Thread.current[:rspec_snapshot_matcher_example] = example
    example.run
    Thread.current[:rspec_snapshot_matcher_example] = nil
  end
end
