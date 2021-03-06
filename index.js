import {
    AppRegistry
  } from 'react-native';
import { registerRootComponent } from 'expo';

import App from './App';
import RNHome from './src/features/home/RNHome';

// registerRootComponent calls AppRegistry.registerComponent('main', () => App);
// It also ensures that whether you load the app in the Expo client or in a native build,
// the environment is set up appropriately
registerRootComponent(App);

// Register All Modules
AppRegistry.registerComponent('RNHome', () => RNHome);
