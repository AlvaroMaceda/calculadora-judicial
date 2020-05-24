import React from 'react';
import { Component } from 'react';
import style from './deadline_calculator.module.scss'

import DatePicker from 'react-datepicker'
import "react-datepicker/dist/react-datepicker.css";

import { Subject } from "rxjs";
import { ajax } from 'rxjs/ajax';
import { switchMap, catchError } from "rxjs/operators";
 

import createLoading from './loading'
import DeadlineResults from "./deadline_results";
import Municipality from './municipality'

const Loading = createLoading(DeadlineResults)


class FormValidator {

  constructor() {
    this._valid = false
  }

  get valid() {
    return this._valid
  }

  validate(state) {
    this._valid = (
      this._validNotification(state.notification) && 
      this._validMunicipality(state.municipality) && 
      this._validWorkDays(state.workDays)
    )
    return this
  }

  _validNotification(notification) {
    return notification !== null
  }

  _validMunicipality(municipality) {
    return municipality !== null
  }

  _validWorkDays(workDays) {
    return workDays!=='' && !isNaN(Number(workDays))
  }
}


// https://learnetto.com/blog/react-form-validation
class DeadlineCalculator extends Component {

  constructor (props) {
    super(props);
    this.validator = new FormValidator()

    this.requests = new Subject()
    this.responses = this.requests.pipe(
      // switchMap will ignore all requests except last one
      switchMap( (url) => ajax(url) ),
      catchError(this.requestError)
    )
    this.responses.subscribe( (data) => this.requestResponse(data))

    this.state = {
      notification: new Date(), //CHANGE TO notificationDate
      municipality: null,
      workDays: 20,
      formErrors: {email: '', password: ''},
      formValid: false,
      loading: null,
    }
  }

  launchRequest_LALALA(){
    console.log('Launching request')
    console.log(this.state)
    
    let notification = this.state.notification.toISOString().substring(0,10)
    let municipality_code = this.state.municipality.value
    let days = this.state.workDays

    let url = `/api/deadline?` + 
      `notification=${notification}`+
      `&municipality_code=${municipality_code}` + 
      `&days=${days}`

    console.log(url)
    this.requests.next(url)
  }
  requestError(error) {
    console.log('EL REQUEST HA PETAO:')
    console.log(error.response.message)
    return 'BANANA'
  }
  requestResponse(data) {
    console.log('Request response')
    console.log(data)
  }

  modifyState(changes){
    this.setState({
      ...this.state,
      ...changes
    })
  }

  setNotification(date) {
    this.modifyState({notification:date, loading: null})
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
    if(this.validForm()) this.launchRequest_LALALA()
  }

  dataHasChanged(previous, current) {
    return (
      previous.notification !== current.notification ||
      previous.municipality !== current.municipality ||
      previous.workDays !== current.workDays
    )
  }

  validForm() {
    return this.validator.validate(this.state).valid
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
            <form className="form" role="form" autoComplete="off" 
                  id="loginForm" noValidate="" 
                  onSubmit={(e)=>e.preventDefault()}>

              <div className="form-group">
                <label>Fecha de notificación</label>
                <div className="row">
                  <div className="col-md-12">
                    <DatePicker
                      className="form-control col-md-12"
                      dateFormat="dd/MM/yyyy"
                      selected={this.state.notification}
                      onChange={date => this.setNotification(date)}
                    />
                  </div>
                </div>
                <div className="invalid-feedback">Please enter a password</div>
              </div> {/*form-group*/}

              <div className="form-group">
                <label htmlFor="municipality" className="lb-lg">Municipio</label>
                <Municipality 
                  onChange={ (municipality) => this.setMunicipality(municipality) }
                />
                <div className="invalid-feedback">Por favor, introduzca un municipio correcto</div>
              </div> {/*form-group*/}

              <div className="form-group">
                <label>Días hábiles</label>
                <input id="workDays" type="text" pattern="[0-9]*"
                  className="form-control" required="" autoComplete="on"
                  value={this.state.workDays}
                  onChange={e => this.setworkDays(e.target.value)}
                />
                <div className="invalid-feedback">Por favor, introduzca un número</div>
              </div> {/*form-group*/}

              {/* <button id="btnLogin" type="submitQUITAR" 
                className="btn btn-success btn-lg btn-block">
                Calcular
              </button> */}
            </form>
            <h3>Loading: {this.state.loading?'Si':'no'}</h3>
            <Loading loading={this.state.loading} results={'banana'}/>

          </div> {/*body*/}
          
        </div> {/*card*/}
      </div> 
    )
  }
}

export default DeadlineCalculator;