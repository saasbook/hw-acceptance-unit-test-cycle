require 'rails_helper'

RSpec.describe MoviesController do
  describe "#similar_movies" do
    it "grabs the movie from which we want to find similar movies" do
      movie = create(:movie)
      get :similar_movies, { id: movie.id }
      expect(assigns(:movie)).to eq(movie)
    end

    context "when a movie has a director" do
      it "should redirect to the similar movies page" do
        movie = create :movie
        get :similar_movies, { id: movie.id }
        expect(response).to render_template("similar_movies")
      end
    end

    context "when a movie has no director" do
      it "should redirect to the home page" do
        movie = create :movie, director: nil
        get :similar_movies, { id: movie.id }
        expect(response).to redirect_to("/")
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "#destroy" do
    it "grabs the movie we want to destroy" do
      movie = create(:movie)
      get :destroy, { id: movie.id }
      expect(assigns(:movie)).to eq(movie)
    end

    it "deletes the movie" do
      movie = create(:movie)
      delete :destroy, { id: movie.id }
      expect(flash.notice).to eq("Movie '#{movie.title}' deleted.")
    end
  end

  describe "#show" do
    it "redirects to the selected movie" do
      movie = create :movie
      get :show, { id: movie.id }
      expect(assigns(:movie)).to eq(movie)
      expect(response).to render_template(:show)
    end
  end

  describe "#create" do
    before do
      movie_attributes = { title: "This little one", rating: "G", description: "A long boring movie", director: "Bob Lepine", release_date: "1977-02-22" }
      post :create, movie: movie_attributes
    end

    it "creates a new movie" do
      expect(assigns(:movie)).to eq(Movie.first)
    end

    it "returns a flash message" do
      expect(flash.notice).not_to be_empty
    end

    it "redirects to the movies page" do
      expect(response).to redirect_to(movies_path)
    end
  end
end

