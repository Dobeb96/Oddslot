# Oddslot
A quick crawler to get profitable matches from Oddslot.com

# Dependencies and usage
Instead of Ruby of course, you will need to install Watir: `gem install watir`, and one of suggested drivers for browsers, which you can find here watir.com/guides/drivers/

With that, simply run the program without any arguments: `ruby game_results_manager.rb`

# How it works
Bets from oddslot.com are picked by real people. Not all bets posted by them will be profitable in a long run. There are some _leagues_, or some _% chance_ that prove to be picked with too much of enthusiasm by the crew. So I did this crawler that runs through last 80 or so pages and checks which _leagues_ are winning most often and also which _% chance_ do the crew tend to give to these matches, combines it all and prints if there is any particular bet profitable.

I recommend running this script in the mornings, about 9AM, but sometimes later, as it is then, when Oddslot team puts their picks for that day.


