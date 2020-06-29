import React from 'react';
import { Component } from 'react';
import style from './deadline_calculator.module.scss'

import DatePicker from 'react-datepicker'
import "react-datepicker/dist/react-datepicker.css";

import { Subject, asyncScheduler, of } from "rxjs";
import { ajax } from 'rxjs/ajax';
import { switchMap, throttleTime, filter, catchError } from "rxjs/operators";

import { registerLocale, setDefaultLocale } from  "react-datepicker";
import moment from 'moment'

// import 'bootstrap'
// import '../stylesheets/application.scss'

moment.locale('es')
// TO-DO: remove this and change for moment
import es from 'date-fns/locale/es';
registerLocale('es', es)


import createLoading from './loading'
import DeadlineResults from "./results/deadline_results";
import Municipality from './municipality'


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

const RESULT_STATE = {
  NO_DATA: null,
  LOADING: true,
  DATA_RECEIVED: false
}

const NO_RESPONSE_AVAILABLE = {
  resultsState: RESULT_STATE.NO_DATA,
  requestError: null
}

class DeadlineCalculator extends Component {

  constructor (props) {

    const INITIAL_STATE = {
      notification: new Date(),
      municipality: null,
      workDays: '',
      formValid: false,
      resultsState: RESULT_STATE.NO_DATA, 
      results: {},
      formErrors: {email: '', password: ''},
      requestError: null
      // requestError: 'Error en la consulta del vencimiento'
    }

    super(props);

    this.validator = new FormValidator()

    this.requests = new Subject()
    this.subscribeToCalculations()

    this.state = INITIAL_STATE
  }

  launchRequest(){
    if(! this.validForm()) return

    console.log('Launching request')
    this.modifyState({resultsState: RESULT_STATE.LOADING})
    
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

  subscribeToCalculations() {
    this.requests.pipe(
      throttleTime(THROTTLE_TIME, asyncScheduler, {trailing:true}), // {trailing: true} is for launching the last request (that's the request we are interested if)    
      switchMap( (url) => ajax(url) ), // switchMap will ignore all requests except last one
      filter( () => this.validator.valid), // Ignore responses if form is not valid
      // catchError(this.calculationError.bind(this))
    ).subscribe( 
      (data) => this.calculationResponse(data),
      (error) => this.calculationError(error)
    )
  }

  calculationError(error) {
    // TO-DO: show some error message
    console.log('EL REQUEST HA PETAO:')
    console.log(error.response.message)
    this.modifyState({
      resultsState: RESULT_STATE.NO_DATA,
      requestError: error.response.message
    })
    // We must resubscribe because the original subscription has errored out and isn't valid anymore
    this.subscribeToCalculations()
    // return of({error:true})
  }

  calculationResponse(data) {
    console.log('Request response')
    console.log(`error: ${data.error}`)
    if(data.error) return
    console.log(data.response)
    this.modifyState({
      resultsState: RESULT_STATE.DATA_RECEIVED,
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
    this.modifyState({notification:date, ...NO_RESPONSE_AVAILABLE})
  }

  setMunicipality(municipality) {
    this.modifyState({municipality: municipality, ...NO_RESPONSE_AVAILABLE})
  }

  setworkDays(workDays) {
    if(workDays !== '' && isNaN(Number(workDays))) return
    this.modifyState({workDays: workDays, ...NO_RESPONSE_AVAILABLE})
  }

  componentDidUpdate(prevProps, prevState) {
    if(!this.dataHasChanged(prevState,this.state)) return
    this.launchRequest()
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

  renderRequestError() {
    if(!this.state.requestError) return
    return (
      <div className="alert alert-danger" role="alert">
          <strong>Error en la consulta: </strong>{this.state.requestError}
      </div>
    )
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
            {this.renderRequestError()}
            <Loading loading={this.state.resultsState} results={this.state.results}/>
            {/* <DeadlineResults 
              results={
                // Los datos son inventados
                {
                  "municipality_code":"ES46250",
                  "notification":"2020-03-17",
                  "days":5,
                  "deadline":"2020-04-28",
                  // "deadline":"2020-03-23",
                  "holidays":[
                    {"date":"2020-03-19","kind":"country","territory":"Spain"},
                    {"date":"2020-03-24","kind":"country","territory":"Spain"},
                    {"date":"2020-03-27","kind":"municipality","territory":"Valencia"},
                    {"date":"2020-04-08","kind":"island","territory":"Lanzarote"},
                    {"date":"2020-04-13","kind":"local_entity","territory":"El Perelló"}
                    ],
                  "missing_holidays":[
                    {"territory":"Jaén","year":2020},
                    {"territory":"Jaén","year":2021},
                    {"autonomous_community":"Andalucía","year":2020}
                  ]
                }
              }
            /> */}

          </div> {/*body*/}
          
        </div> {/*card*/}



      </div>
    )
  }
}

export default DeadlineCalculator;