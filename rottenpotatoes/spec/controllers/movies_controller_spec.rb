require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
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
  
  describe "when trying to find movies by the same director" do
    it "returns a valid collection when a valid director is present" do
      get :show_by_director, {:id => Movie.find_by_title("Iron Man")}
      expect(assigns(:movies)).to eq([Movie.find_by_title("Spider-Man: Homecoming")])
      expect(response).to render_template "show_by_director"
    end
    
    it "redirects to index with a warning when no director is present" do
      get :show_by_director, {:id => Movie.find_by_title("Big Hero 6")}
      expect(response).to redirect_to movies_path
      expect(flash[:warning]).to match(/'Big Hero 6' has no director info/) 
    end
  end
  
  describe "creates" do
    it "movies with valid parameters" do
      get :create, {:movie => {:title => "Toucan Play This Game", :director => "Armando Fox",
                    :rating => "G", :release_date => "2017-07-20"}}
      expect(response).to redirect_to movies_path
      expect(flash[:notice]).to match(/Toucan Play This Game was successfully created./)
      Movie.find_by(:title => "Toucan Play This Game").destroy
    end
  end
  
  describe "updates" do
    it "movie's valid attributes" do
      movie = Movie.create(:title => "Outfoxed!", :director => "Nick Mecklenburg",
                           :rating => "PG-13", :release_date => "2023-12-17")
      get :update, {:id => movie.id, :movie =>
        {:description => "Critics rave about this epic new thriller. Watch as main characters Armando Fox " +
                         "and Michael Ball, alongside their team of TAs, battle against the challenges of " +
                         "a COVID-19-induced virtual semester, a labyrinthian and disconnected assignment " +
                         "stack, and the ultimate betrayal from their once-trusted ally: Codio exams."}
      }
      
      expect(response).to redirect_to movie_path(movie)
      expect(flash[:notice]).to match(/Outfoxed! was successfully updated./)
      movie.destroy
    end
  end
end

