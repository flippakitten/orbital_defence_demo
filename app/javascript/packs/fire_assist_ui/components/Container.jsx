import React, {Component} from 'react';
import axios from 'axios'
import {Map, InfoWindow, Marker, GoogleApiWrapper} from 'google-maps-react';
import {withRouter, Switch, Link, Redirect, Route} from 'react-router-dom';

export class Container extends React.Component {
  state = {
    fires: [],
    activeMarker: {},
    selectedPlace: {},
    showingInfoWindow: false
  };

  componentDidMount() {
    axios.get('http://localhost:5000/fires/?latitude=-33.946609&longitude=22.732593&distance=100')
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
            lat: -33.937334,
            lng: 22.707702
          }}
          zoom={10}
          onClick={this.onMapClicked}
        >
          <Marker onClick={this.onMarkerClick}
                  name={'Current location'}
          />

          { this.state.fires.map(fire =>
            <Marker key={fire.id} onClick={this.onMarkerClick}
                    icon={{
                      url: "https://cdn3.iconfinder.com/data/icons/mapicons/icons/fire.png"
                    }}
                    name={fire.scan_type}
                    position={{lat: fire.latitude, lng: fire.longitude}}
                    detectedAt={fire.detected_at}
                    confidence={fire.confidence}
            />
          )}

          <InfoWindow
            marker={this.state.activeMarker}
            onClose={this.onInfoWindowClose}
            visible={this.state.showingInfoWindow}>
            <div>
              <b>Fire</b>
              <hr />
              Type: {this.state.selectedPlace.name}<br />
              Date: {this.state.selectedPlace.detectedAt}<br />
              Confidence: {this.state.selectedPlace.confidence}
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