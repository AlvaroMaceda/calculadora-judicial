import React from "react";
import { Component } from 'react';
import { useState } from 'react';

import Autocomplete from "./autocomplete";
import DatePicker from 'react-datepicker'
import "react-datepicker/dist/react-datepicker.css";
import style from './deadline_calculator.module.scss'

// const [startDate, setStartDate] = useState(new Date());
// const [municipality, setMunicipality] = useState('');
// const [workDays, setworkDays] = useState(20);

const handleSubmit = (event) => {
  console.log(`
    startDate: ${startDate}
    municipality: ${municipality}
    workDays: ${workDays}
  `);

  event.preventDefault();
}

// https://learnetto.com/blog/react-form-validation
class DeadlineCalculator extends Component {

  constructor (props) {
    super(props);
    this.state = {
      startDate: new Date(),
      municipality: '',
      workDays: 0,
      formErrors: {email: '', password: ''},
      formValid: false
    }
  }

  setStartDate(value) {
    this.setState({
        ...this.state,
        startDate: value
      })
  }
  setMunicipality(value) {
    this.setState({
      ...this.state,
      municipality: value
    })
  }
  setworkDays(value) {
    this.setState({
      ...this.state,
      workDays: value
    })
  }

  handleSubmit(event){

    event.preventDefault();
    console.log('banana')

    console.log(`
      startDate: ${this.state.startDate}
      municipality: ${this.state.municipality}
      workDays: ${this.state.workDays}
    `);
  
  }

  render() {
    return (
      <div className={style.container}>

        <div className={style.card}>

          <div className={style.header}>
            <h3 className="mb-0">Calculadora de plazos judiciales</h3>
          </div>

          <div className={style.body}>
            <form className="form" role="form" autoComplete="off" id="loginForm" noValidate="" onSubmit={this.handleSubmit.bind(this)}>

            <div className="form-group">
                <label>Fecha de inicio</label>
                <div className="row">
                  <div className="col-md-12">
                    <DatePicker
                      className="form-control col-md-12"
                      dateFormat="dd/MM/yyyy"
                      selected={this.state.startDate}
                      onChange={date => this.setStartDate(date)}
                    />
                  </div>
                </div>
                <div className="invalid-feedback">Please enter a password</div>
              </div>

              <div className="form-group">
                <label htmlFor="municipality" className="lb-lg">Municipio</label>
                <input id="municipality" type="text" 
                  className="form-control" required="" autoComplete="on"
                  value={this.state.municipality}
                  onChange={e => this.setMunicipality(e.target.value)}
                />
                <div className="invalid-feedback">Por favor, introduzca un municipio correcto</div>
              </div>

              <div className="form-group">
                <label>Días hábiles</label>
                <input id="workDays" type="text" 
                  className="form-control" required="" autoComplete="on"
                  value={this.state.workDays}
                  onChange={e => this.setworkDays(e.target.value)}
                />
                <div className="invalid-feedback">Por favor, introduzca un número</div>
              </div>

              <button type="submit" className="btn btn-success btn-lg float-right" id="btnLogin">Calcular</button>

            </form>
          </div>
        </div>
      </div>
    )
  }
}

export default DeadlineCalculator;