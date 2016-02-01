require "twitter"
$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['gca5ZVfLIRs2Xj8qv6ll5Ls5c']
  config.consumer_secret = ENV['mD4COEg8nucOOBpsYNq7Y7xQpaD6H1wLHXEZjnvzwm3Pw07WtI']
  config.access_token = ENV['3233371350-VNCXp6FIAjNjbAQj6SsBYbN10jS92T18SCwzeD2']
  config.access_token_secret = ENV['ZaRE91y26KsXr1czJMeOED4BglPhN26DSAXuQngQwrrcb']
end
