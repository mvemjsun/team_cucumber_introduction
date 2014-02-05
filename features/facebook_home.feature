Feature: Facebook social networking Home Page.

Background:
Given I visit the facebook home page

@header
Scenario: Check that the home page has header items displayed correctly.
	Then the header part of the page should have a textbox for login
	And the header part of the page should have a textbox for password
	And header part of the page should have a button for signing in
	And their should be a link to "Forgotten your password?"

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

@footer
Scenario: Check presence of various footer links
	Then there should be present the below link texts in the page footer
	| link_text     |
	| About         |
	| Create Advert |
	| Create Page   |
	| Developers    |
	| Careers       |
	| Privacy       |
	| Cookies       |
	| Terms         |
	| Help          |
	| Mobile        |
	| Find Friends  |
	| Badges        |
	| People        |
	| Pages         |
	| Places        |
	| Apps          |
	| Games         |
	| Music         |