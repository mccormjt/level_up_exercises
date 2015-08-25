# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Set default date and time output formats
date_format = { :default => "%a, %d %b %Y" }
time_format = { :default => "%a, %d %b %Y -%l:%M%p" }
Date::DATE_FORMATS.merge!(date_format)
Time::DATE_FORMATS.merge!(time_format) 
