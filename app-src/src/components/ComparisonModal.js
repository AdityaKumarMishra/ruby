import React, { Component, PropTypes } from 'react'
import { render } from 'react-dom'
import classnames from 'classnames'
import { setCookie, getCookie } from '../utils'

class ComparisonModal extends Component {
  state = {
    enable: false,
    clonedTable: false,
    courseFromURL: '',
    coreHeading: ''
  }

  toggleWindow = () => {
    this.setState({
      enable: !this.state.enable
    })
    const bodyElem = document.querySelector('body')
    const htmlElem = document.querySelector('html')
    bodyElem.classList.toggle('fixxxed')
    htmlElem.classList.toggle('fixxxed')
    this.setCookie()
  }

   setCookie = () => {
    setCookie('comparison-table-dont-show', 'enable', {
      expires: 86400*30
    })
  }
  dontShow = () => {
    this.toggleWindow()
  }

  componentDidMount() {
    const appearance = sessionStorage.getItem('comparison-table-appearance')
    const dontShow = getCookie('comparison-table-dont-show')

    if (appearance !== 'appeared' && dontShow !== 'enable') {
      this.toggleWindow()
      sessionStorage.setItem('comparison-table-appearance', 'appeared')
    }
  }

  componentWillMount() {
    this.state.courseFromURL = window.location.pathname.split('/')
    this.state.courseFromURL = this.state.courseFromURL[this.state.courseFromURL.length - 1]
    const table = document.querySelector('.' + this.state.courseFromURL + '_comparison_table')
    this.setState({
      clonedTable: table
    })
  }

  createMarkup = () => {
    return {
      __html: this.state.clonedTable.outerHTML || ''
    }
  }

  render() {
    const {coreHeading, enable, clonedTable , courseFromURL} = this.state
    const courseRecommenderClass = classnames({
      'cr': true,
      'cr--on': enable,
      'cm': true
    })

    const dontShowBtn = <button onTouchTap={this.dontShow} style={{color: "#007833"}}>Don't show me this again </button>
    const content = clonedTable ? <div dangerouslySetInnerHTML={this.createMarkup()}/> : null


    if(this.state.courseFromURL=="gamsat"){
      this.state.coreHeading =<h2 className='cr__question'>We are the <a href= 'https://gradready.com.au/gamsat/student_testimonials#student_improved_score' >ONLY provider </a> with  <a href= 'https://gradready.com.au/gamsat/student_testimonials#student_improved_score' >proven results </a> <br/> On average, <a href= 'https://gradready.com.au/gamsat/student_testimonials#student_improved_score'> 3 years in a row </a>, students <a href='https://gradready.com.au/gamsat/student_testimonials#student_improved_score'>improved their scores </a> by <a href='https://gradready.com.au/gamsat/student_testimonials#student_improved_score'>at least 24 percentile points</a> after taking a GradReady course <br/> <a href='https://gradready.com.au/gamsat#student_infographic' >Over 1000 students </a> each year <a href='https://gradready.com.au/gamsat#student_infographic' >trust GradReady </a> with one of the most important exams of their career <br/> See comparison table below and take a <a href ='https://gradready.com.au/gamsat/1-week-trial'>free trial </a> to see why GradReady students do better</h2>;
    }else{
      this.state.coreHeading = <h2>See how we stack up against other education providers</h2>;
    }
    return(
      <div className={courseRecommenderClass}>
        <div className="cr__wrapper cm__wrapper">
          <div className="cr__header">
            <div className="cr__title">
              <b className="cr__title-text">Comparison Table</b>
            </div>
            <div className="cr__close">
              <button className="cr__btn" onTouchTap={this.toggleWindow}>Close</button>
            </div>
          </div>

          <div className="cr__body">

            <div className="cr__content cm__content">
              {this.state.coreHeading}
              {content}
              <div className="cr__not-to-show-btn cm__not-to-show-btn">
                {dontShowBtn}
              </div>
            </div>

          </div>
        </div>
      </div>
    )
  }
}

render(<ComparisonModal />, document.getElementById('comparison-modal'))
