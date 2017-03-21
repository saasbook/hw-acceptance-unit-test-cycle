
# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!({title: movie[:title], rating: movie[:rating], release_date: movie[:release_date], director: movie[:director]})
  end
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |title, director|
  movie = Movie.find_by_title title
  expect(movie.director).to eq director
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  rgx = /#{e1}.*#{e2}/m
  page.body.should =~ rgx
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/, /).each do |rating|
    steps %Q{
      When I #{ uncheck }check "ratings[#{ rating }]"
    }
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  # page.all('table#movies tr').count.should == (Movie.count + 1)
  page.assert_selector('#movies tbody tr', count: Movie.count)
end