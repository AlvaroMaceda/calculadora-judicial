import React from 'react';
import { Component } from 'react';
import style from './deadline_calculator.module.scss'

import DatePicker from 'react-datepicker'
import "react-datepicker/dist/react-datepicker.css";

import createLoading from './loading'
import DeadlineResults from "./deadline_results";
import Municipality from './municipality'

const Loading = createLoading(DeadlineResults)

// https://learnetto.com/blog/react-form-validation
class DeadlineCalculator extends Component {

  constructor (props) {
    super(props);    
    this.state = {
      startDate: new Date(), //CHANGE TO notificationDate
      municipality: null,
      workDays: 20,
      formErrors: {email: '', password: ''},
      formValid: false,
      loading: null,
    }
  }

  modifyState(changes){
    this.setState({
      ...this.state,
      ...changes
    })
  }

  setStartDate(date) {
    this.modifyState({startDate:date, loading: null})
  }
  setMunicipality(municipality) {
    this.modifyState({municipality: municipality, loading: null})
  }
  setworkDays(workDays) {
    if(workDays !== '' && isNaN(Number(workDays))) return
    this.modifyState({workDays: workDays, loading: null})
  }

  componentDidUpdate(prevProps, prevState) {
    if(!this.dataHasChanged(prevState,this.state)) return
    if(this.validForm()) this.launchRequest()
  }

  dataHasChanged(previous, current) {
    return (
      previous.startDate !== current.startDate ||
      previous.municipality !== current.municipality ||
      previous.workDays !== current.workDays
    )
  }

  validForm() {
    return this.validStartDate() && this.validMunicipality() && this.validWorkDays()
  }

  validStartDate() {
    return this.state.startDate !== null
  }

  validMunicipality() {
    return this.state.municipality !== null
  }

  validWorkDays() {
    return this.state.workDays!=='' && !isNaN(Number(this.state.workDays))
  }

  handleSubmit(event){
    event.preventDefault()
  }

  launchRequest(){

    console.log('should launch request')
    return

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
            <form className="form" role="form" autoComplete="off" id="loginForm" noValidate="" onSubmit={(e)=>e.preventDefault()}>

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
                <Municipality 
                  onChange={ (municipality) => this.setMunicipality(municipality) }
                />
                <div className="invalid-feedback">Por favor, introduzca un municipio correcto</div>
              </div>

              <div className="form-group">
                <label>Días hábiles</label>
                <input id="workDays" type="text" pattern="[0-9]*"
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
            <h3>Loading: {this.state.loading?'Si':'no'}</h3>
            <Loading loading={this.state.loading} results={'banana'}/>
          </div>
          
        </div>
      </div>
    )
  }
}

export default DeadlineCalculator;