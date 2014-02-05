# Simple cucumber tutorial with Page Object gem - Part I

#### Introduction
In this tutorial I attempt to demonstrate and share how can we practice BDD or TDD as the case may be using Ruby and Cucumber. Cucumber provides us with the tools to write our test cases (behaviour of the system under test) in plain English.This plain english is parsed using gerkhin.Its defined as
"the language that Cucumber understands. It is a Business Readable, Domain Specific Language that lets you describe software’s behaviour without detailing how that behaviour is implemented". I assume some basic knowlegde of Ruby and what Cucumber is.

 I have chosen the Facebook home page as the page under test. In this part I will take you through the steps of setting up a very simple cucumber project. I utilises the ```page-object``` gem along with ```watir-webdriver``` and ```rspec``` to help me in the cucumber steps. Page object helps us to build our page class exposing the behaviour of our page, watir helps to drive the web browser and rspec helps with the our step implementations and has got very useful assertion functions. 

#### Set up the project directory structure
The project has a very simple directory structure, you can create it manually or use the ```testgen``` gem, I have used version 0.8.1. to install the gem ```gem install testgen```. To create the directory structure of the project you execute the command ```testgen project facebook``` which results in

```
create  facebook
create  facebook/cucumber.yml
create  facebook/Gemfile
create  facebook/Rakefile
create  facebook/features
create  facebook/features/support
create  facebook/features/step_definitions
create  facebook/features/support/env.rb
```
I have further create the directories ```/evidence``` and ```/support/pages``` that will hold any test evidences on scenario failures and our page abstraction classes called the page object. In the gem file include the following
```ruby
source 'http://rubygems.org'
gem 'cucumber'
gem 'rspec'
gem 'page-object'
```
execute bundle update command to install these if they are not already installed on your machine.

#### The before and after hooks
We start of by writing simple Before and After hooks for our project. These hooks are triggered before and after each cucumber scenario. These can take in additional parameters such as tag names so that they are executed only before or after certain scenarios or features. They can also be useful for set up test data and cleanup before and after tests.

Lets write a Before hook in the file features/hooks.rb

```ruby
Before do
  @browser = Watir::Browser.new :firefox
  @browser.window.maximize
end
```
Here we have created a Watir browser instance called @browser. This is available to all of our cucumber steps. Also we maximised the browser window. There are many more options available to configure watir.

The After hook has

```ruby
After do |scenario|
  if scenario.failed? then
    ext = Time.new.to_s.gsub(" ","").gsub(":","_")
    # Evidence file name is the feature file and line number suffixed with time stamp
    # replace the path separater, a . and : by an underscore character
    feature_line = scenario.location.to_s.gsub(/[\.\\\:]/,"_")
    @browser.screenshot.save "evidence/#{feature_line}-#{ext}.png"
  end
  @browser.close
end
```
This code takes in a block to check if the scenario has failed. If it has failed it takes a screenshot in the /evidence folder.

#### The page object class for the Facebook home page

We need to write a page object class using the PageObject mixin module offered by the page-object gem. The page object class exposes all the functionality of the page under test and all the teststeps interact with the page through the page object.

##### Initial Page Object class

```ruby
require 'page-object'

class FacebookHomePage
	include PageObject

	#
	# Header login items
	#
	page_url 'https://en-gb.facebook.com/'
	text_field(:userid, :id => "email")
	text_field(:password, :id => "pass")
	button(:signin, :id => "u_0_l")
	link(:forgot_password, :text => "Forgotten your password?")

	#
	# --- Some text fields for signing up
	#
	h1(:signup_header, :class => "mbs _3ma _6n _6s _6v", :index => 0)
	text_field(:firstname, :name => "firstname")
	text_field(:lastname, :name => "lastname")
	text_field(:reg_email, :name => "reg_email__")
	text_field(:reg_email_confirmation, :name => "reg_email_confirmation__")
	text_field(:reg_password, :name => "reg_passwd__")

	#
	# --- select lists and radio's for signing up
	#
	select_list(:dob_day, :name => "birthday_day")
	select_list(:dob_month, :name => "birthday_month")
	select_list(:dob_year, :name => "birthday_year")
	radio_button(:male, :id => "u_0_e")
	radio_button(:female, :id => "u_0_d")
	button(:signup, :name => "websubmit")

	#
	# --- Footer links using href's
	#
	link(:mobile, :href=> "https://www.facebook.com/mobile/?ref=pf")
	link(:find_friends, :href=> "https://www.facebook.com/find-friends?ref=pf")
	link(:badges, :href=> "https://www.facebook.com/badges/?ref=pf")
	link(:people, :href=> "https://www.facebook.com/directory/people/")
	link(:pages, :href=> "https://www.facebook.com/directory/pages/")
	link(:places, :href=> "https://www.facebook.com/directory/places/")
	link(:apps, :href=> "https://www.facebook.com/appcenter/?ref=pf")
	link(:games, :href=> "https://www.facebook.com/appcenter/category/games/?ref=pf")
	link(:music, :href=> "https://www.facebook.com/appcenter/category/music/?ref=pf")

	#
	# --- Footer links using link text
	#
	link(:about, :text => "About")
	link(:create_advert, :text => "Create Advert")
	link(:create_page, :text => "Create Page")
	link(:developers, :text => "Developers")
	link(:careers, :text => "Careers")
	link(:privacy, :text => "Privacy")
	link(:cookies, :text => "Cookies")
	link(:terms, :text => "Terms")
	link(:help, :text => "help")
end
```

