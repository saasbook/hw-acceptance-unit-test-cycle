require 'rails_helper'

RSpec.describe Movie do
  describe "#find_movies_with_same_director" do
    fixtures :movies
    let('movie1') { movies(:movie) }
    let('movie2') { movies(:movie_2) }
    let('movie3') { movies(:movie_other_director) }

    it "should return movies with the same directors" do
      expect(Movie.find_movies_with_same_director(movie1)).to eq([movie1, movie2])
    end

    it "should not find movies with different directors" do
      expect(Movie.find_movies_with_same_director(movie1)).not_to include(movie3)
    end
  end

  describe "#self.all_ratings" do
    it "returns all the ratings available" do
      ratings = %W(G PG PG-13 NC-17 R)
      expect(Movie.all_ratings).to eq(ratings)
    end
  end
end
