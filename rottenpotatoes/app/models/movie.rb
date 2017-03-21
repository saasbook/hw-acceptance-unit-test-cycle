class Movie < ActiveRecord::Base
  class Movie::NoDirectorInfoFound < StandardError ; end
    
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_by_same_director(id)
    tmovie = find(id)
    raise Movie::NoDirectorInfoFound, 'No director info found.' if tmovie.director.to_s.empty?
    movies = Movie.where('id != ? and director = ?', id, tmovie.director)
  end
end