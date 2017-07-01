require 'spec_helper'

describe RSpecSnapshotMatcher do
  it 'has a version number' do
    version = described_class::VERSION
    expect(version).not_to be nil
  end
end
