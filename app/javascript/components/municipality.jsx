import React from 'react';
import PropTypes from 'prop-types';
import { Component, Fragment } from 'react';
import Select from 'react-select';
// import {throttle} from '../lib/throttle_bounce'
import { throttle } from "lodash";
// const debounce = require('debounce-promise')



const MINIMUM_TEXT_TO_SEARCH = 3 // This should be the same number as MunicipalitySearchController minimum 


class Municipality extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      options: [],
      error: null,
      loading: false
    }
    // node_modules/react-select/src/Async.js
    this.throttledSearch = throttle(this.searchMunicipalities.bind(this),1000)
  }

  changeState(data) {
    this.setState({
        ...this.state,
        ...data
      }
    )
  }

  setOptions(options) {
    this.setState({ ...this.state, options: options})
  }

  setError(error) {
    this.setState({ ...this.state, error: error})
  }

  async searchMunicipalities(text) {
    this.setError(null)
    if(text.length < MINIMUM_TEXT_TO_SEARCH ) return []
    try {
      const response = await fetch('/api/municipality/search/'+text)
      if (!response.ok) throw Error(response.statusText);
      let data = await response.json()
      
      let municipalities = data.municipalities
      let items = municipalities.map( (municipality) => { return {
        value: municipality.code,
        label: municipality.name
      }} )
      this.setOptions(items)
  
    }catch(error) {
      this.setError('Error obteniendo datos: '+error)
    }
  }

  handleInputChange(text) {
    this.throttledSearch(text).then( (options)=>{
      this.setOptions(options)
    })
  }

  noOptionsMessage({inputValue}) {
    if(inputValue && this.loading) return 'Cargando municipios...'
    if(inputValue) return 'No se ha encontrado el municipio'
    return 'Introduzca el nombre del municipio'
  }

  render() {

    // const promiseOptions = inputValue => this.searchMunicipalities(inputValue)

    return(
      <Fragment>        
        {this.state.error && <div className='alert alert-danger'>{ this.state.error }</div>}
        <button
          onClick={()=>this.doIt()}
        >Clickme</button>
        <Select 
          // cacheOptions 
          isClearable
          placeholder = '...'
          // defaultOptions={[]}
          options={this.state.options}
          loadOptions={this.promiseOptions} 
          noOptionsMessage={this.noOptionsMessage.bind(this)}
          onChange={ (item) => { console.log('onchange'); /*this.props.onChange && this.props.onChange(item)*/ }}
          onInputChange={this.handleInputChange.bind(this)}
        />
      </Fragment>
    )

  }

} // Component

Municipality.propTypes = {
  onChange: PropTypes.func
}

export default Municipality;