import React, {Component} from 'react';
import {Map, InfoWindow, Marker, GoogleApiWrapper} from 'google-maps-react';
import {withRouter, Switch, Link, Redirect, Route} from 'react-router-dom';

export class Container extends React.Component {
  state = {
    activeMarker: {},
    selectedPlace: {},
    showingInfoWindow: false
  };

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
            lat: -33.937334,
            lng: 22.707702
          }}
          zoom={12}
          onClick={this.onMapClicked}
        >

          <Marker onClick={this.onMarkerClick}
                name={'Current location'}
          />

          <InfoWindow
            marker={this.state.activeMarker}
            onClose={this.onInfoWindowClose}
            visible={this.state.showingInfoWindow}>
            <div>
              <h1>{this.state.selectedPlace.name}</h1>
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