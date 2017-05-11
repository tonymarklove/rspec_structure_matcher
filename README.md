# RSpec Structure Matcher

A simple JSON structure matcher for RSpec.

When building an API it is nice to be able to test the response structure. Doing this with the built-in RSpec matchers can get tiresome. This matcher provides a nicer way to test for expected keys, value types, regular expressions, or custom validation procs/lambdas.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec_structure_matcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_structure_matcher

Then mixin/include the helper methods into your RSpec tests by adding them to the `RSpec.configure` block, usually found in `spec_helper.rb` or `rails_helper.rb`:

    RSpec.configure do |config|
      config.include HaveStructureMatcher::Methods
    end

## Usage

Define an expected response structure:

    expected_video_response = {
      title: 'Top Gear', # Exact match
      episode_number: optionally(Fixnum), # Optional, may be null
      tv_show: Hash,
      published_on: /\d{4}-\d{2}-\d{2}/,
      breadcrumbs: ->(value) { value == 'bread/crumbs' },
      images: Hash
    }

Then, assuming `video` is a parsed JSON response you can simply expect against the expected structure:

    expect(video).to have_structure(expected_video_response)

### Comparison Types

Including an item in the expected structure ensures that a key with that name exists in the response.

Native Types (String, Hash, etc.)
: Test that the value matches the type, using `is_a?`.

Regular Expression
: Tests the value for a match against the regular expression. Very useful for things like dates where your code is relying on a particular format.

Callable proc/lambda
: Callback your supplied proc with the `actual_value`. Return `true` for a match and `false` for a failure.

Exact match
: Other values will be compared directly with `==`.

### Testing Optional Values

As mentioned above, you can use `optionally` to test optional values, so that the test will pass even if the response contains a `null`. `optionally` is nothing more than a helpful lambda generation method, much like the proc/lambda that you can write yourself.

### Deep Structures

Nesting deeper structures works automatically. Simply nest your structure:

    expected_video_response = {
      title: 'Episode 1',
      tv_show: {
        title: 'Top Gear'
      }
    }

And then compare the structure as normal:

    expect(video).to have_structure(expected_video_response)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
