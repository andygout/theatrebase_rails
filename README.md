[![Build Status](https://travis-ci.org/andygout/theatrebase.svg)](https://travis-ci.org/andygout/theatrebase) [![Coverage Status](https://coveralls.io/repos/andygout/theatrebase/badge.svg?branch=master&service=github)](https://coveralls.io/github/andygout/theatrebase?branch=master) [![Code Climate](https://codeclimate.com/github/andygout/theatrebase/badges/gpa.svg)](https://codeclimate.com/github/andygout/theatrebase)


TheatreBase
=================


Brief:
-------

A database-driven site that provides listings for theatrical productions, playtexts and associated data.

Ruby on Rails rebuild following [original version](https://github.com/andygout/theatrebase_php) written in PHP and SQL with MySQL database.


Site overview:
-------

#### Productions
- Title
- Material (i.e. The Seagull (play))
- Playtext (i.e. The Seagull (2012))
- Dates (preview / press night / booking until / final performance)
- Theatre
- Class (professional / amateur / drama school)
- Touring (legs / overview)
- Collections (segments / overview)
- Plays in repertory with
- Previous/subsequent runs
- Production version (world premiere; return; West End transfer, etc.)
- Text version (new; revival; new adaptation; abridged text, etc.)
- Category (play; musical; monologue; opera; ballet, etc.)
- Genre (Shakespearean tragedy; Ancient Greek; farce; Restoration comedy; In-yer-face theatre, etc.)
- Features (all male cast (if unconventional); modernised setting; site specific; Spanish language, etc.)
- Themes (global warming; regicide; insomnia, etc.)
- Setting: time, location & place (Easter 1962, bedsit, Knightsbridge)
- Writers (company & people, inc. source material)
- Producers (company & people)
- Performers (company & people) and corresponding characters portrayed
- Understudies (company & people) and corresponding characters portrayed
- Musicians(company & people)
- Creative team (company & people)
- Production team (company & people)
- Season (i.e. David Hare season (Sheffield Theatres))
- Festival (i.e. RSC Complete Works Festival)
- Course (i.e. Royal Academy of Dramatic Art (RADA): 3 Year Acting (2006-09))
- Reviews (critic, publication and URL link to online review)
- Awards

#### Playtexts
- Title
- Material (i.e. The Seagull (play))
- Text version (i.e. original text; new translation; abridged text, etc.)
- Year written
- Collections (segments / overview / collected works)
- Writers (company & people, inc. source material)
- Contributors (company & people) (in relation to publication of text)
- Category (play; musical; monologue, etc.)
- Genre (Shakespearean tragedy; Ancient Greek; farce; Restoration comedy; In-yer-face theatre, etc.)
- Features (modernised setting; site specific; Spanish language, etc.)
- Themes (global warming; regicide; insomnia, etc.)
- Setting: time, location & place (Easter 1962, bedsit, Knightsbridge)
- Cast required
- Characters
- Licensors
- Productions of the playtext listings
- Awards (for the playtext and productions of the playtext)

#### Theatre
- Name
- Building location
- Type (West End; fringe; regional; studio, etc.)
- Theatre owners
- Subtheatres (i.e. National Theatre: Olivier Theatre / Royal Court Theatre: Jerwood Theatre Downstairs, etc.)
- Capacity
- Opening/closing dates
- Production listings

#### Awards
- Award grantor (i.e. Laurence Olivier Awards)
- Award ceremony (i.e. grantor and year: Laurence Olivier Awards 2015)
- Award categories (specifically within ceremony and history of a given award category)
- Category nominees: productions; playtexts; companies; people
- Ceremony venue and date

#### Company
- Name (trading and registered)
- Base location
- Company type (i.e. subsidised theatre; commercial theatre; literary agency)
- Company members and corresponding roles
- Production and playtext listings (in various roles)
- Awards
- Clients represented (as agency)
- Drama school courses coordinated
- Theatre owned

#### People
- Name
- Sex
- Ethnicity
- Place of origin
- Profession within the industry
- Production and playtext listings (in various roles)
- Awards
- Representation (agency and agent) / Clients represented (as agent)
- Drama school courses coordinated / as staff / as student

#### Character
- Name
- Sex
- Age / range
- Description
- Ethnicity
- Place of origin
- Profession
- Attributes (physical and characteristics)
- Abilities
- Playtexts in which character appears
- Productions in which character has been portrayed

#### Drama school course
- Course type (3 Year Acting; 2 Year Directing, etc.)
- Course start/end dates
- Course coordinators (company & people)
- Course staff
- Students
- Production listings

#### Season
- Name
- Production listings

#### Festival
- Name
- Production listings

#### Material
- Name
- Format (play; operetta; musical; novel; screenplay, etc.; encompasses material when used as source material)
- Production and playtext listings

#### Production version
- Description
- Production and playtext listings

#### Text version
- Description
- Production and playtext listings

#### Category
- Description
- Production and playtext listings

#### Genre
- Description
- Related genres (i.e. Shakespearean history -> Shakespearean theatre, Elizabethan theatre)
- Production and playtext listings

#### Feature
- Description
- Production and playtext listings

#### Theme
- Description
- Broader themes (i.e. Normandy landings -> World War II, World War, War)
- Production and playtext listings

#### Setting: Location
- Name
- Related locations (i.e. Derbyshire -> England, UK, Europe)
- Sunsequently/previously (i.e. Constantinople subsequently Istanbul)
- Production and playtext listings
- Person and character listings (originated from location)
- Theatre and company listings (based at location)

#### Setting: Place
- Name
- Related places (i.e. Airport cafe -> Airport, Cafe)
- Production and playtext listings

#### Setting: Time
- Description
- Date(s)
- Related times (i.e. 1993 -> 1990s, 20th Century)
- Production and playtext listings

#### Ethnicity
- Description
- Related ethnicities (i.e. Rutul -> Russian; Han -> Chinese; Yoruba -> African)
- Person and character listings

#### Profession
- Description
- Related professions (i.e. King of England -> King, Royalty; Literary agent -> Agent)
- Person and character listings

#### Attributes
- Description
- Related attributes (i.e. Pentecostal -> Protestant Christian, Christian)
- Character listings

#### Abilities
- Description
- Character listings


Technologies used:
-------

- [Ruby](https://www.ruby-lang.org/en/): dynamic, reflective, object-oriented, general-purpose programming language
- [Ruby on Rails](http://rubyonrails.org/): model–view–controller (MVC) framework, providing default structures for a database, a web service, and web pages. It encourages and facilitates the use of web standards such as JSON or XML for data transfer, and HTML, CSS and JavaScript for display and user interfacing
- [Active Record](http://guides.rubyonrails.org/active_record_basics.html): the M in MVC - the model - which is the layer of the system responsible for representing business data and logic; facilitates the creation and use of business objects whose data requires persistent storage to a database
- [PostgreSQL database](http://www.postgresql.org/): open source database


Testing:
-------

- [RSpec](http://rspec.info/): Behaviour Driven Development for Ruby
- [Capybara](https://github.com/jnicklas/capybara): library written in the Ruby programming language which makes it easy to simulate how a user interacts with your application
- [Poltergeist](https://github.com/teampoltergeist/poltergeist): PhantomJS driver for Capybara; allows you to run your Capybara tests on a headless WebKit browser, provided by PhantomJS
- [SimpleCov](https://github.com/colszowka/simplecov): code coverage for Ruby 1.9+ with a powerful configuration library and automatic merging of coverage across test suites
- [Selenium WebDriver](http://www.seleniumhq.org/projects/webdriver/): browser automation for tests; accepts commands and sends them to a browser, implemented through a browser-specific browser driver, which sends commands to a browser, and retrieves results

#### ChromeDriver
- [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/downloads): runs WebDriver tests on Chrome browser (Firefox is Selenium's default browser); add below to respective files:-

`Gemfile`:
`gem 'chromedriver-helper', '~> 1.0'`

`spec/spec_helper`:
```ruby
require 'capybara'
require 'show_me_the_cookies'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.javascript_driver = :chrome
ShowMeTheCookies.register_adapter(:chrome, ShowMeTheCookies::Selenium)
```

Tests also require `page.execute_script 'window.close();'` at end of `within_window` method

*N.B. Tests fail on Travis CI so only usefully applied locally*


Site setup
-------

- Run server using: `$ rails s` and visit homepage: `localhost:3000`


Testing setup
-------

- Run RSpec from root directory: `$ rspec`
- Open coverage report in browser: `$ open coverage/index.html`


Links:
-------

[GitHub (andygout): TheatreBase PHP](https://github.com/andygout/theatrebase_php): original version of site written in PHP and SQL with MySQL database

[Active Record Associations](http://guides.rubyonrails.org/association_basics.html)
