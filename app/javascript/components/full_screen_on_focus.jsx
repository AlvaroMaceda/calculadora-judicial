import React from "react";
import style from './full_screen_on_focus.module.scss'

import PropTypes from 'prop-types';

const props = {
  focused: PropTypes.bool
}

function FullScreenOnFocus(props) {

  console.log(`fullscreen props: ${props.focused}`)
  let classes = props.focused ? `${style.black_overlay} ${style.container}` : ''

  return (
    <React.Fragment>
      {
        props.focused ? props.children :''
      }
      <div className={classes}>
        {props.children}
      </div>
    </React.Fragment>
  )

}

export default FullScreenOnFocus