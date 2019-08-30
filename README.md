[![CircleCI](https://circleci.com/gh/flippakitten/orbital_defence/tree/master.svg?style=svg)](https://circleci.com/gh/flippakitten/orbital_defence/tree/master)
[![Join the chat at https://gitter.im/orbital_defence/Lobby](https://badges.gitter.im/orbital_defence/Lobby.svg)](https://gitter.im/orbital_defence/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Maintainability](https://api.codeclimate.com/v1/badges/73c830c5ef8b9595063c/maintainability)](https://codeclimate.com/github/flippakitten/orbital_defence/maintainability)

Currently this project is restricted to a portion of Garden Route, South Africa.
The basic concept working is [Sidekiq-scheduler](https://github.com/moove-it/sidekiq-scheduler) will fetch the FIRMS data from Nasa and weather data from OpenWeatherMap and persist it in the database. The React UI will then fetch the data and display it on the map.

## Getting Started:

### External API's
Grab a Google Maps API key [here](https://developers.google.com/maps/documentation/javascript/get-api-key)  
Grab a OpenWeatherMap API key [here](https://openweathermap.org/appid)  
Grab a Nasa EarthData Api Key [here](https://nrt4.modaps.eosdis.nasa.gov/help/downloads#appkeys)

### Installation:
Install Postgres  
Install Redis  
Install Ruby/Rails  
Install Node and NPM  
Fork and clone the project from Github

```bash
bundle install
yarn

cp database.yml.example database.yml
# edit your PG database credentials

cp Profile.dev Procfile.env.dev
# add your Google api key to GAPI

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
