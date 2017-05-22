require "bundler/setup"
Bundler.setup

require "pry-byebug"
require "rspec_structure_matcher"

RSpec.configure do |config|
  config.include HaveStructureMatcher::Methods
end
