import React from "react";
import { useState } from 'react';

import Autocomplete from "./autocomplete";
import DatePicker from 'react-datepicker'
import "react-datepicker/dist/react-datepicker.css";
import style from './deadline_calculator.module.scss'

console.log(style)

function DeadlineCalculator() {

  const [startDate, setStartDate] = useState(new Date());

  return (
    <div className={style.container}>

      <div className={style.card}>

        <div className={style.header}>
          <h3 className="mb-0">Calculadora de plazos judiciales</h3>
        </div>

        <div className={style.body}>
          <form className="form" role="form" autoComplete="off" id="loginForm" noValidate="" method="POST" action="javascript:void(0);">

            <div className="form-group">
              <label htmlFor="municipality" className="lb-lg">Municipio</label>
              <input type="text" className="form-control" name="municipality" id="municipality" required=""></input>
              <div className="invalid-feedback">Por favor, introduzca un municipio correcto</div>
            </div>

            <div className="form-group">
              <label>Fecha de inicio</label>
              <div className="row">
                <div className="col-md-12">
                  <DatePicker
                    className="form-control col-md-12"
                    dateFormat="dd/MM/yyyy"
                    selected={startDate}
                    onChange={date => setStartDate(date)}
                  />
                </div>
              </div>
              <div className="invalid-feedback">Please enter a password</div>
            </div>

            <div className="form-group">
              <label>Días hábiles</label>
              <input type="password" className="form-control" id="pwd1" required="" autoComplete="new-password"></input>
              <div className="invalid-feedback">Por favor, introduzca un número</div>
            </div>

            <button type="submit" className="btn btn-success btn-lg float-right" id="btnLogin">Calcular</button>

          </form>
        </div>
      </div>
    </div>
  );
}

export default DeadlineCalculator;