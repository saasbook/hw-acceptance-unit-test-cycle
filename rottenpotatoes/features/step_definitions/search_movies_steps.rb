Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(
                 title: movie[:title],
                 rating: movie[:rating],
                 director: movie[:director],
                 release_date: movie[:release_date],
                )
  end
end

Then /the director of "(.+)" should be "(.+)"/ do |movie, director|
  Movie.find_by_title(movie).director == director
end

