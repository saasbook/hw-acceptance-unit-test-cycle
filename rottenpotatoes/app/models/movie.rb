class Movie < ActiveRecord::Base
  
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.search_director(id)
  	Movie.find(id).director
  	self.where(director: Movie.find(id).director)
  end

end
