class AddDirectorToMovieTable < ActiveRecord::Migration
  def change
    add_column :movies, :director, :string
  end
end

zip -r hw4.zip hw4/app/ hw4/config/ hw4/db/migrate hw4/features/ hw4/spec/ hw4/Gemfile hw4/Gemfile.lock
