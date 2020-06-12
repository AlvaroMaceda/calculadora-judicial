import React from 'react'
import { Component } from 'react';
import ReactDOM from "react-dom";
import Month from './calendar_month'
import style from './calendar.module.scss'
import moment from 'moment'
moment.locale('es');

// https://blog.flowandform.agency/create-a-custom-calendar-in-react-3df1bfd0b728

function getMonthsToDraw(from, to) {

  let months = []

  const fromDate = moment(from,"YYYY-MM")
  const toDate = moment(to,"YYYY-MM")

  let currentDate = moment(fromDate)
  while(currentDate <= toDate) {
    months.push({
      year: currentDate.year(),
      month: currentDate.month()+1 // Month expects the "human" month number
    })
    currentDate.add(1,'month')
  }

  return months
}




function measureElement(element) {
  const DOMNode = ReactDOM.findDOMNode(element);

  let style = getComputedStyle(DOMNode);
  let margin = {
    top: parseInt(style.marginTop) || 0,
    left: parseInt(style.marginLeft) || 0,
    bottom: parseInt(style.marginBottom) || 0,
    right: parseInt(style.marginRight) || 0
  }
  let padding = {

  }
  return {
    width: DOMNode.offsetWidth, // Este sería el total
    height: DOMNode.offsetHeight,
    // Me falta el de la parte cliente (clientWidth sin padding)
    // width: DOMNode.width,
    // height: DOMNode.height,
    margin: margin
  };
}

class Calendar extends Component {

  constructor(props){
    super(props)
  }

  updateDimensions() {
    this.containerSize = measureElement(this.container)
    this.monthSize = measureElement(this.monthRef)
    console.log('container size:',this.containerSize)
    console.log('month size:',this.monthSize)
  }

  componentDidMount() {
    this.updateDimensions();
    window.addEventListener("resize", this.updateDimensions.bind(this));
    // this.setState({random: Math.random()})
  }

  componentWillUnmount() {
    window.removeEventListener("resize", this.updateDimensions.bind(this));
  }

  componentDidUpdate(){
    console.log('componentDidUpdate')
    this.updateDimensions();
  }

  renderMonths(months) {
    return months.map(month => 
      <Month key={`${month.year}${month.month}`}
             year={month.year} 
             month={month.month}
             ref={r => this.monthRef = r}
      />
    )
  }

  render() {
    let months = getMonthsToDraw(this.props.from, this.props.to)

    return (
      <div className={style.calendar}
           ref={element => {this.container = element;}}
      >
        { this.renderMonths(months) }
      </div>
    )
  }

}

export default Calendar;