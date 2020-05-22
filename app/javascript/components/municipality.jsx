import React from "react";
import PropTypes from 'prop-types';
import { Component } from 'react';
import AsyncSelect from 'react-select/async';
// import {throttle} from '../lib/throttle_bounce'


function throttle (func, interval) {

  let must_wait = false
  let pending_call = null

  return function() {
      // We must store the context because we don't know if the function
      // will be executed later
      let context = this

      let wait_and_check = function () {
              // Check every throttle interval
              
              if(pending_call) {
                  // If a pending call is waiting, call it now
                  // Then we must wait another interval and check if there are
                  // new calls awaiting execution
                  func.apply(context, pending_call)
                  pending_call = null
                  setTimeout(wait_and_check,interval)
              } else {
                // There are no more pending calls
                // Next call should not wait
                must_wait = false
              }
          };
    
      if (!must_wait) {
          // It has been more than 0interval' milliseconds since last call
          func.apply(context, arguments)
          // Next call must wait. We will check if there are pending calls
          // after 'interval' milliseconds
          must_wait = true;
          setTimeout(wait_and_check, interval)
      } else {
          // This call must wait. Store it and the timeout will launch it.
          // It there was a previous call waiting, is deleted
          pending_call = arguments
      }
  }
}


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