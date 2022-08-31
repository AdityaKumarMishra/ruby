import React, { Component, PropTypes } from 'react'
import classnames from 'classnames'

class Slideshow extends Component {
  static propTypes = {
    slidesArr: PropTypes.array
  }

  state = {
    selectedSlide: 0,
    prevSelectedSlide: 4,
    changeSlides: null
  }

  componentDidMount() {
    const timerId = setTimeout( () => {
      const changeSlides = setInterval(() => this.slideChange(this.props.slidesArr.length), 5000)

      this.setState({
        changeSlides: changeSlides
      })
    }, 10000)
  }

  componentWillUnmount() {
    clearInterval(this.state.changeSlides)
  }

  slideChange = slidesLength => {
    const { selectedSlide, prevSelectedSlide } = this.state
    let newSlide = selectedSlide + 1
    if (newSlide >= slidesLength) newSlide = 0
    this.setState({
      selectedSlide: newSlide,
      prevSelectedSlide: selectedSlide
    })
  }

  onSlideSelect = index => e => {
    this.setState({
      prevSelectedSlide: this.state.selectedSlide,
      selectedSlide: index
    })
  }

  render() {
    const { selectedSlide, prevSelectedSlide } = this.state

    const { slidesArr } = this.props

    const viewportWidth = Math.max(document.documentElement.clientWidth, window.innerWidth || 0)

    const slides = slidesArr.map((slide, index) => {

      const bg = { backgroundPosition: slide.bgPosition }

      const slideClasses = classnames({
        'slideshow__slide': true,
        'slideshow__slide--homepage': slide.page === 'homepage',
        'slideshow__slide--productline': slide.page === 'productline',
        'slideshow__slide--move-from-right': selectedSlide == index,
        'slideshow__slide--visible': prevSelectedSlide == index
      })

      const slideTextClass = classnames({
        'slideshow__slide-text': true,
        'slideshow__slide-text--homepage': slide.page === 'homepage',
        'slideshow__slide-text--product-line': slide.page === 'productline'
      })

      //const slideTextWidth = viewportWidth >= 1024 && index === 1 ? { width: '52%'} : null

      const slideSubheader = !slide.subheader ? null : <div className="slideshow__slide-subheader">{slide.subheader}</div>
      const slideSubtext = !slide.subtext ? null : <div className="slideshow__slide-subtext">{slide.subtext}</div>

      let slideText
      if (Array.isArray(slide.link)) {
        const linksBlock = slide.link.map((item) => {
          return <div><a href={item.link}>{item.text}</a></div>
        })
        slideText =
          <div>
            <div>
              {slide.text}
            </div>
            {linksBlock}
            {slideSubheader}
            {slideSubtext}
          </div>
      } else {
        slideText =
          <a href={slide.link}>
            <div>
              {slide.text}
            </div>
            {slideSubheader}
            {slideSubtext}
          </a>
      }

      return (
        <div key={index} className={slideClasses} style={bg}>
          <div className={slideTextClass}>
            {slideText}
          </div>
        </div>
      )
    })

    const slideControls = slidesArr.map((slide, index) => {
      const id = 'slide-' + index
      return (
        <div key={index} className="slideshow__control">
          <input type="radio" name="slideshow" id={id} checked={selectedSlide === index} onChange={this.onSlideSelect(index)}/>
          <label htmlFor={id} />
        </div>
      )

    })

    return (
      <div className="slideshow">
        <div className="slideshow__controls">
          {slideControls}
        </div>
        <div className="slideshow__slides">
          {slides}
        </div>
      </div>
    )
  }
}

export default Slideshow
