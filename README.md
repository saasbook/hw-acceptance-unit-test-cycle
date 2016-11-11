Acceptance-Unit Test Cycle
===

In this assignment you will use a combination of Acceptance and Units tests with the Cucumber and RSpec tools to add a "find movies with same director" feature to RottenPotatoes.


Learning Goals
--------------
After you complete this assignment, you should be able to:
* Create and run simple Cucumber scenarios to test a new feature
* Use RSpec to create unit tests that drive the creation of app code that lets the Cucumber scenario pass
* Understand where to modify a Rails app to implement the various parts of a new feature, since a new feature often touches the database schema, model(s), view(s), and controller(s)


Introduction and Setup
----
To get the initial RottenPotatoes code please clone this repo to your local machine or C9 workspace, and execute the following command in your top level projects directory, or the root of your C9 workspace:

```sh
$ git clone https://github.com/saasbook/hw-acceptance-unit-test-cycle
```

Once you have the clone of the repo:

1) Change into the rottenpotatoes directory: `cd hw-acceptance-unit-test-cycle/rottenpotatoes`  
2) Run `bundle install --without production` to make sure all gems are properly installed.    
3) Run `bundle exec rake db:migrate` to apply database migrations.    [ Note: expect to see "[DEPRECATION] `last_comment` is deprecated.  Please use `last_description` instead." If you are interested you can read [more about what deprecation means](https://en.wikipedia.org/wiki/Deprecation#Software_deprecation), however you can safely ignore this for the time being.
4) Run these commands to set up the Cucumber directories (under features/) and RSpec directories (under spec/) if they don't already exist, allowing overwrite of any existing files:

```shell
rails generate cucumber:install capybara
rails generate cucumber_rails_training_wheels:install
rails generate rspec:install
```

5) Create a new file called `rspec.rb` in features/support with the following contents:

```
require 'rspec/core'

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
```

This prevents RSpec from issuing DEPRECATION warnings when it encounters deprecated syntax in `features/step_definitions/web_steps`.

6) You can double-check if everything was installed by running the tasks `rspec` and `cucumber`.  

Since presumably you have no features or specs yet, both tasks should execute correctly reporting that there are zero tests to run. 

Depending on your version of RSpec, RSpec may also display a message stating that it was not able to find any _spec.rb files.

Also Cucumber will expect you to have run the database migrations so you may get the following error:

```
tansaku:~/workspace/hw-acceptance-unit-test-cycle/rottenpotatoes (master) $ bundle exec cucumber

Migrations are pending. To resolve this issue, run:

        bin/rake db:migrate RAILS_ENV=test

 (ActiveRecord::PendingMigrationError)
/usr/local/rvm/gems/ruby-2.3.0/gems/activerecord-4.2.6/lib/active_record/migration.rb:392:in `check_pending!'
/usr/local/rvm/gems/ruby-2.3.0/gems/activerecord-4.2.6/lib/active_record/migration.rb:405:in `load_schema_if_pending!'
...
/usr/local/rvm/gems/ruby-2.3.0/bin/ruby_executable_hooks:15:in `eval'
/usr/local/rvm/gems/ruby-2.3.0/bin/ruby_executable_hooks:15:in `<main>'
```

