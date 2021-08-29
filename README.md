# News-and-Weather-on-terminal-using-bash

This is a bash script. No additional files are required to run it as everything is handled within the script.
###
Screenshots are just samples to show the layout of output.
###
News data is scraped from Times of India RSS feeds, weather data is scraped from http://wttr.in. Project is purely educational.
###

## Code
Colours and font styles are defined using ANSI escape sequences.
News is fetched from the web using wget command. Live news feeds are available in XML format on a particular URL. It is stored in file 'news'.
XML data, that is stored as text must be filtered for news for viewing purposes. Filtering is done using grep and sed commands and stored in a file called 'text' before displaying.
Weather data provides a graphical view of weather along with few other details.
