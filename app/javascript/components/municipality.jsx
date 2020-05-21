import React from "react";
import PropTypes from 'prop-types';
import { Component } from 'react';
import AsyncSelect from 'react-select/async';

const MINIMUM_TEXT_TO_SEARCH = 3 // This should be the same number as MunicipalitySearchController minimum 

class Municipality extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      error: null
    }
    this.setValue = (value) => {
       this.setState({ ...this.state, value: value})
    }
  }

  setError(error) {
    this.setState({ ...this.state, error: error})
  }

  async searchMunicipalities(text) {
    this.setError(null)
    if(text.length < MINIMUM_TEXT_TO_SEARCH ) return
    try {
      
      const response = await fetch('/api/municipality/search/'+text)
      if (!response.ok) throw Error(response.statusText);
      let data = await response.json()
      
      let municipalities = data.municipalities
      let items = municipalities.map( (municipality) => { return {
        value: municipality.code,
        label: municipality.name
      }} )
      return items
  
    }catch(error) {
      this.setError('Error obteniendo datos: '+error)
    }
  }

  render() {

    const promiseOptions = inputValue => this.searchMunicipalities(inputValue)

    return(
      <React.Fragment>        
        {this.state.error && <div className='alert alert-danger'>{ this.state.error }</div>}
        <AsyncSelect 
          cacheOptions 
          isClearable
          placeholder = '...'
          defaultOptions={[]} 
          loadOptions={promiseOptions} 
          noOptionsMessage={ (_) => {return 'No se ha encontrado el municipio'} }
          onChange={ (item) => this.props.onChange && this.props.onChange(item) }
        />
      </React.Fragment>
    )

  }

} // Component

Municipality.propTypes = {
  onChange: PropTypes.func
}

export default Municipality;