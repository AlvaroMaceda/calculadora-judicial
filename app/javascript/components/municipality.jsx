import React from "react";
import { Component } from 'react';
import Autocomplete from './autocomplete'

class Municipality extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      value: 'foo'
    }
    this.setValue = (value) => {
       this.setState({ ...this.state, value: value})
      }
  }

  render() {

    return(
      <Autocomplete
          getItemValue={(item) => item.label}
          suggestions={[
            { label: 'apple', value: 1 },
            { label: 'banana', value: 2 },
            { label: 'pear', value: 3 }
          ]}
          renderItem={(item, isHighlighted) =>
            <div style={{ background: isHighlighted ? 'lightgray' : 'white' }}>
              {item.label}
            </div>
          }
          value={this.state.value}
          onChange={(e) => this.value = e.target.value}
          onSelect={(val) => this.value = val}
      />
    )

  }

}


export default Municipality;