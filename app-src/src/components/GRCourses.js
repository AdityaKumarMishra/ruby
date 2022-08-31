import React, { Component, PropTypes } from 'react'
import classnames from 'classnames'

class GRCourses extends Component {
  static propTypes = {

  }

  render() {

    const coursesData = [
      {
        header: 'Interview',
        course: ' & GAMSAT',
        subheader: '',
        description: ' Comprehensive and widely-used Graduate Medical School Admissions Test (GAMSAT',
        preparation_txt: ") preparation course.",
        link: '/gamsat-preparation-courses'
      },
      {
        header: 'UMAT',
        subheader: '',
        description: ' Technologically advanced and personalized Undergraduate Medical Admissions Test (UMAT',
        preparation_txt: ") preparation course.",
        link: '/umat-preparation-courses'
      }
//      {
//        header: 'VCE Ready',
//        subheader: 'VCE Courses',
//        description: 'Prepare with methods and web based tools in sync with 2016.',
//        link: '/vce'
//      },
//      {
//        header: 'HSC Ready',
//        subheader: 'HSC Courses',
//        description: 'Using the latest education technology and pedagogy to achieve results.',
//        link: '/hsc'
//      }
    ]

    const courses = coursesData.map((course, index) => {

      return (
        <li key={index} className="gr-courses__course">
          <a href={course.link} className="gr-courses__course-content">
            <p>
              {course.description}
              <sup style={{top: '-0.5em',left: '0px'}}>®</sup>
              {course.preparation_txt}
            </p>
            <div className="gr-courses__course-name">
              <h3>
                {course.header}
                {course.course}
                <sup style={{top: '-0.7em',left: '0px',fontSize: '59%',}}>®</sup>
                Courses
              </h3>
              <span>
                {course.subheader}
              </span>
            </div>
          </a>
        </li>
      )
    })

    return (
      <div className="gr-courses">
        <h1 className="gr-courses__header">
          <span>GAMSAT<sup style={{top: '-0.5em',left: '0px'}}>®</sup></span> Courses & <span className="umat_heading">UMAT<sup style={{top: '-0.5em',left: '0px'}}>®</sup> </span>Courses at <span>Grad</span>Ready
        </h1>
        <div className="gr-courses__courses">
          <ul>
            {courses}
          </ul>
        </div>
      </div>
    )
  }
}

export default GRCourses
