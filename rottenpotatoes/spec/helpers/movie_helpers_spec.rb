require 'rails_helper'

RSpec.describe MoviesHelper do
  describe "#oddness" do
    it "should return 'odd' when a number is odd" do
      expect(helper.oddness(3)).to eq("odd")
    end

    it "should return 'even' when a number is even" do
      expect(helper.oddness(2)).to eq("even")
    end
  end
end
