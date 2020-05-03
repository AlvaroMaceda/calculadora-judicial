import React from "react";
import { Component } from 'react';
import Autocomplete from './autocomplete'


// render one item on the list
const MyItemView = function({ item }) {
  console.log('myItemView')
  console.log(item)
  return (
    <div className="user-data">
      {/* <div>{item.code}</div> */}
      <div>{item.name}</div>
    </div>
  );
};


class Municipality extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      value: 'foo'
    }

    this.onChange = this.onChange.bind(this);
    this.onSelect = this.onSelect.bind(this);
  }

  async searchMunicipalities(text) {
    let response = await fetch('/api/municipality/search/' + text);
    let data = await response.json();
    console.log(data)
    return data['municipalities'];
  }

    // invoked when the user types something. A delay of 200ms is
  // already provided to avoid DDoS'ing your own servers
  onChange(query) {
    if(query === '') return []
    // you would normally do here your server access
    this.searchMunicipalities(query).then(municipalities => {
      // this.refs.autocomplete.setItems(result.body);
      this.refs.autocomplete.setItems(municipalities);
    });
  }

  // called when the user clicks an option or hits enter
  onSelect(user) {
    this.setState({
      selectedUser: user
    });
    // the returned value will be inserted into the input field.
    // Use an empty String to reset the field
    return user.getName();
  }

  render() {
    return (
      <div>
        <Autocomplete
          ref="autocomplete"
          renderItem={MyItemView}
          onChange={this.onChange}
          onSelect={this.onSelect}
        />
      </div>
    );
  }

}


export default Municipality;