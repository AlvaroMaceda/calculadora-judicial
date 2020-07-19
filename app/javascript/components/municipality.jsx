import React from 'react';
import PropTypes from 'prop-types';
import { Component, Fragment } from 'react';
import Select from 'react-select';
import { throttle } from "lodash";
import transliterate from '../transliterate'
import proptypes from './municipality.proptypes'
import callIfSet from '../call_if_set'

const MINIMUM_TEXT_TO_SEARCH = 3 // This should be the same number as MunicipalitySearchController minimum 

const filterOption = function (option, inputValue) {
  const label_to_compare = removeSpecialChars(option.label)
  const input_to_compare = removeSpecialChars(inputValue)
  return label_to_compare.includes(input_to_compare)
}

// This function should be equivalent to this ruby code:
// remove_special_chars(str).delete(' ').downcase
// Where:
// def remove_special_chars(str)
//     transliterated = I18n.transliterate(str)
//     chars_to_remove = "-/'"
//     transliterated.tr(chars_to_remove,'')
// end
// It's almost impossible to emulate I18n transliterate function, so we
// use an approximation
function removeSpecialChars(str) {
  let transliterated = transliterate(str)
  return transliterated.replace(/[-\/' ]/ig, '').toLowerCase();
}

class Municipality extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      options: [],
      error: null,
      loading: false,
    }
    this.throttledSearch = throttle(this.searchMunicipalities.bind(this),1000)
    this.lastSearch = null
  }

  modifyState(data) {
    this.setState({
        ...this.state,
        ...data
      }
    )
  }

  // TO-DO: refactor this
  async searchMunicipalities(text) {

    this.modifyState(
      {
        error: null,
        options: [],
        loading: true
      }
    )
    
    if(text.length < MINIMUM_TEXT_TO_SEARCH ) {
      if(text===this.lastSearch) 
        this.modifyState(
          {
            error: null,
            options: [],
            loading: false
          }
        )
      return
    }

    try {
      const response = await fetch('/api/municipality/search/'+text)
      if (!response.ok) throw Error(response.statusText);
      let data = await response.json()
      
      if(text!=this.lastSearch) {
        return // This is not the API call you are waiting for
      }

      let municipalities = data.municipalities
      let items = municipalities.map( (municipality) => { return {
        value: municipality.code,
        label: municipality.name
      }} )

      this.modifyState(
        {
          options: items,
          loading: false
        }
      )
  
    }catch(error) {

      this.modifyState(
        {
          options: [],
          loading: false,
          error: 'Error obteniendo datos: '+error
        }
      )

    }
  } //searchMunicipalities

  handleInputChange(text) {
    this.lastSearch = text
    this.throttledSearch(text)
  }

  noOptionsMessage({inputValue}) {
    if(inputValue && this.state.loading) return 'Cargando municipios...'
    if(inputValue.length >= MINIMUM_TEXT_TO_SEARCH) return 'No se ha encontrado el municipio'
    return 'Introduzca al menos tres letras'
  }

  render() {

    // const promiseOptions = inputValue => this.searchMunicipalities(inputValue)

    return(
      <Fragment>        
        {this.state.error && <div className='alert alert-danger'>{ this.state.error }</div>}
        <Select 
          isClearable
          placeholder = '...'
          isLoading={this.state.loading}
          loadingMessage={()=>'Buscando municipios...'}
          options={this.state.options}
          noOptionsMessage={this.noOptionsMessage.bind(this)}
          onInputChange={this.handleInputChange.bind(this)}
          filterOption={filterOption}
          onChange={ (item) => callIfSet(this.props.onChange,item) }
          onFocus={ () => callIfSet(this.props.onFocus) }
          onBlur={ () => callIfSet(this.props.onBlur) }
          onKeyDown={ () => callIfSet(this.props.onKeyDown) }
        />
      </Fragment>
    )

  } // Render

} // Component

Municipality.propTypes = proptypes

export default Municipality;