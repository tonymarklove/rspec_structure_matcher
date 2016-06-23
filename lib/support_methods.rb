module HaveStructureMatcherMethods
  def optionally(optional_expected_value)
    ->(actual_value) { actual_value.nil? || have_structure_value_match?(actual_value, optional_expected_value) }
  end

  def have_structure_value_match?(actual_value, expected_value)
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
  config.include HaveStructureMatcherMethods
end
