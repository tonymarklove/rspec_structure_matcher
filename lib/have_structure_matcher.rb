require 'pp'

RSpec::Matchers.define :have_structure do |expected, opts|
  match do |actual|
    HaveStructureMatcher.match?(actual, expected)
  end

  failure_message do |actual|
    differ = RSpec::Support::Differ.new(color: RSpec::Matchers.configuration.color?)
    differ.diff(
      actual.pretty_inspect,
      HaveStructureMatcher.build_diff(actual, expected).pretty_inspect
    )
  end
end
