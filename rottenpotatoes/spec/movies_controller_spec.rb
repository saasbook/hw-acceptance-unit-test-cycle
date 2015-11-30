require 'rails_helper'

describe MoviesController do
  describe "#director" do
    context "When the specified movie has a director" do
      it "should find movies with the same director" do
        @movie_id = "1234"
        @movie = double('fake_movie', :director => 'James Cameron')
        expect(Movie).to receive(:find).with(@movie_id).and_return(@movie)
        expect(@movie).to receive(:similar_movies)
        get :director, :id => @movie_id
        expect(response).to render_template(:director)
      end
    end
    context "When the specified movie has no director" do
      it "should redirect to the movies page" do
        @movie_id = "1234" 
        @movie = double('fake_movie').as_null_object
        expect(Movie).to receive(:find).with(@movie_id).and_return(@movie)
        get :director, :id => @movie_id
        expect(response).to redirect_to(movies_path)
      end
    end
  end
end