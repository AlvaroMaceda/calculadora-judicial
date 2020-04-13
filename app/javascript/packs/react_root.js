import React from 'react'
import ReactDOM from 'react-dom'
import HelloWorld from '../components/HelloWorld.js'

document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
      <HelloWorld greeting="Hello" />,
      document.body.appendChild(document.createElement('div')),
    )
  })