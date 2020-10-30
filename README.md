Acceptance-Unit Test Cycle
===


In this assignment you will use a combination of Acceptance and Units tests with the Cucumber and RSpec tools to add a "find movies with same director" feature to RottenPotatoes.

(If you're not reading this directly on GitHub, you'll need to
temporarily [visit the GitHub
repo](https://github.com/saasbook/hw-acceptance-unit-test-cycle).)

To start:
in this repo, click the green "Use This
Template" button above to create a clean copy of the repo in your own GitHub account.

Learning Goals
--------------
After you complete this assignment, you should be able to:
* Create and run simple Cucumber scenarios to test a new feature
* Use RSpec to create unit tests that drive the creation of app code that lets the Cucumber scenario pass
* Understand where to modify a Rails app to implement the various parts of a new feature, since a new feature often touches the database schema, model(s), view(s), and controller(s)


Introduction and Setup
----
Clone **your copy** of this template repo to your development environment (**do
not clone** this reference repo or you'll be unable to push your
changes);

`git clone https://github.com/YOUR_GITHUB_USERNAME/hw-acceptance-unit-test-cycle`

Or if you've been using `ssh` as your GitHub transport:

`git clone git@github.com:YOUR_GITHUB_USERNAME/hw-acceptance-unit-test-cycle`

Once you have the clone of the repo:

1. Change into the rottenpotatoes directory: `cd hw-acceptance-unit-test-cycle/rottenpotatoes`  

2. Run `bundle install --without production` to make sure all gems are
properly installed.  **NOTE:** If Bundler complains that the wrong
Ruby version is installed, verify that `rvm` is installed (for
example, `rvm --version`) and say `rvm list` to see which Ruby
versions are available and `rvm use `_version_ to make a particular
version active.  If no versions satisfying the Gemfile dependency are
installed, you can say `rvm install `_version_ to install a new
version, then `rvm use `_version_ to use it.  Then you can try `bundle
install` again.

3. Create the initial database schema:


```shell
bundle exec rake db:migrate
bundle exec rake db:test:prepare
```

4. You can optionally add some seed data in `db/seeds.rb` and run `rake
db:seed` to add it.

5. Double check that RSpec is correctly set up by running `rake
spec`.  (Note--*not* `rake rspec` as you might think. Sorry.)
Although there are no RSpec tests yet, the task should run without
error.  

6. Double check that Cucumber is correctly set up by running `rake
cucumber`.  We've provided a couple of scenarios that will fail,
which you can use as a starting point, in `features/movies_by_director.feature`.

<details>
  <summary> 
  Read the Cucumber failure error messages.  The first test failure
  should be "unknown attribute 'director' for Movie."
  What will you have to do to address that
  specific error?  (Add something to a file, change the database, etc.)
  </summary>
  <p><blockquote> 
  You'll have to create and apply a migration that adds a `director`
  column to the `movies` table in the database.
  </blockquote></p>
</details>


# Part 1: add a Director field to Movies

Create and apply a migration that adds the Director field to the movies table. 
The director field should be a string containing the name of the
movie’s director. 

* Hint: you may find useful the [`add_column` method of `ActiveRecord::Migration`](http://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/add_column). 
* Remember that once the migration is applied, you also have to do `rake db:test:prepare`
to load the new post-migration schema into the test database.


<summary> 
  Clearly, now that a new field has been added, we will have to modify
  the Views so that the user can see and enter values for that field.
  Do we also have to modify the model file in order for the new field
  to be "noticed"?
  </summary>
  <p><blockquote> 
  Nope.  ActiveRecord infers the columns and their data types by
  inspecting the database.  However, if we wanted to have a validation
  on that column, we'd have to specifically mention it in a
  `validates` call.
  </blockquote></p>
</details>

<details>
  <summary> 
  Look at the step definitions for the failing steps of the Cucumber
  scenarios.  (Where would you find those definitions?)  Based on the step
  definitions, which step(s) of the scenario file would you now expect
  to *pass* if you re-run Cucumber, and why?
  </summary>
  <p><blockquote> 
  Once this field is added, running `rake cucumber` should allow the
  `Background:` steps to pass, since they just us ActiveRecord
  directly to create movies with a Director field.  But the other
  scenarios all manipulate the user interface (the views), which you
  have not yet modified, so they will still fail.
  </blockquote></p>
</details>

Verify that the Cucumber steps you expect to pass actually do pass.


<summary> 
  Besides modifying the Views, will we have to modify anything in the
  controller?  If so, what? 
  </summary>
  <p><blockquote> 
  Yes: we have to add `:director` to the list of movie attributes in
  the `def movie_params` method in `movies_controller.rb`.  Otherwise,
  even if that value is available as `params["movie"]["director"]`, it
  will be "scrubbed" by the `require` and `permit` calls on `params`
  before the controller actions are able to see it.
  </blockquote></p>
</details>

<summary> 
  Which controller actions, specifically, would fail to work correctly
  if we didn't make the above change?
  </summary>
  <p><blockquote> 
  `create` and `update` would fail, since they are the ones that
  expect a form submission in `params` in which `params["movies"]`
  should appear.  The other actions do not expect or manipulate this
  form (and do not call the helper function `movie_params`) so they
  would not be affected.
  </blockquote></p>
</details>

Based on the above self-checks, you should be able to modify the
controller and views as needed to be "aware" of the new Director field.



# Part 2: use Acceptance and Unit tests to get new scenarios passing

We've provided three Cucumber scenarios in the file
`features/movies_by_director.feature` to
drive creation of 2 happy paths  and 1 sad path of Search for Movies by Director.
The first lets you add director info to an existing movie, 
and doesn't require creating any new views or controller actions,
but does require modifying existing views, and will require creating a new step definition and possibly adding a line
or two to `features/support/paths.rb`. 

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
in the [Rails Routing
documentation](http://guides.rubyonrails.org/routing.html).  of
ESaaS). You can also use the key `:as` to specify a name to generate
helpers (i.e. search_directors_path)  Note: you probably won’t test
this directly in a spec, but a line in Cucumber or rspec will fail if the route is not correct.

+ a controller method to receive the click
on "Find With Same Director", and grab the `id` (for example) of the movie
that is the subject of the match (i.e. the one we're trying to find
movies similar to) 

+ a model method in the `Movie` model to find movies
whose director matches that of the current movie.

<details>
  <summary> 
  Would this model method be a class method or instance method?
  </summary>
  <p><blockquote> 
  Technically it could be either.  You could call it on a movie, the
  idea being that it returns other movies with the same director as
  its receiver, e.g. <code>movie.others_by_same_director()</code>.  Or
  you could define it as a class method, e.g. <code>Movie.with_director(director)</code>.
  In fact, it's great practice to write it both ways.
  </blockquote></p>
</details>

Verify that the Cucumber steps you expect to pass actually do pass.

Note: You should write at least 2 specs for your controller: 1) When
the specified movie has a director, it should...  2) When the
specified movie has no director, it should ... and 2 specs for your model:
1) it should return the correct matches for movies by the same director and 2) it should not
return matches of movies by different directors. 

