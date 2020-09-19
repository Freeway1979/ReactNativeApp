import React from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  SafeAreaView,
} from 'react-native';

import PropTypes from 'prop-types';

class RNHome extends React.Component {
  static displayName = 'Home';

  constructor(props) {
    super(props);
    this.state = {
      site: props.site
    };
  }


  render() {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.listContainer}>
          <Text>
            Hello,World
        </Text>
        </View>
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
  },
});

RNHome.propTypes = {
  rootTag: PropTypes.number,
};

RNHome.defaultProps = {
  rootTag: 0,
};
