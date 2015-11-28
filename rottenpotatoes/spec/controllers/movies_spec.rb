require 'rails_helper'

RSpec.describe MoviesController do
  describe "#similar_movies" do
    it "grabs the movie from which we want to find similar movies" do
      movie = FactoryGirl.create(:movie)
      get :similar_movies, { id: movie.id }
      expect(assigns(:movie)).to eq(movie)
    end

    context "when a movie has a director" do
      it "should redirect to the similar movies page" do
        movie = FactoryGirl.create :movie
        get :similar_movies, { id: movie.id }
        expect(response).to render_template("similar_movies")
      end
    end

    context "when a movie has no director" do
      it "should redirect to the home page" do
        movie = FactoryGirl.create :movie, director: nil
        get :similar_movies, { id: movie.id }
        expect(response).to redirect_to("/")
        expect(flash[:notice]).to be_present
      end
    end
  end
end

