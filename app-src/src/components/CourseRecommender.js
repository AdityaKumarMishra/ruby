import React, { Component, PropTypes } from 'react'
import { render } from 'react-dom'
import ReactStars from 'react-stars'
import classnames from 'classnames'
import { setCookie, getCookie } from '../utils'
import { steps } from '../data/crSteps'
import { GAMSATlinks,
         IRlink,
         UMATlinks,
         VCEengLinks,
         VCEmathLinks,
         HSCengLinks,
         HSCmathLinks } from '../data/crLinks'
let averageScoreIncreses
let courseName
let recommendedCrName

class CourseRecommender extends Component {

  state = {
    course_name:'skip',
    recommendedCourseName: '',
    enable: false,
    currentStep: 0,
    mainSelectedAnswer: '',
    mainColor: '#007833',
    mainSubAnswer: '',
    additionalSelectedAnswers: [
      ,
      ,
      {
        value: null,
        weights: null
      },
      {
        value: null,
        weights: null
      },
      {
        value: null,
        weights: null
      },
      {
        value: null,
        weights: null
      },
      {
        value: null,
        weights: null
      },
      {
        value: null,
        weights: null
      },
      {
        value: null,
        weights: null
      },
      {
        value: null,
        weights: null
      }
    ],
    recommendations: {
      'OE': 0,
      'OC': 0,
      'AE': 0,
      'AC': 0,
      'ACT': 0,
      'C': 0
    }
  }

  toggleWindow = () => {
    if(this.state.currentStep >= 8){
      this.setState({
       course_name: localStorage.getItem("courseName")
      })
    }
    $("#course-recommender .cr").removeClass("cr--on")
    this.setState({
      enable: !this.state.enable
    })

    const bodyElem = document.querySelector('body')
    const htmlElem = document.querySelector('html')
    /*bodyElem.classList.toggle('fixxxed')
    htmlElem.classList.toggle('fixxxed')*/
    this.setCookie()
    this.courseRecommenderApi()
  }

  courseRecommenderApi(){
    let con = this.state.course_name == undefined ? localStorage.getItem("courseName"):this.state.course_name
    let product_line = localStorage.getItem("product_line")
    $.ajax({
      url: '/course_recommender_usages/tracking',
      Type: "GET",
      data: {course_name: con,product_line: product_line}
    });
  }

  selectMainAnswer = (answer) => {
    localStorage.setItem("product_line", answer)
    const { currentStep } = this.state
    let stepsToMove = 1
    let mainColor

    if (currentStep == 0) {
      switch (answer) {
        case 'Interview Ready':
        case 'GAMSAT':
          stepsToMove = 2
          mainColor = '#007833'
          break
        case 'UCAT':
          stepsToMove = 2
          mainColor = '#007ecc'
          break
        case 'VCE':
          mainColor = '#462C9f'
          break
        case 'HSC':
          mainColor = '#be382a'
          break
      }

      this.setState({
        mainSelectedAnswer: answer,
        mainColor: mainColor
      }, () => this.moveToNextStep(stepsToMove))

    } else if (currentStep == 1) {
      this.setState({ mainSubAnswer: answer }, () => this.moveToNextStep(stepsToMove))
    }
  }

  moveToNextStep = (value) => {
    if(this.state.currentStep == 0){
      this.setState({
        course_name: 'skip'
      })
    }else if(this.state.currentStep >= 8){
      this.setState({
        course_name: localStorage.getItem("courseName")
      })
    }else{
      this.setState({
        course_name: 'incomplete'
      })
    }
    const { mainSelectedAnswer } = this.state
    let nextStep = this.state.currentStep + value

    // 3 and 8 questions are only for 'GAMSAT'
    if ((nextStep == 2 || nextStep == 7) && mainSelectedAnswer !== 'GAMSAT') {
      if (value > 0) nextStep += 1
      if (value < 0) nextStep -= 1
    }

    if (nextStep > 0 && nextStep < 10) {
      this.setState({ currentStep: nextStep })
    }
  }

