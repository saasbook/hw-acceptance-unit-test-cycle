require 'rails_helper'

RSpec.describe Movie, type: :model do
  before(:all) do
    if Movie.where(:director => "Jon Favreau").empty?
      Movie.create(:title => "Iron Man", :director => "Jon Favreau",
                   :rating => "PG-13", :release_date => "2008-05-02")
      Movie.create(:title => "Spider-Man: Homecoming", :director => "Jon Favreau",
                   :rating => "PG-13", :release_date => "2017-07-07")
    end
    
    if Movie.where(:title => "Big Hero 6").empty?
      Movie.create(:title => "Big Hero 6", 
                   :rating => "PG", :release_date => "2014-11-07")
    end
  end
  
  describe "others_by_same_director method" do
    it "returns all other movies by the same director" do
      movie = Movie.find_by_title("Iron Man")
      other_movies = movie.others_by_same_director()
      expect(other_movies.length()).to eq 1
      expect(other_movies).to include(Movie.find_by_title("Spider-Man: Homecoming"))
    end
    
    it "does not return movies by other directors" do
      movie = Movie.find_by_title("Big Hero 6")
      other_movies = movie.others_by_same_director()
      expect(other_movies).to be_empty
    end
  end
end


