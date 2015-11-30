Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |movie, director|
  step %Q{I should see "#{movie}"}
  step %Q{I should see "#{director}"}
end

Then /I should( not)? see the following movies: (.*)/ do |notsee, movies|
  movies.split(',').map{|x| x.strip}.each do |movie|
    step %Q{I should#{notsee} see "#{movie}"}
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.body.index(e1).should < page.body.index(e2)
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, ratings_list|
  ratings_list.split.each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end

Then /I should see all the movies/ do
  page.all("table#movies tbody tr").count.should == 10
end