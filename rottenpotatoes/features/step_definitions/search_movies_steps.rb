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

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  within(:xpath, '//*[@id="movies"]/tbody') do
    expect(find(:xpath, './tr[1]/td[1]')).to have_content(e1)
    expect(find(:xpath, './tr[2]/td[1]')).to have_content(e2)
  end
end

