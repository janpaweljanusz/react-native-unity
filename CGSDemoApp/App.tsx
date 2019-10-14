import React, {Fragment } from 'react';
import {
  View,
  StyleSheet,
  Button,
  Text,
  TextInput 
} from 'react-native';
import {UIManager, NativeModules, Platform} from 'react-native';



class App extends React.Component {
  startValue: number;
constructor(props){
  super(props);
  this.state = { text: 'Useless Placeholder' };
  this.startValue = Math.random();
}

componentDidMount() {
  // const eventEmitter = new NativeEventEmitter(NativeModules.ToastExample);
  // eventEmitter.addListener('EventReminder', (event) => {
  //   console.log(event.eventProperty) // "someValue"
  //   this.setState({text: 'bagno'});
  //   // handle event and you will get a value in event object, you can log it here
  // });
}

measureLayout = async () => {
  try {
    let message = await NativeModules.ToastExample.showUnity('Awesome', NativeModules.ToastExample.SHORT);
    this.setState({text:message});
    console.log(message);
  } catch (e) {
    console.error(e);
  }
}

  render() {
    var cubeColor = this.props['cubeColor'];
    return (
      <View style={styles.container}>
        <View style={this.subContainerStyle()} onTouchEndCapture={Platform.OS !== 'android'&&this.onPressButton}>
          <View style={styles.container}>
          <Text style={styles.myText}>
              start value: {this.startValue}
          </Text>
            <Text style={styles.myText}>
              {Math.random()}
          </Text>
            <TextInput
            style={{height: 40, borderColor: 'gray', borderWidth: 1}}
            onChangeText={(text) => this.setState({text})}
            value={this.state.text}
          />
          </View>
        </View>
        <Button title="Press me" onPress={()=>  {Platform.OS === 'android'&&NativeModules.ToastExample.show('Awesome', NativeModules.ToastExample.SHORT)}}>press me</Button>
        <Button title="New Method" onPress={()=> this.measureLayout() }>press me</Button>
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
    RNManager.reactMessage(color);
    console.log('RN button clicked');
  }

  subContainerStyle() {
    return {
      width: 240,
      height: 100,
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
