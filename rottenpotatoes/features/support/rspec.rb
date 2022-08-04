# This file prevents RSpec from issuing DEPRECATION warnings when it encounters
# deprecated syntax in `features/step_definitions/web_steps`.

require 'rspec/core'

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
