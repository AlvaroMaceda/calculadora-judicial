import React from "react";
import { Component } from 'react';
import AsyncSelect from 'react-select/async';

async function searchMunicipalities(text){
  try {
    const response = await fetch('/api/municipality/search/'+text)
    if (!response.ok) throw Error(response.statusText);
    let municipalities = await response.json();
    municipalities.map( (municipality) => { return {
      value: municipality.code,
      label: municipality.name
    }} )
  }catch(error) {
    console.log('Error obtaining municipalities')
  }  
}

const promiseOptions = inputValue => searchMunicipalities(inputValue)

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
      <AsyncSelect 
        cacheOptions 
        isClearable
        placeholder = '...'
        defaultOptions={[]} 
        loadOptions={promiseOptions} 
        noOptionsMessage={ (_) => {return 'No se ha encontrado el municipio'} }
      />
    )

  }

}

export default Municipality;