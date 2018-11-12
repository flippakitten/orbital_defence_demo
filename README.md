# README

Getting Started:
Grab a Google Maps API key  
Grab a openweathermap API key  
Grab a Nasa EarthData Api Key [here](https://nrt4.modaps.eosdis.nasa.gov/help/downloads#appkeys)

## Installation:
Install Rails.
Fork Project in Github
Clone locally

```bash
bundle install
yarn
cp database.yml.example database.yml
cp Profile.dev Procfile.env.dev
EDITOR="vim" rails credentials:edit
# Add your Nasa Earth Data API key
# Update database credentials
foreman start -f Profile.env.dev
```