It's up to you to
decide whether you want to handle the sad path of "no director" in the
controller method or in the model method, but you must provide a test
for whichever one you do. **Remember to include the line**
`require 'rails_helper'` at the top of every `*_spec.rb` file.

# Part 3: Code Coverage

We want you to report your code coverage as well.

Notice that the Gemfile includes the SimpleCov gem, and that the first
two lines of 
`rails_helper.rb` file (which you should be `require`ing at the top of
every `*_spec.rb` file) as well as the first two lines of
`features/support/env.rb` (which Cucumber loads automatically when
run) start the SimpleCov test coverage measurement.

Each time you run `rspec` or `cucumber`, SimpleCov  generates a report in a directory named
`coverage/`. Since both RSpec and Cucumber are so widely used, SimpleCov
can intelligently merge the results, so running the tests for Rspec does
not overwrite the coverage results from SimpleCov and vice versa.

To see the results, open `coverage/index.html`. You will see the code, but click the Run button at the top. This will spin up a web server with a link in the console you can click to see your coverage report.

Improve your test coverage by adding unit tests for untested or undertested code.

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
$ zip -r acceptance-tests.zip rottenpotatoes/app/ rottenpotatoes/config/ rottenpotatoes/db/migrate rottenpotatoes/features/ rottenpotatoes/spec/ rottenpotatoes/Gemfile rottenpotatoes/Gemfile.lock
```

This will create the file `acceptance-tests.zip`, which you will submit.

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
