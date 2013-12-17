RSpec::Matchers.define :optionally_be do |expected|
  match do |actual|
    actual.nil? || actual.is_a?(expected)
  end

  failure_message_for_should do |actual|
    "#{actual} must be 'nil' or '#{expected}'"
  end
end
