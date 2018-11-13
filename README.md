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

Then Run a rails console to import the data
```ruby
ImportFirmsData.import

fire = Fire.first

Fire.within(5, origin: [fire.latitude, fire.longitude])
Fire.within(5, origin: [-33.946609, 22.732593])

```
