class Movie < ActiveRecord::Base
  class Movie::NoDirectorInfoFound < StandardError ; end
    
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
    # Movie.uniq.order(:rating).pluck(:rating)
  end
  
  def self.find_by_same_director(id)
    tmovie = find(id)
    raise Movie::NoDirectorInfoFound, 'No director info found.' if tmovie.director.to_s.empty?
    Movie.where('id != ? and director = ?', id, tmovie.director)
  end
end