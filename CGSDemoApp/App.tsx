import React, { Fragment } from 'react';
import {
  View,
  StyleSheet,
  Button,
  Text
} from 'react-native';
import {NativeModules} from 'react-native';

class App extends React.Component {

  render() {
    var cubeColor = this.props['cubeColor'];
    return (
      <View style={styles.container}>
        <View style={this.subContainerStyle()} onTouchEndCapture={this.onPressButton}>
          <View style={styles.container}>
            <Text style={styles.myText}>
              Randomize
          </Text>
          </View>
        </View>
      </View>
    );
  };

  onPressButton() {
    var RNManager = NativeModules.RNManager;
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    RNManager.updateColor(color);
    console.log('RN button clicked');
  }

  subContainerStyle() {
    return {
      width: 240,
      height: '100%',
      backgroundColor: this.props['cubeColor']
    }
  }

  getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }

}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'transparent'
  },
  myText: {
    textAlign: 'center',
  }
});

export default App;
