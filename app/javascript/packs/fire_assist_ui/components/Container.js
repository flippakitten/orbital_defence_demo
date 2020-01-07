import React, {Component} from 'react';
import axios from 'axios'
import {Map, InfoWindow, Marker, GoogleApiWrapper, Polyline} from 'google-maps-react';
import {withRouter, Switch, Link, Redirect, Route} from 'react-router-dom';

export class Container extends React.Component {
  state = {
    fires: [],
    activeMarker: {},
    selectedPlace: {},
    showingInfoWindow: false
  };

  componentDidMount() {
    axios.get('http://localhost:5000/fires/?latitude=-40.739103&longitude=154.476714&distance=1000')
      .then(response => {
        const fires = response.data;
        console.log(response.data);
        this.setState({ fires });
      })
  }

  onMarkerClick = (props, marker) =>
    this.setState({
      activeMarker: marker,
      selectedPlace: props,
      showingInfoWindow: true
    });

  onInfoWindowClose = () =>
    this.setState({
      activeMarker: null,
      showingInfoWindow: false
    });

  onMapClicked = () => {
    if (this.state.showingInfoWindow)
      this.setState({
        activeMarker: null,
        showingInfoWindow: false
      });
  };

  render() {
    const style = {
      width: '100vw',
      height: '100vh'
    };

    return (
      <div>
        <Map
          google={this.props.google}
          mapType={'terrain'}
          initialCenter={{
            lat: -25.263290,
            lng: 134.337539
          }}
          zoom={5}
          onClick={this.onMapClicked}
        >
          <Marker onClick={this.onMarkerClick}
                  name={'Current location'}
          />

          { this.state.fires.map(result =>
            <Marker key={result.fire.id} onClick={this.onMarkerClick}
                    icon={{
                      url: "https://cdn3.iconfinder.com/data/icons/mapicons/icons/fire.png"
                    }}
                    name={result.fire.scan_type}
                    position={{lat: result.fire.latitude, lng: result.fire.longitude}}
                    detectedAt={result.fire.detected_at}
                    confidence={result.fire.confidence}
                    weatherStation={result.weather.identifier}
                    weatherTemp={result.weather.temprature}
                    windSpeed={result.weather.wind_speed}
                    windDirection={result.weather.wind_direction}
                    humidity={result.weather.humidity}
            />
          )}
          { this.state.fires.map(result =>
            <Polyline key={result.fire.id}
              path={[
                {lat: result.fire.latitude, lng: result.fire.longitude},
                {lat: result.wind_arrow.lat, lng: result.wind_arrow.lng}
              ]}
              icons={[{
                icon: { path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW },
                offset: '100%'
              }]}
              strokeColor="#6975ff"
              strokeOpacity={0.8}
              strokeWeight={2}
            />
          )}

            { this.state.fires.map(result =>
                <Polyline key={result.fire.id}
                          path={[
                              {lat: result.fire.latitude, lng: result.fire.longitude},
                              {lat: result.detected_wind_arrow.lat, lng: result.detected_wind_arrow.lng}
                          ]}
                          icons={[{
                              icon: { path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW },
                              offset: '100%'
                          }]}
                          strokeColor="#999999"
                          strokeOpacity={0.8}
                          strokeWeight={2}
                />
            )}
          <InfoWindow
            marker={this.state.activeMarker}
            onClose={this.onInfoWindowClose}
            visible={this.state.showingInfoWindow}>
            <div>
              <b>Fire</b><br/>
              Type: {this.state.selectedPlace.name}<br />
              Date: {this.state.selectedPlace.detectedAt}<br />
              Confidence: {this.state.selectedPlace.confidence}
              <hr />
              <b>Weather</b><br/>
              {this.state.selectedPlace.weatherStation}<br />
              Temp: {this.state.selectedPlace.weatherTemp} C <br />
              Wind Speed: {this.state.selectedPlace.windSpeed} km/h<br />
              Wind Direction: {this.state.selectedPlace.windDirection}<br />
              Humidity: {this.state.selectedPlace.humidity}
            </div>
          </InfoWindow>
        </Map>
      </div>
    )
  }
}

const Loading = () => <div>Fancy loading container</div>;

export default withRouter(
  GoogleApiWrapper({
    apiKey: process.env.GAPI,
    libraries: ['places', 'visualization'],
    LoadingContainer: Loading
  })(Container)
);