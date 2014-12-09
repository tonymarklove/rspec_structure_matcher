RSpec::Matchers.define :have_structure do |expected, opts|
  match do |actual|
    invalid_items(actual, expected).empty?
  end

  failure_message do |actual|
    invalid = invalid_items(actual, expected)
    "missing or invalid keys: #{invalid.keys.join(', ')}\n\n#{invalid}"
  end

  def invalid_items(actual, expected)
    expected.each_with_object({}) do |(key, value), memo|
      if !has_key?(actual, key) || !value_match(get_key(actual, key), value)
        memo[key] = value
      end
    end
  end

  def has_key?(actual, key)
    actual.key?(key.to_s) || actual.key?(key.to_sym)
  end

  def get_key(actual, key)
    if actual.key?(key.to_s)
      actual[key.to_s]
    else
      actual[key.to_sym]
    end
  end

  def value_match(actual_value, expected_value)
    if expected_value.is_a?(Regexp)
      actual_value =~ expected_value
    else
      actual_value.is_a?(expected_value)
    end
  end
end
