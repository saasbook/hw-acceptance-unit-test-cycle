require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
    describe "GET index" do
      it "assigns all movies as @movies" do
        movie = Movie.create!(title: "valid title", rating: "PG")
        get :index
        expect(assigns(:movies)).to eq [movie]
      end
      it "redirects to movies" do
        get :index, {:sort => 'title'}
        expect(response).to redirect_to :ratings => assigns(:selected_ratings),
                                        :sort => 'title'
      end
      it "redirects to movies" do
        get :index, {:sort => 'release_date'}
        expect(response).to redirect_to :ratings => assigns(:selected_ratings),
                                        :sort => 'release_date'
      end
    end
    describe "GET show" do
      it "assigns the requested movie as @movie" do
        movie = Movie.create!(title: "valid title")
        get :show, {:id => movie.to_param}
        expect(assigns(:movie)).to eq movie
      end
    end
    describe "GET edit" do
      it "assigns the requested movie as @movie" do
        movie = Movie.create!(title: "valid title")
        get :edit, {:id => movie.to_param}
        expect(assigns(:movie)).to eq movie
      end
    end
    describe "Put update" do
        it "assigns the requested movie as @movie" do
            movie = Movie.create!(title: 'something')
            put :update, {:id => movie.to_param, :movie => {"title" => "new title"}}
            expect(assigns(:movie)).to eq movie
            expect(flash[:notice]).to eq "new title was successfully updated."
            expect(response).to redirect_to(movie)
      end
    end
    describe "POST create" do
      it "creates a new movie" do
        parameters = {movie: {title: 'valid title'}}
        expect {post :create, parameters}.to change(Movie, :count).by(1)
        expect(flash[:notice]).to eq "valid title was successfully created."
      end
    end
    describe "DELETE destroy" do
      it "destroys the requested movie" do
        movie = Movie.create!(title: 'something')
        expect do
          delete :destroy, {:id => movie.to_param}
        end.to change(Movie, :count).by(-1)
        expect(flash[:notice]).to eq "Movie 'something' deleted."
        expect(response).to redirect_to movies_path
      end
    end
    describe "Get search" do
        it "searches similar movies" do
            movie1 = Movie.create!(title: 'something', director: 'yiwei')
            movie2 = Movie.create!(title: 'something2', director: 'yiwei')
            get :search_directors, {:id => movie1.to_param}
            expect(assigns(:movies)).to eq [movie1, movie2]
            expect(assigns(:movie)).to eq movie1
        end
        it "searches movies with no director" do
            movie1 = Movie.create!(title: 'something', director: '')
            get :search_directors, {:id => movie1.to_param}
            expect(assigns(:movie)).to eq movie1
            expect(flash[:notice]).to eq "'something' has no director info"
            expect(response).to redirect_to movies_path
        end
    end
end
