import React, { Component, PropTypes } from 'react'
import classnames from 'classnames'

class Feedback extends Component {
  static propTypes = {

  }

  state = {
    selectedFeedback: 0,
    prevSelectedFeedback: 0
  }

  onFeedbackChange = (direction, feedbacks) => e => {
    const { selectedFeedback } = this.state
    const lastElementPosition = feedbacks.length - 1

    let position
    let newFeedbackPosition

    if (direction === 'top') {
      position = selectedFeedback - 1
      newFeedbackPosition = position >= 0 ? position : lastElementPosition
    } else if (direction === 'bottom') {
      position = selectedFeedback + 1
      newFeedbackPosition = position <= lastElementPosition ? position : 0
    }
    this.setState({
      prevSelectedFeedback: selectedFeedback,
      selectedFeedback: newFeedbackPosition
    })
  }

  render() {
    const { selectedFeedback, prevSelectedFeedback } = this.state
    var _feedbackText
    var _sup
    const feedbacksElements = this.props.homeFeedBack.map((feedback, index) => {
      const author = ' – ' + feedback.author
      _feedbackText = feedback.text.split("®")
      if(feedback.text.includes("GAMSAT")){
        _sup = <sup style={{top: '-0.5em',left: '0px'}}>®</sup>
      }else{
        _sup = ''
      }
      if(this.props.gamsatPage){
        return (
          <div key={index} className="feedback__item">
            <p className="jamset">
              <a href="gamsat/student_testimonials#my_clas">{feedback.text}
                <span>{author}</span>
              </a>
            </p>
          </div>
        )
      }else{
        return (
          <div key={index} className="feedback__item">
            <p>
              {_feedbackText[0]}
              {_sup}
              {_feedbackText[1]}
              <span>{author}</span>
            </p>
          </div>
        )
      }
    })

    const feedbackMoving = {
      top: '-' + selectedFeedback + '00%'
    }

    return (
      <div className="feedback cstm-carousel-wrap">
        <div className="container caraousel-wrap-in">
          <div className="row-fluid">
            <div className="span6 offset3">
              <div id="myCarousel" className="carousel slide vertical">
                <div className="carousel-inner">
                  <div className="active item">
                    {feedbacksElements[0]}
                  </div>
                  <div className="item">
                    {feedbacksElements[1]}
                  </div>
                  <div className="item">
                    {feedbacksElements[2]}
                  </div>
                  <div className="item">
                    {feedbacksElements[3]}
                  </div>
                  <div className="item">
                    {feedbacksElements[4]}
                  </div>
                </div>
              </div>
            </div>
            <div className="feedback__controls">
              <a href="#myCarousel" className="cstm-arrow"  data-slide="next">
                <span className="top_arrow">
                  <svg version="1.1" className="feedback__control-up" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlnsXlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                    viewBox="0 0 404.258 404.258" xmlSpace="preserve">
                    <polygon points="289.927,18 265.927,0 114.331,202.129 265.927,404.258 289.927,386.258 151.831,202.129 "/>
                  </svg>
                </span>
              </a>
              <a href="#myCarousel" className="cstm-arrow" data-slide="prev">
                <span className="down_arrow">
                  <svg version="1.1" className="feedback__control-down" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlnsXlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                    viewBox="0 0 404.258 404.258" xmlSpace="preserve">
                    <polygon points="289.927,18 265.927,0 114.331,202.129 265.927,404.258 289.927,386.258 151.831,202.129 "/>
                  </svg>
                </span>
              </a>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default Feedback