Here we have used the ```text_field, link, select_list, radio_button, button and page_url``` page-object methods. There are methods available for most of the html elements, most of the methods take in a selector that help to identify the html element.

#### Write cucumber features and scenarios

Cucumber features are written in a file with extension ```.feature```. Lets create a feature file inder /feature called ```facebook_home.feature```. The first feature and scenario will be

##### Scenario for page header
```
Feature: Facebook social networking Home Page.

Background:
Given I visit the facebook home page

@header
Scenario: Check that the home page has header items displayed correctly.
	Then the header part of the page should have a textbox for login
	And the header part of the page should have a textbox for password
	And header part of the page should have a button for signing in
	And their should be a link to "Forgotten your password?"
```
We have used a ```Background``` which is used to group steps that will be executed before each scenario. Next I have written a scenario that I have tagged with a tag @header. These tags can be used in cucumber commands to include or execlude the scenarios that we want to run.

Lets go ahead and implement the above 4 steps and the background step.

```ruby
Given(/^I visit the facebook home page$/) do
	on(FacebookHomePage).goto
end

Then(/^the header part of the page should have a textbox for login$/) do
	on(FacebookHomePage).userid_element.visible?.should == true
end

Then(/^the header part of the page should have a textbox for password$/) do
	on(FacebookHomePage).password_element.visible?.should == true
end

And(/^header part of the page should have a button for signing in$/) do
	on(FacebookHomePage).signin_element.visible?.should == true
end

And(/^their should be a link to "(.*)"$/) do |link_text|
	@browser.link(:text => link_text).exists?.should == true
end
```

The ```on``` method is a factory method provided by module ```PageObject::PageFactory``` that takes in a class name and yields an object of that class. In step 1 we use the goto method that uses the page_url helper method to navigate to the page. In many of the above steps we see the magic that page object does, with the simple call to declare a text box such as ```text_field(:userid, :id => "email")``` we get some instance methods added to out page class one of these is the ```userid_element``` method that returns the HTML element reference.

in the last step 
```ruby
And(/^their should be a link to "(.*)"$/)
```
we have used the watir call to for a browser instance to check if a link with a link text exists.

##### Scenario for page body

Now we write the below two scenarios for the page body housing the user signup elements.

```ruby
@register
Scenario: Check the presence of the signup elements displayed correctly.
	Then there should be a signup section	
	And there should be a textbox for firstname, lastname and emailaddress
	And there should be a textbox for passwords
	And there should be a select lists for day, month and year parts of the date of birth
	And there should be a radio button for selecting sex of user
	And there should be a signup button

@register
Scenario: Check contents of the DOB select lists
	When I select the list for day then upto 31 days should be displayed
	When I select the list for month the following value should be displayed
		| month | 
		| Jan   | 
		| Feb   | 
		| Mar   | 
		| Apr   | 
		| May   | 
		| Jun   | 
		| Jul   | 
		| Aug   | 
		| Sept  | 
		| Oct   | 
		| Nov   | 
		| Dec   | 
	When I select the list for year then upto 110 years should be displayed
```
The steps are implemented as