  selectAdditionalAnswer = (indexOfSelectedAnswer, answerWeights) => {
    const { additionalSelectedAnswers, currentStep } = this.state

    const newAnswer = {
      value: indexOfSelectedAnswer,
      weights: answerWeights
    }

    const answers = additionalSelectedAnswers.slice()
    answers[currentStep] = newAnswer

    this.setState({
      additionalSelectedAnswers: answers
    }, () => this.moveToNextStep(1))
  }

  setCookie = () => {
    setCookie('course-recommender-dont-show', 'enable', {
      expires: 86400*30
    })
  }

  dontShow = () => {
    this.toggleWindow()
  }

  componentDidMount() {
    const appearance = sessionStorage.getItem('course-recommender-appearance')
    const dontShow = getCookie('course-recommender-dont-show')

    if (appearance !== 'appeared' && dontShow !== 'enable') {
      setTimeout(this.toggleWindow, 6000)
      sessionStorage.setItem('course-recommender-appearance', 'appeared')
    }
  }

  componentWillMount() {
    let courseFromURL = window.location.pathname.split('/')
    courseFromURL = courseFromURL[courseFromURL.length - 1].toUpperCase()
    switch (courseFromURL) {
      case 'GAMSAT':
      case 'UMAT':
      case 'HSC':
      case 'VCE':
       this.selectMainAnswer(courseFromURL)
    }
  }

