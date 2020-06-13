import React from 'react';
import { Component } from 'react';
import style from './deadline_calculator.module.scss'

import DatePicker from 'react-datepicker'
import "react-datepicker/dist/react-datepicker.css";

import { Subject, asyncScheduler } from "rxjs";
import { ajax } from 'rxjs/ajax';
import { switchMap, throttleTime, filter, catchError } from "rxjs/operators";

import { registerLocale, setDefaultLocale } from  "react-datepicker";
import es from 'date-fns/locale/es';
registerLocale('es', es)


import createLoading from './loading'
import DeadlineResults from "./deadline_results";
import Municipality from './municipality'
import Calendar from './calendar'

const Loading = createLoading(DeadlineResults)

const THROTTLE_TIME = 2000

const zeroPad = (num, places) => String(num).padStart(places, '0')
function dateToYYYY_MM_DD(date) {
  return [
    date.getFullYear(),
    zeroPad(date.getMonth()+1,2),
    zeroPad(date.getDate(),2)
  ].join('-')
}

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

const INITIAL_STATE = {

}

class DeadlineCalculator extends Component {

  constructor (props) {

    const INITIAL_STATE = {
      notification: new Date(),
      municipality: null,
      workDays: '',
      formValid: false,
      loading: null, // true: loading. false: lodaded. null: no data available
      results: {},
      formErrors: {email: '', password: ''},
    }

    super(props);

    this.validator = new FormValidator()

    this.requests = new Subject()
    this.responses = this.requests.pipe(
      throttleTime(THROTTLE_TIME, asyncScheduler, {trailing:true}), // {trailing: true} is for launching the last request (that's the request we are interested if)    
      switchMap( (url) => ajax(url) ), // switchMap will ignore all requests except last one
      filter( () => this.validator.valid), // Ignore responses if form is not valid
      catchError(this.requestError)
    )
    this.responses.subscribe( (data) => this.requestResponse(data))

    this.state = INITIAL_STATE
  }

  launchRequest(){
    console.log('Launching request')
    this.modifyState({loading: true})
    
    let notification = dateToYYYY_MM_DD(this.state.notification)
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
    this.modifyState({loading: null})
    return 'BANANA'
  }

  requestResponse(data) {
    console.log('Request response')
    console.log(data.response)
    this.modifyState({
      loading: false,
      results: data.response
    })
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
    if(this.validForm()) this.launchRequest()
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

  render() {
    return (
      <div className={style.container}>

          <Calendar
            from='2020-12'
            to='2021-05'
            markStyles={{
              foo: {background: 'red', color: 'yellow'},
              bar: { background: 'orange', color: 'green'},
              tee: {background: 'salmon', color: 'white'}
            }}
            markDays= {[
              {'2020-12-07': 'tee'},
              {'2020-12-25': {background: 'salmon', color: 'white'}},
              {'2021-01-01': {background: 'teal', color: 'red'}},
              {'2021-01-06': {background: 'yellow', color: 'purple'}}
            ]}
          />

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
                      locale="es"
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

            </form>
            <Loading loading={this.state.loading} results={this.state.results}/>

          </div> {/*body*/}
          
        </div> {/*card*/}

        
      </div>
    )
  }
}

export default DeadlineCalculator;