This can be addressed by following the instruction in the error message (however note we don't need the `bin`): `rake db:migrate RAILS_ENV=test`


**Part 1: add a Director field to Movies**

Create and apply a migration that adds the Director field to the movies table. 
The director field should be a string containing the name of the movie’s director. 
HINT: use the [`add_column` method of `ActiveRecord::Migration`](http://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/add_column) to do this. 

Remember to add `:director` to the list of movie attributes in the `def movie_params` method in `movies_controller.rb`.

Remember to apply the migration (i.e. `rake db:migrate RAILS_ENV=test`).

#### Self Check Questions

<details>
  <summary>Why do we need the `RAILS_ENV=test` element for cucumber to avoid encountering the error?</summary>
  <p><blockquote>Rails assumes three databases; test, development and production.  Cucumber is a testing tool and will always work against the test database.  So if we want to run our Cucumber (or RSpec) tests against the latest version of our database that includes our latest migration, we will need to run `RAILS_ENV=test`</blockquote></p>
</details>

<details>
  <summary>How do we ensure that our development database has the latest migrations for running the rails app locally?</summary>
  <p><blockquote>We can run `rake db:migrate RAILS_ENV=development` or simply `rake db:migrate` since rake db commands will be applied to the development database by default</blockquote></p>
</details>

**Part 2: use Acceptance and Unit tests to get new scenarios passing**

Here are three Cucumber scenarios to
drive creation of the happy path of Search for Movies by Director.

```gherkin
Feature: search for movies by director

  As a movie buff
  So that I can find movies with my favorite director
  I want to include and serach on director information in movies I enter

Background: movies in database

  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |

Scenario: add director to existing movie
  When I go to the edit page for "Alien"
  And  I fill in "Director" with "Ridley Scott"
  And  I press "Update Movie Info"
  Then the director of "Alien" should be "Ridley Scott"

Scenario: find movie with same director
  Given I am on the details page for "Star Wars"
  When  I follow "Find Movies With Same Director"
  Then  I should be on the Similar Movies page for "Star Wars"
  And   I should see "THX-1138"
  But   I should not see "Blade Runner"

Scenario: can't find similar movies if we don't know director (sad path)
  Given I am on the details page for "Alien"
  Then  I should not see "Ridley Scott"
  When  I follow "Find Movies With Same Director"
  Then  I should either be on the home page or the RottenPotatoes home page
  And   I should see "'Alien' has no director info"
```

The first lets you add director info to an existing movie, 
and doesn't require creating any new views or controller actions 
(but does require modifying existing views, and will require creating a new step definition and possibly adding a line
or two to `features/support/paths.rb`).

The second lets you click a new link on a movie details page "Find Movies With Same Director", 
and shows all movies that share the same director as the displayed movie.  
For this you'll have to modify the existing Show Movie view, and you'll have to add a route, 
view and controller method for Find With Same Director.  

The third handles the sad path, when the current movie has no director info but we try 
to do "Find with same director" anyway.

Going one Cucumber step at a time, use RSpec to create the appropriate
controller and model specs to drive the creation of the new controller
and model methods.  At the least, you will need to write tests to drive
the creation of: 

+ a RESTful route for Find Similar Movies 
(HINT: use the 'match' syntax for routes as suggested in "Non-Resource-Based Routes" 
in Section 4.1 of ESaaS). You can also use the key :as to specify a name to generate helpers (i.e. search_directors_path) http://guides.rubyonrails.org/routing.html Note: you probably won’t test this directly in rspec, but a line in Cucumber or rspec will fail if the route is not correct.

+ a controller method to receive the click
on "Find With Same Director", and grab the id (for example) of the movie
that is the subject of the match (i.e. the one we're trying to find
movies similar to) 

+ a model method in the Movie model to find movies
whose director matches that of the current movie. Note: This implies that you should write at least 2 specs for your controller: 1) When the specified movie has a director, it should...  2) When the specified movie has no director, it should ... and 2 for your model: 1) it should find movies by the same director and 2) it should not find movies by different directors.

It's up to you to
decide whether you want to handle the sad path of "no director" in the
controller method or in the model method, but you must provide a test
for whichever one you do. Remember to include the line 
`require 'rails_helper'` at the top of your *_spec.rb files.

We want you to report your code coverage as well.

Add `gem 'simplecov', :require => false` to the test group of your gemfile, then run `bundle install --without production`.

Next, add the following lines to the TOP of spec/rails_helper.rb and features/support/env.rb:

```ruby
require 'simplecov'
SimpleCov.start 'rails'
```

Now when you run `rspec` or `cucumber`, SimpleCov will generate a report in a directory named
`coverage/`. Since both RSpec and Cucumber are so widely used, SimpleCov
can intelligently merge the results, so running the tests for Rspec does
not overwrite the coverage results from SimpleCov and vice versa.

To see the results in Cloud9, open /coverage/index.html. You will see the code, but click the Run button at the top. This will spin up a web server with a link in the console you can click to see your coverage report.

Improve your test coverage by adding unit tests for untested or undertested code. Specifically, you can write unit tests for the `index`, `update`, `destroy`, and `create` controller methods.

**Submission:**

Here are the instructions for submitting your assignment for grading. Submit a zip file containing the following files and directories of your app:

* app/
* config/
* db/migrate
* features/
* spec/
* Gemfile
* Gemfile.lock

If you modified any other files, please include them too. If you are on a *nix based system, navigate to the root directory for this assignment and run

```sh
$ cd ..
$ zip -r hw5.zip rottenpotatoes/app/ rottenpotatoes/config/ rottenpotatoes/db/migrate rottenpotatoes/features/ rottenpotatoes/spec/ rottenpotatoes/Gemfile rottenpotatoes/Gemfile.lock
```

This will create the file hw5.zip, which you will submit.

IMPORTANT NOTE: Your submission must be zipped inside a rottenpotatoes/ folder so that it looks like so:

```
$ tree
.
└── rottenpotatoes
    ├── Gemfile
    ├── Gemfile.lock
    ├── app
    ...
```
