# RSpec Structure Matcher

A simple JSON structure matcher for RSpec.

When building an API it is nice to be able to test the response structure. Doing this with the built-in RSpec matchers can get tiresome. This matcher provides a nicer way to test for expected keys, value types, and even matching values against regular expressions.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec_structure_matcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_structure_matcher

## Usage

Define an expected response structure:

    expected_video_response = {
      title: String,
      episode_number: Object, # Optional, may be null
      tv_show: Hash,
      published_on: /\d{4}-\d{2}-\d{2}/,
      breadcrumbs: Array,
      images: Hash
    }

Then, assuming `video` is a parsed JSON response you can simply expect against the expected structure:

    expect(video).to have_structure(expected_video_response)

### Comparison Types

Including an item in the expected structure ensures that a key with that name exists in the response.

Native Types (String, Hash, etc.)
: Test that the value matches the type, using `is_a?`.

Object
: Useful for testing the key exists but not requiring an particular type. Optional values (which are `null` if they are not present) can use this as well.

Regular Expression
: Tests the value for a match against the regular expression. Very useful for things like dates where your code is relying on a particular format.

### Testing Optional Values

As mentioned above, you can use `Object` to test optional values, so that the test will pass even if the response contains a `null`. To add an extra level of checking you can use the `optionally_be` matcher:

    expect(video['episode_number']).to optionally_be(Integer)

This will pass if `video['episode_number']` is either `null` or `is_a?(Integer)`.

### Deep Structures

Similar to optional values, testing deep strucutres has been kept as simple as possible. Simply define a new expected structure:

    tv_show_expected_structure = {
      title: string
    }

And then compare the structure as normal:

    expect(video['tv_show']) to have_structure(tv_show_expected_structure)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
