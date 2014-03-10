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

Then(/^there should be a signup section$/) do
	on(FacebookHomePage).html.should include("Create an account")
end

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

Then(/^there should be present the below link texts in the page footer$/) do |links|
	on(FacebookHomePage).has_links?(links)
end