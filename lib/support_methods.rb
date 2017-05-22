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
    if actual.is_a?(Array) && expected.is_a?(Array)
      build_array_diff(actual, expected)
    elsif actual.is_a?(Hash) && expected.is_a?(Hash)
      build_hash_diff(actual, expected)
    elsif actual.is_a?(Hash)
      expected
    elsif value_match?(actual, expected)
      actual
    else
      expected
    end
  end

  def self.build_hash_diff(actual, expected)
    keys = actual.keys | expected.keys

    keys.each_with_object({}) do |key, memo|
      if actual.key?(key) && expected.key?(key)
        actual_value = actual[key]
        expected_value = expected[key]

        if expected_value.is_a?(Hash)
          memo[key] = build_diff(actual_value, expected_value)
        elsif expected_value.is_a?(Array)
          memo[key] = build_array_diff(actual_value, expected_value)
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

  def self.build_array_diff(actual_value, expected_value)
    if expected_value.length == 1 && actual_value.is_a?(Array)
      actual_value.map { |a| build_diff(a, expected_value[0]) }
    else
      expected_value.zip(actual_value).map { |(e,a)| build_diff(a, e) }
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
