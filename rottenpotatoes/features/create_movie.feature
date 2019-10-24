Feature: delete an existing movie
 
  As a moviegoer
  So that I can delete the movie
  I do not want to see a movie

Background: movies in database
 
  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |

Scenario: delete a movie
  Given I am on the details page for "Star Wars"
  When   I press "Delete"
  Then  I should be on the home page
  And   I should see "Movie 'Star Wars' deleted."
