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

	#
	# helper to return boolean if select list for month has a value
	#
	def has_month?(month)
		months = []
		dob_month_element.options.each {|mon| months << mon.text}
		return months.include?(month)
	end

	def years
		year_list = []
		dob_year_element.options.each{|yr| year_list << yr.text}
		return year_list.count - 1
	end

	# Takes in a Ast::Table of link texts and checks that the links are present on the page
	def has_links?(links)
		expected_links_raw = links.rows
		expected_links_raw.each do |link_text|
			@browser.link(:text => link_text[0]).exists?.should == true
		end
	end

	#
	# Below 3 are some helper methods to write elegant cucumber steps
	#
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

end