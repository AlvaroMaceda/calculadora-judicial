import React from "react";
import PropTypes from 'prop-types';
import { Component } from 'react';
import AsyncSelect from 'react-select/async';
// import {throttle} from '../lib/throttle_bounce'
// import { debounce, throttle } from "lodash";
// const debounce = require('debounce-promise')

function throttle(func, interval) {

  let must_wait = false
  let pending_call = null

  return function() {
      // We must store the context because we don't know if the function
      // will be executed later
      let context = this
      let res

      let wait_and_check = function () {
              // Check every throttle interval
              
              if(pending_call) {
                  // If a pending call is waiting, call it now
                  // Then we must wait another interval and check if there are
                  // new calls awaiting execution
                  res = func.apply(context, pending_call)
                  pending_call = null
                  setTimeout(wait_and_check,interval)
                  // console.log(func.toString())
                  // console.log('returning:')
                  // console.log(res)
                  return res
              } else {
                // There are no more pending calls
                // Next call should not wait
                must_wait = false
              }
          };
    
      console.log('running throttled function '+interval)
      if (!must_wait) {
          // It has been more than 0interval' milliseconds since last call
          res = func.apply(context, arguments)
          // Next call must wait. We will check if there are pending calls
          // after 'interval' milliseconds
          must_wait = true;
          setTimeout(wait_and_check, interval)
          return res
      } else {
          // This call must wait. Store it and the timeout will launch it.
          // It there was a previous call waiting, is deleted
          pending_call = arguments
      }
  }
}


const MINIMUM_TEXT_TO_SEARCH = 3 // This should be the same number as MunicipalitySearchController minimum 

function formatDate(d) {
  return d.getMinutes() + ':' + d.getSeconds() + "." + d.getMilliseconds()
}

class Municipality extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      error: null
    }
    // node_modules/react-select/src/Async.js
    // this.promiseOptions = inputValue => this.searchMunicipalities(inputValue)
    this.debouncedSearch = throttle(this.searchMunicipalities,1000)
    this.promiseOptions = inputValue => this.debouncedSearch(inputValue)
  }

  setValue(value) {
    this.setState({ ...this.state, value: value})
  }

  setError(error) {
    this.setState({ ...this.state, error: error})
  }

  async searchMunicipalities(text) {
    console.log('search function')
    this.setError(null)
    if(text.length < MINIMUM_TEXT_TO_SEARCH ) return []
    try {
      console.log('searching...')
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

    // const promiseOptions = inputValue => this.searchMunicipalities(inputValue)

    return(
      <React.Fragment>        
        {this.state.error && <div className='alert alert-danger'>{ this.state.error }</div>}
        <AsyncSelect 
          cacheOptions 
          isClearable
          placeholder = '...'
          defaultOptions={[]} 
          loadOptions={this.promiseOptions} 
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