RSpec::Matchers.define :have_structure do |expected|
  match do |actual|
    missing_items(actual, expected).empty?
  end

  failure_message_for_should do |actual|
    missing = missing_items(actual, expected)
    "missing or invalid keys: #{missing.join(', ')}\n\n#{actual.slice(*missing)}"
  end

  def missing_items(actual, expected)
    missing_items = []

    expected.each do |key, value|
      if !actual.has_key?(key.to_s) || !value_match(actual[key.to_s], value)
        missing_items << key.to_s
      end
    end

    missing_items
  end

  def value_match(actual_value, expected_value)
    if expected_value.is_a?(Regexp)
      actual_value =~ expected_value
    else
      actual_value.is_a?(expected_value)
    end
  end
end