  render() {
    const courseNames = {
      'OE': 'Online (Essentials)',
      'OC': 'Online (Comprehensive)',
      'AE': 'Attendance (Essentials)',
      'AC': 'Attendance (Comprehensive)',
      'ACT': 'Attendance (Complete Care)',
      'C': 'Custom'
    }

    const averageScorelist = {
      OE: 'from 59.9 to 66.7',
      OC: 'from 58.2 to 62.4',
      AE: 'from 58.9 to 64.5',
      AC: 'from 58.5 to 63.9',
      ACT: 'from 56.8 to 62.7',
      C: 'from 56.8 to 62.7'
    }

    var render_stars
    if(localStorage.getItem("product_line") == 'GAMSAT'){
      var star_class = localStorage.getItem("courseName") == 'GAMSAT: Custom' ? 'fa fa-star-o fa-1.5x icon-green': "fa fa-star-half-o fa-1.5x icon-green"
      render_stars = <div className="starmg_left10">
                <span><i className="fa fa-star  fa-1.5x icon-green" aria-hidden="true"></i></span>
                <span><i className="fa fa-star  fa-1.5x icon-green" aria-hidden="true"></i></span>
                <span><i className="fa fa-star  fa-1.5x icon-green" aria-hidden="true"></i></span>
                <span><i className="fa fa-star  fa-1.5x icon-green" aria-hidden="true"></i></span>
                <span><i className={star_class} aria-hidden="true"></i></span>
              </div>
    }

    const { enable, mainSelectedAnswer, currentStep, additionalSelectedAnswers, recommendations, mainSubAnswer, mainColor } = this.state
    recommendedCrName = localStorage.getItem("recommendedCr")
    const stepData = steps[currentStep]
    const finalStep = steps.length

    var averageScoreCalculated = 'Average score increases ' + averageScorelist['ACT']
    const stars = currentStep === finalStep ? render_stars: ''
    const question = currentStep === finalStep ? 'Appropriate course for you:' : stepData.question
    const courseReview = currentStep === finalStep && localStorage.getItem("product_line") == 'GAMSAT' ? 'Course Review' : ''
    const averageScore = currentStep === finalStep ? averageScoreCalculated : ''

    let listOfAnswers

    // if not final step
    if (currentStep !== steps.length) {
      let answers = 'answers'

      if (currentStep == 1) {
        if (mainSelectedAnswer == 'HSC') {
          answers += 'A'
        } else if (mainSelectedAnswer == 'VCE') {
          answers += 'B'
        }
      }
      listOfAnswers = stepData[answers].map((answer, index) => {
         let handler
         switch (stepData.type) {
           case 'inline-block':
           case 'block':
             handler = this.selectMainAnswer.bind(this, answer.value)
             break
           case 'radio':
             handler = this.selectAdditionalAnswer.bind(this, index, answer.weights)
             break
         }

         const variantClass = classnames({
           'cr__variant': true,
           'cr__variant--inline-block': stepData.type == 'inline-block',
           'cr__variant--block': stepData.type == 'block',
           'cr__variant--radio': stepData.type == 'radio',
           'cr__variant--radio-blue': stepData.type == 'radio' && mainSelectedAnswer == 'UMAT',
           'cr__variant--radio-purple': stepData.type == 'radio' && mainSelectedAnswer == 'VCE',
           'cr__variant--radio-red': stepData.type == 'radio' && mainSelectedAnswer == 'HSC',
           'cr__variant--selected': currentStep > 1 && index == additionalSelectedAnswers[currentStep].value,
           'cr__variant--selected-blue': mainSelectedAnswer == 'UMAT' && currentStep > 1 && index == additionalSelectedAnswers[currentStep].value,
           'cr__variant--selected-purple': mainSelectedAnswer == 'VCE' && currentStep > 1 && index == additionalSelectedAnswers[currentStep].value,
           'cr__variant--selected-red': mainSelectedAnswer == 'HSC' && currentStep > 1 && index == additionalSelectedAnswers[currentStep].value,


        })

         const bg = stepData.type == 'block' ? {backgroundColor: this.state.mainColor} : null

         return (
           <li className={variantClass} key={index} onTouchTap={handler} style={bg}>
             {answer.value}
           </li>
         )
       })

    // if final step
    } else {
      let newRecs = Object.assign({}, recommendations)

      additionalSelectedAnswers.forEach((answer) => {
        for (let course in recommendations) {
          for (let courseWithPoints in answer.weights) {
            if (courseWithPoints === course) {
              newRecs[course] += answer.weights[course]
            }
          }
        }
      })

      let recommendedCourseName = ''
      let recommendedCoursePoints = 0
      let multipleCourses = []

      // find course with max points
      for (let course in newRecs) {
        if (newRecs[course] > recommendedCoursePoints) {
          recommendedCourseName = course
          recommendedCoursePoints = newRecs[course]
        }
      }

      // find another courses with the same points
      for (let course in newRecs) {
        if (newRecs[course] == recommendedCoursePoints && course != recommendedCourseName) {
          multipleCourses.push(course)
        }
      }

      if (multipleCourses.length) {
        multipleCourses.push(recommendedCourseName)
         if (multipleCourses.indexOf('ACT') !== -1) {
           recommendedCourseName = 'ACT'
         } else if (multipleCourses.indexOf('AC') !== -1) {
           recommendedCourseName = 'AC'
         } else if (multipleCourses.indexOf('AE') !== -1) {
           recommendedCourseName = 'AE'
         } else if (multipleCourses.indexOf('OC') !== -1) {
           recommendedCourseName = 'OC'
         } else if (multipleCourses.indexOf('OE') !== -1) {
           recommendedCourseName = 'OE'
         } else if (multipleCourses.indexOf('C') !== -1) {
           recommendedCourseName = 'C'
         }
      }

      let selectedCourseName = mainSelectedAnswer + ': ' + courseNames[recommendedCourseName]
      let courseLink
      let additionalLink = null

      switch (mainSelectedAnswer) {
        case 'Interview Ready':
          selectedCourseName = 'GAMSAT' + ': ' + courseNames[recommendedCourseName]
          averageScoreIncreses = averageScorelist[recommendedCourseName]
          courseLink = GAMSATlinks[courseNames[recommendedCourseName]]
          additionalLink = <a href={IRlink}>Interview Ready: Comprehensive</a>
          break
        case 'GAMSAT':
          courseLink = GAMSATlinks[courseNames[recommendedCourseName]]
          break
        case 'UCAT':
          courseLink =  UMATlinks[courseNames[recommendedCourseName]]
          break
        case 'VCE':
          if (mainSubAnswer.indexOf('Eng') !== -1) {
            courseLink = VCEengLinks[courseNames[recommendedCourseName]]
            break
          } else if (mainSubAnswer.indexOf('Math') !== -1) {
            courseLink = VCEmathLinks[courseNames[recommendedCourseName]]
            break
          }
        case 'HSC':
          if (mainSubAnswer.indexOf('Eng') !== -1) {
            courseLink = HSCengLinks[courseNames[recommendedCourseName]]
            break
          } else if (mainSubAnswer.indexOf('Math') !== -1) {
            courseLink = HSCmathLinks[courseNames[recommendedCourseName]]
            break
          }
      }
      localStorage.setItem("courseName", selectedCourseName)
      localStorage.setItem("recommendedCr", recommendedCourseName)
      var bg_class = localStorage.getItem("product_line")=='GAMSAT' ?'cr__recommendation':'cr__recommendation umat_bg'
      listOfAnswers =
        <li className = {bg_class}>
          <a className="wht_colr" href={courseLink}>{selectedCourseName}</a>
          {additionalLink}
        </li>
    }

    const courseRecommenderClass = classnames({
      'cr': true
    })

    const progressBar = currentStep === steps.length ? null : steps.map((step, index) => {
      const progressItemClass = classnames({
        'cr__progress-item': true,
        'cr__progress-item--filled': index <= currentStep
      })

      const bg = index <= currentStep ? {backgroundColor: mainColor} : null

      return <i key={index} className={progressItemClass} style={bg}/>
    })

    let prevArrow = null
    let nextArrow = null

    const dontShowBtn = currentStep < 4 ? <button onTouchTap={this.dontShow} style={{color: mainColor}}>Don't show me this again</button> : null

    if (currentStep > 1) {

      const leftArrowClass = classnames({
        'cr__nav-arrow': true,
        'cr__nav-arrow--left': true,
        'cr__nav-arrow--hidden': mainSelectedAnswer == 'GAMSAT' ? currentStep == 2 : currentStep == 3
      })

      const rightArrowClass = classnames({
        'cr__nav-arrow': true,
        'cr__nav-arrow--right': true,
        'cr__nav-arrow--hidden': currentStep == finalStep
      })

      prevArrow =
        <div className={leftArrowClass}>
          <button className="cr__btn" onTouchTap={() => this.moveToNextStep(-1)}>Prev</button>
        </div>

      nextArrow =
        <div className={rightArrowClass}>
          <button className="cr__btn" onTouchTap={() => this.moveToNextStep(1)}>Next</button>
        </div>
    }

    return(
      <div className={courseRecommenderClass}>
        <div className="cr__wrapper">
          <div className="cr__header">
            <div className="cr__title">
              <div className="cr__logo">
                <div className="cr__logo-part" />
                <div className="cr__logo-part" />
                <div className="cr__logo-part" />
                <div className="cr__logo-part" />
              </div>
              <b className="cr__title-text">Course Recommender</b>
            </div>
            <div className="cr__close">
              <button className="cr__btn" onTouchTap={this.toggleWindow}>Close</button>
            </div>
          </div>

          <div className="cr__body">

            {prevArrow}

            <div className="cr__content">
              <h2 className="cr__question" key={this.state.currentStep}>{question}</h2>

              <ul className="cr__variant-list" key={this.state.currentStep + 1}>
                {listOfAnswers}
              </ul>

              <div className="cr__progress">
                {progressBar}
              </div>
              <div className="cr__not-to-show-btn">
                {dontShowBtn}
              </div>
              <div className="recomnd_star">
                <div className="star_row">
                  {courseReview}{stars}
                </div>
              </div>
              <div className="avg_score">
                {averageScore}
              </div>
            </div>

            {nextArrow}

          </div>
        </div>
      </div>
    )
  }
}

render(<CourseRecommender />, document.getElementById('course-recommender'))
