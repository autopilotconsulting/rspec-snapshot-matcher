require 'yaml'

module RSpecSnapshotMatcher
  module Matchers
    class MatchSnapshot
      attr_reader :actual, :expected

      def matches?(actual)
        @actual = actual

        if File.exist?(snapshot_filename)
          @expected = YAML.load_file(snapshot_filename)
          return @actual == @expected
        else
          save_snapshot(actual, snapshot_filename)
          return true
        end
      end

      def description
        "match snapshot #{snapshot_filename}"
      end

      def failure_message
        [
          "expected: #{expected.inspect}",
          "     got: #{actual.inspect}",
          '',
          "(using snapshot #{snapshot_filename})"
        ].join("\n")
      end

      def failure_message_when_negated
        [
          'expected value not to match snapshot but it did',
          "snapshot: #{actual.inspect}",
          '',
          "(using snapshot #{snapshot_filename})",
          '',
          'does negating this matcher really make sense?'
        ].join("\n")
      end

      def diffable?
        true
      end

      private

      def save_snapshot(actual, filename)
        snapshot_directory = File.dirname(filename)
        FileUtils.mkdir_p(snapshot_directory)

        File.open(snapshot_filename, 'w') do |io|
          io.write(actual.to_yaml)
        end
      end

      def snapshot_filename
        @snapshot_filename ||= begin
          parts = [
            'spec',
            'fixtures',
            'snapshots',
            *example_group_path,
            example.description
          ].map { |part| part.gsub(/\W/, '_') }

          "#{File.join(*parts)}.yml"
        end
      end

      def example_group_path
        return [] unless example.example_group
        example.example_group.parent_groups.reverse.map(&:description)
      end

      def example
        Thread.current[:rspec_snapshot_matcher_example]
      end
    end

    def match_snapshot(*args)
      MatchSnapshot.new(*args)
    end
  end
end
