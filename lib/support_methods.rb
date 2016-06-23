module HaveStructureMatcher
  module Methods
    def optionally(optional_expected_value)
      ->(actual_value) { actual_value.nil? || HaveStructureMatcher.match?(actual_value, optional_expected_value) }
    end
  end

  def self.match?(actual, expected)
    actual == build_diff(actual, expected)
  end

  def self.build_diff(actual, expected)
    return expected unless actual.is_a?(Hash)

    keys = actual.keys | expected.keys

    keys.each_with_object({}) do |key, memo|
      if actual.key?(key) && expected.key?(key)
        actual_value = actual[key]
        expected_value = expected[key]

        if expected_value.is_a?(Hash)
          memo[key] = build_diff(actual_value, expected_value)
        elsif value_match?(actual_value, expected_value)
          memo[key] = actual_value
        else
          memo[key] = print_expected_value(expected_value)
        end
      elsif expected.key?(key)
        expected_value = expected[key]
        memo[key] = print_expected_value(expected_value)
      end
    end
  end

  def self.print_expected_value(expected_value)
    if expected_value.respond_to?(:call)
      "Proc [#{expected_value.source_location.join(':')}]"
    else
      expected_value
    end
  end

  def self.value_match?(actual_value, expected_value)
    if expected_value.is_a?(Regexp)
      actual_value =~ expected_value
    elsif expected_value.is_a?(Class)
      actual_value.is_a?(expected_value)
    elsif expected_value.respond_to?(:call)
      expected_value.call(actual_value)
    else
      actual_value == expected_value
    end
  end
end

RSpec.configure do |config|
  config.include HaveStructureMatcher::Methods
end
