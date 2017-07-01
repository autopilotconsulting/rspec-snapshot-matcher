require 'spec_helper'

describe RSpecSnapshotMatcher::Matchers::MatchSnapshot do
  let(:snapshots_directory) { File.join(%w[spec fixtures snapshots]) }
  let(:model) {
    {
      foo: 'foo',
      bar: ['b', 4, 'r']
    }
  }

  let(:matcher) { match_snapshot }

  before do
    FileUtils.rm_r(snapshots_directory) if File.exist?(snapshots_directory)
  end

  it 'is diffable' do
    expect(matcher).to be_diffable
  end

  it 'describes itself' do
    filename = File.join(%w[spec fixtures snapshots RSpecSnapshotMatcher__Matchers__MatchSnapshot
                            describes_itself.yml])
    expect(matcher.description).to eq "match snapshot #{filename}"
  end

  context 'with an existing snapshot' do
    let(:example_directory) {
      File.join(snapshots_directory, %w[RSpecSnapshotMatcher__Matchers__MatchSnapshot
                                        with_an_existing_snapshot])
    }

    def example_filename(example)
      File.join(example_directory, "#{example.description.gsub(/\W/, '_')}.yml")
    end

    before do |example|
      FileUtils.mkdir_p(example_directory)

      @filename = example_filename(example)
      File.open(@filename, 'w') do |io|
        io.write(model.to_yaml)
      end
    end

    describe '#matches?' do
      let(:example_directory) {
        File.join(snapshots_directory,
                  %w[RSpecSnapshotMatcher__Matchers__MatchSnapshot with_an_existing_snapshot
                     _matches_])
      }

      it 'creates a snapshot if one does not exist' do
        File.delete(@filename)
        expect(matcher.matches?(model)).to be true

        actual = YAML.load_file(@filename)
        expect(actual).to eq model
      end

      it 'returns false if it does not match the existing snapshot' do
        expect(matcher.matches?(foo: 'foo')).to be false
      end

      it 'returns true if it does match the existing snapshot' do
        expect(matcher.matches?(model)).to be true
      end
    end

    it 'provides snapshot, expected, and actual on #failure_message' do
      actual = { name: 'pippy' }
      matcher.matches?(actual)

      expected = [
        "expected: #{model.inspect}",
        "     got: #{actual.inspect}",
        '',
        "(using snapshot #{@filename})"
      ].join("\n")

      expect(matcher.failure_message).to eq expected
    end

    it 'provides snapshot, message, actual, and shows concern on #failure_message_when_negated' do
      matcher.matches?(model)

      expected = [
        'expected value not to match snapshot but it did',
        "snapshot: #{model.inspect}",
        '',
        "(using snapshot #{@filename})",
        '',
        'does negating this matcher really make sense?'
      ].join("\n")

      expect(matcher.failure_message_when_negated).to eq expected
    end
  end

  context 'when actually matching objects' do
    it 'should match hashes' do
      expect(model).to match_snapshot
      expect(model).to match_snapshot

      expect {
        expect(name: 'hatch', bar: ['b', 4]).to match_snapshot
      }.to fail_including(
        '-:bar => ["b", 4, "r"]',
        '-:foo => "foo"',
        '+:bar => ["b", 4]',
        '+:name => "hatch"'
      )
    end

    it 'should match arrays' do
      actual = ['h', 4, 7, 'c', 'h', 3, { letter: 'r' }]
      expect(actual).to match_snapshot
      expect(actual).to match_snapshot

      expect {
        expect(['h', 4, 7, 'p', 'h']).to match_snapshot
      }.to fail_including(
        'expected: ["h", 4, 7, "c", "h", 3, {:letter=>"r"}]',
        'got: ["h", 4, 7, "p", "h"]'
      )
    end

    it 'should match strings' do
      actual = [
        'this string is quite long',
        'it has several newlines',
        'and is a haiku'
      ].join("\n")

      expect(actual).to match_snapshot
      expect(actual).to match_snapshot

      other = [
        'this string is quite long',
        'but is not a haiku'
      ].join("\n")

      expect {
        expect(other).to match_snapshot
      }.to fail_including(
        '-it has several newlines',
        '-and is a haiku',
        '+but is not a haiku'
      )
    end

    it 'should match objects' do
      Kid = Struct.new(:name, :size)
      actual = Kid.new('pip', 'pretty small but getting bigger every day')

      expect(actual).to match_snapshot
      expect(actual).to match_snapshot

      expect {
        other_kid = Kid.new('hatch', 'totally small')
        expect(other_kid).to match_snapshot
      }.to fail_including(
        '-"#<struct Kid name=\"pip\", size=\"pretty small but getting bigger every day\">"',
        '+"#<struct Kid name=\"hatch\", size=\"totally small\">"'
      )
    end
  end
end
