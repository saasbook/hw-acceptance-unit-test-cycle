require 'rails_helper'

RSpec.describe Movie, type: :model do
  it "returns similar movies" do
    movie1 = Movie.create(title: 'something', director: 'yiwei')
    movie2 = Movie.create(title: 'something2', director: 'yiwei')
    movie3 = Movie.create(title: 'something3', director: 'chen')
    expect(Movie.find_similar_movies('yiwei')).to eq [movie1, movie2]
  end
end