```ruby
And(/^there should be a textbox for firstname, lastname and emailaddress$/) do
	on(FacebookHomePage) do |page|
		page.firstname_element.visible?.should == true
		page.lastname_element.visible?.should == true
		page.reg_email_element.visible?.should == true
		page.reg_email_confirmation_element.visible?.should == true
	end
end

And(/^there should be a textbox for passwords$/) do
	on(FacebookHomePage) do |page|
		page.reg_password_element.visible?.should == true
	end
end

And(/^there should be a select lists for day, month and year parts of the date of birth$/) do
	on(FacebookHomePage) do |page|
		page.dob_day_element.visible?.should == true
		page.dob_month_element.visible?.should == true
		page.dob_year_element.visible?.should == true
	end
end

And(/^there should be a radio button for selecting sex of user$/) do
	on(FacebookHomePage) do |page|
		page.male_element.visible?.should == true
		page.female_element.visible?.should == true
	end
end

And(/^there should be a signup button$/) do
	on(FacebookHomePage).signup_element.visible?.should == true
end

When(/^I select the list for day then upto 31 days should be displayed$/) do
	on(FacebookHomePage) do |page|
		presented_days = []
		presented_days = page.dob_day_element.options.each {|opt| presented_days << opt.text}
		# First value is "Day"
		presented_days.count.should == 32
	end
end

When(/^I select the list for month the following value should be displayed$/) do |month_list|
	expected_months = []
	expected_months_raw = month_list.rows
	expected_months_raw.each {|month| expected_months << month[0]}
	on(FacebookHomePage) do |page|
		expected_months.each {|expected_month| page.has_month?(expected_month).should == true}
	end
end

When(/^I select the list for year then upto 110 years should be displayed$/) do
	on(FacebookHomePage).years.should == 110
end
```

Most of the step definitions are quite similar to the earlier steps we discussed. Lets jump straight to the interesting ones.

```ruby
When(/^I select the list for day then upto 31 days should be displayed$/) do
```
Here we are trying to check if the day part of the select list has 31 entries in it (32 if including the "Day" value). The page class declaration ```select_list(:dob_day, :name => "birthday_day")``` is the key here. We again use the ```on``` method to give us an instance of the page, following that we use ```page.dob_day_element``` to give us the select list and then chain the ```options``` method to gove us an array of all the presented options in the list.

In the next step definition
```ruby
When(/^I select the list for year then upto 110 years should be displayed$/) do
```
Which is similar to what the earlier days step is trying to achieve , how ever it is a more elegant way. To achieve this let us add some more functionality to the page object class.

```ruby
	def years
		year_list = []
		dob_year_element.options.each{|yr| year_list << yr.text}
		return year_list.count - 1
	end
```
Here we have introduced a method ```years``` which returns the number of years that are presented in the years dropdown (```select_list(:dob_year, :name => "birthday_year")```). The advantage of doing this is that we have a much shorter, cleaner and readable step implementation in a single line.
```ruby
on(FacebookHomePage).years.should == 110
```

Finally lets look at the step which also introduces the cucumber table. The cucumber table help us to drive our test cases with some input data. Data can be provided in several formats including JSON and XML apart from the usual tabular data.
```ruby
When I select the list for month the following value should be displayed
```
the tabular data is yeilded as a block variable which is of type ```Cucumber::Ast::Table``` and offers various interesting methods to handle the tablular data. We have used the ```rows``` method in our case.

#### Further improving the page class

As this is the facebook home page, I might like to further improve it by adding a few more methods to it to make our future step definitions even more elegant and DRY. So add the below to ```features/support/pages/facebook_home.rb``` file

```ruby
	def login_correctly
		userid = "correct_user@email.com"
		password = "correct_password"
	end

	def login_incorrectly
		userid = "incorrect_user@email.com"
		password = "incorrect_password"
	end

	def login_with(login_email,login_password)
		userid = login_email
		password = login_password
	end
```

These would help us to write steps such as

```ruby
When a user tries to login with correct login details
...
When a user tries to login with incorrect login details
...
When a user tries to login with userid "user@email.com" and password "mys3cr3t"
...
```
They could then be implemented very simply in a single line of code using
```ruby
on(FacebookHomePage).login_correctly
on(FacebookHomePage).login_incorrectly
on(FacebookHomePage).login_with(user_id,password)
```
#### Running the tests
Execute any one of the below commands.
1. ```cucumber``` from the project root directory. Cucumber will automatically search for all the features to run. Please note that the first file that cucumber executes in the support directory is the ```env.rb``` file.
2. You can also execute ```cucumber --tags @register``` to run only the scenarios and features tagged with @register tag.
3. You can also execute ```cucumber --tags @footer``` to run only the scenarios and features tagged with @footer tag.
4. In case you want to generate a pretty HTML report when running all the features execute ```cucumber --format html -o report.html```

Please note that its possible to set up Rake tasks to achieve the above so that we dont need to type the commands repeatedly.

#### TODO
Rakefile

#### References
1. [Page Object gem]: https://github.com/cheezy/page-object
2. [Cucumber] : http://cukes.info/
3. [Page object design pattern] :http://code.google.com/p/selenium/wiki/PageObjects
4. [Rspec] : http://rspec.info/