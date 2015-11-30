require 'rails_helper'

describe Movie do
  describe "#search_director"  do
    it "should find movies by the same director" do
      movie1 = Movie.create! :director => "Paul Newman"
      movie2 = Movie.create! :director => "Paul Newman"
      expect(movie1.search_director).to include(movie2)
    end
    it "should not find movies by different directors" do
      movie1 = Movie.create! :director => "Paul Newman"
      movie2 = Movie.create! :director => "James Cameron"
      expect(movie1.search_director).to_not include(movie2)
    end
  end
end