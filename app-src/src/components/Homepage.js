import React, { Component, PropTypes } from 'react'
import Slideshow from './Slideshow'
import Feedbacks from './Feedbacks'
import GRCourses from './GRCourses'
import { render } from 'react-dom'
import { slidesArr } from '../data/homepageSlides'
import { homepageFeedbacks } from '../data/homepageFeedbacks'


class Homepage extends Component {
  static propTypes = {

  }

  render() {
    return (
      <div>
        <GRCourses />
        <Feedbacks homeFeedBack = {homepageFeedbacks} />
      </div>
    )
  }
}

render(<Homepage />, document.getElementById('homepage-component'))
