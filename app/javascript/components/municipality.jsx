import React from 'react';
import PropTypes from 'prop-types';
import { Component, Fragment } from 'react';
import Select from 'react-select';
import { throttle } from "lodash";

const MINIMUM_TEXT_TO_SEARCH = 3 // This should be the same number as MunicipalitySearchController minimum 

class Municipality extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      options: [],
      error: null,
      loading: false
    }
    this.throttledSearch = throttle(this.searchMunicipalities.bind(this),1000)
    this.lastSearch = null
  }

  changeState(data) {
    this.setState({
        ...this.state,
        ...data
      }
    )
  }

  // TODO: refactor this
  async searchMunicipalities(text) {

    this.changeState(
      {
        error: null,
        options: [],
        loading: true
      }
    )
    
    if(text.length < MINIMUM_TEXT_TO_SEARCH ) {
      if(text===this.lastSearch) 
        this.changeState(
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

      this.changeState(
        {
          options: items,
          loading: false
        }
      )
  
    }catch(error) {

      this.changeState(
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
    // if(inputValue && this.state.loading) return 'Cargando municipios...'
    if(inputValue.length >= MINIMUM_TEXT_TO_SEARCH) return 'No se ha encontrado el municipio'
    return 'Introduzca el nombre del municipio'
  }

  render() {

    // const promiseOptions = inputValue => this.searchMunicipalities(inputValue)

    return(
      <Fragment>        
        {this.state.error && <div className='alert alert-danger'>{ this.state.error }</div>}
        <Select 
          isClearable
          placeholder = '...'
          defaultOptions={[]}
          isLoading={this.state.loading}
          loadingMessage={()=>'Buscando municipios...'}
          options={this.state.options}
          loadOptions={this.promiseOptions} 
          noOptionsMessage={this.noOptionsMessage.bind(this)}
          onChange={ (item) => this.props.onChange && this.props.onChange(item) }
          onInputChange={this.handleInputChange.bind(this)}
        />
      </Fragment>
    )

  } // Render

} // Component

Municipality.propTypes = {
  onChange: PropTypes.func
}

export default Municipality;