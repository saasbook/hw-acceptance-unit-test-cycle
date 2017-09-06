Then /^(?:|I )should either be on (.+) or (.+)$/ do |page_name, page_name2|
  current_path = URI.parse(current_url).path
  expect(current_path).to satisfy { |path| [path_to(page_name), path_to(page_name2)].include? path }
end