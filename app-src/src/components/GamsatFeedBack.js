import React, { Component, PropTypes } from 'react'
import { render } from 'react-dom'
import { gamsatFeedbacks } from '../data/gamsatPageFeedback'
import Feedbacks from './Feedbacks'
import { homepageFeedbacks } from '../data/homepageFeedbacks'

class GamsatFeedBack extends Component {
  static propTypes = {
  }

  render() {
    return (
      <div>
        <Feedbacks homeFeedBack = {homepageFeedbacks} />
      </div>
    )
  }
}

render(<GamsatFeedBack />, document.getElementById('react-carousel'))
