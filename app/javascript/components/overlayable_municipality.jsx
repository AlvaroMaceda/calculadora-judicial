import React from "react";
import { Component } from 'react'
import FullScreenOnFocus from './full_screen_on_focus'
import Municipality from './municipality'

import callIfSet from '../call_if_set'

import PropTypes from 'prop-types';

const props = {
  onChange: PropTypes.func
}


class OverlayableMunicipality extends Component {

  constructor(props) {
    super(props)
    
    this.municipalityRef = React.createRef();
    this.state = {
      focused: false
    }
  }

  setFocused(focused) {
    this.setState({
      ...this.state,
      focused: focused
    })
  }

  onChange(municipality) {
    this.setFocused(false)
    console.log(this.municipalityRef.current)
    this.municipalityRef.current.blurSelect();
    callIfSet(this.props.onChange, municipality)
  }

  render() {
    return(
    <FullScreenOnFocus focused={this.state.focused}>
      <Municipality
        ref={this.municipalityRef}
        onChange={ (municipality) => {
            // municipality.onBlur()
            /* HOL */
            this.onChange(municipality)
          } 
        }
        onFocus={ () => this.setFocused(true) }
        onBlur={ () =>  this.setFocused(false) }
        onInputChange={ () => this.setFocused(true) }
        onKeyDown={ () => this.setFocused(true) }
      />
    </FullScreenOnFocus>
    )
  }

}


export default OverlayableMunicipality