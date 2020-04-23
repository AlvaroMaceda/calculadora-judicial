import React from "react";
import { Component } from 'react';
import style from './deadline_calculator.module.scss'

import Autocomplete from "./autocomplete";
import DatePicker from 'react-datepicker'
import "react-datepicker/dist/react-datepicker.css";

import createSpinner from './loading'
import DeadlineResults from "./deadline_results";

const Loading = createSpinner(DeadlineResults)

// https://learnetto.com/blog/react-form-validation
class DeadlineCalculator extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      startDate: new Date(), //CHANGE TO notificationDate
      municipality: '',
      workDays: 0,
      formErrors: {email: '', password: ''},
      formValid: false,
      loading: false,
    }
  }

  modifyState(changes){
    this.setState({
      ...this.state,
      ...changes
    })
  }

  setStartDate(value) {
    this.modifyState({startDate:value})
  }
  setMunicipality(value) {
    this.modifyState({municipality: value})
  }
  setworkDays(value) {
    this.modifyState({workDays: value})
  }

  handleSubmit(event){

    event.preventDefault()
    this.modifyState({loading: true})

    this.launchRequest()
  }

  launchRequest(){
    const delay = 1000
    let p = new Promise(function(resolve) {
      setTimeout(resolve, delay);
      });
    
    p.then( () => {
      console.log('resolved')
      this.modifyState({loading: false})
    }).catch( () => {
      this.modifyState({loading: null})
      console.log('Error tremendo')
    })
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

              <button id="btnLogin" type="submitQUITAR" 
                className="btn btn-success btn-lg btn-block">
                Calcular
              </button>
            </form>
            <Loading loading={this.state.loading} results={'banana'}/>
          </div>
          
        </div>
      </div>
    )
  }
}

export default DeadlineCalculator;