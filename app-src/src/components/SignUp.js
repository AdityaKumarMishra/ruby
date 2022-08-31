import React, { Component, PropTypes } from 'react'
import { render } from 'react-dom'
import { getMetaContent } from '../utils'
import classnames from 'classnames'
import SignUpStep from './SignUpStep'
import PaymentStep from './PaymentStep'
import ReceiptStep from './ReceiptStep'

class SignUp extends Component {
  static propTypes = {

  }

  componentWillMount() {
    const { userFName, userLName, userPhone, userEmail, paymentDate } = this.state

    $.ajax({
      method: 'GET',
      url: '/auth/is_signed_in.json'
    })
    .done(response => {
      if (response.signed_in) {
        this.setState({
          userId: response.user.id,
          signedIn: response.signed_in,
          userFName: {
            ...userFName,
            value: response.user.first_name
          },
          userLName: {
            ...userLName,
            value: response.user.last_name
          },
          userPhone: {
            ...userPhone,
            value: response.user.phone_number
          },
          userEmail: {
            ...userEmail,
            value: response.user.email
          }
        })
      }
    })
    .fail(error => {
      this.setErrorMessage('We are sorry but server responded with error. \nPlease, contact us about it or try this operation later.')
    })

    this.setState({
      authToken: getMetaContent('csrf-token')
    })
  }

  componentDidUpdate(prevProps, prevState) {
    if (!prevState.signedIn && this.state.signedIn) {
      this.setState({
        currentStep: 1
      })
    }
  }

  state = {
    signedIn: false,
    orderId: null,
    currentStep: 0,
    userId: null,
    agreement: false,
    authToken: null,
    errorMessage: '',
    order: {
      course: '',
      city: '',
      closureDate: '',
      price: ''
    },
    paymentType: {
      value: 'online'
    },
    userName: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userPwd: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userPwdConf: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userEmail: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userFName: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userLName: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userPhone: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userPostcode: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userSuburb: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userAddress: {
      value: '',
      valid: false,
      wasFocused: false,
      message: ''
    },
    userState: {
      value: 1
    },
    userCountry: {
      value: 0
    }
  }

  saveOrderData = (element, data) => {
    this.setState({
      [element]: data
    })
  }

  onSignUpSubmit = e => {
    e.preventDefault()
    const { userName, userPwd, userPwdConf, userEmail, userPhone, userFName, userLName, userPostcode, userAddress, userSuburb, userState, userCountry } = this.state

    if (userName.value && userName.valid &&
        userPwd.value && userPwd.valid &&
        userPwdConf.value && userPwdConf.valid &&
        userEmail.value && userEmail.valid &&
        userPhone.value && userPhone.valid &&
        userFName.value && userFName.valid &&
        userLName.value && userLName.valid &&
        userPostcode.value && userPostcode.valid &&
        userSuburb.value && userSuburb.valid &&
        userAddress.value && userAddress.valid) {

      // registration
      $.ajax({
        method: 'POST',
        url: '/auth.json',
        data: {
          user: {
            username: userName.value,
            password: userPwd.value,
            password_confirmation: userPwdConf.value,
            first_name: userFName.value,
            last_name: userLName.value,
            email: userEmail.value,
            phone_number: userPhone.value,
        		address_attributes: {
        			line_one: userAddress.value,
        			line_two: '',
        			suburb: userSuburb.value,
        			post_code: userPostcode.value,
        			state: +userState.value,
        			country: +userCountry.value
        		}
          },
          authenticity_token: getMetaContent('csrf-token')
        }
      })
      .done(response => {
        this.setState({
          currentStep: 1,
          userId: response.id
        })
      })
      .fail(error => {
        const signUpFieldsAccordance = {
          username: 'userName',
          password: 'userPwd',
          password_confirmation: 'userPwdConf',
          first_name: 'userFName',
          last_name: 'userLName',
          email: 'userEmail',
          phone_number: 'userPhone'
        }

        const errors = JSON.parse(error.responseText).errors

        for (let key in errors) {

          let errorMessage = ''
          errors[key].forEach((error) => {
            const firstLetter = error[0].toUpperCase()
            errorMessage += firstLetter + error.slice(1) + '. '
          })

          const element = signUpFieldsAccordance[key]

          this.setState({
            [element]: {
              ...this.state[element],
              valid: false,
              message: errorMessage
            }
          })
        }

      })
    }
  }

  onBankPaymentSubmit = e => {
    e.preventDefault()
    $.ajax({
      url: '/orders/' + this.state.orderId + '/direct_complete.json',
      method: 'POST'
    })
    .done(response => {
      this.setState({
        currentStep: 2,
        paymentDate: response.payment_date
      })
    })
    .fail(error => {
      this.setErrorMessage('We are sorry but server responded with error after checking bank payment. \nPlease, contact us about it or try this operation later.')
    })
  }

  onSelectChange = element => e => {
    const { userCountry, userState } = this.state
    const value = e.target.value

    if (element == 'userCountry' && value != 0) {
      this.setState({
        userState: {
          value: 0
        },
        userCountry: {
          value: value
        }
      })
    } else if (element == 'userState' && userCountry.value != 0) {
      this.setState({
        userState: {
          value: 0
        }
      })
    } else {
      this.setState({
        [element]: {
          value: value
        }
      })
    }
  }

  onInputChange = element => e => {
    const valueToString = '' + e.target.value
    // max length 100 symbols
    if (valueToString.length <= 100) {
      this.setState({
        [element]: {
          ...this.state[element],
          value: e.target.value
        }
      })
    }
  }

  onPaymentTypeChange = element => e => {
    this.setState({
      [element]: {
        ...this.state[element],
        value: e.target.value
      }
    })
  }

  onSignUpInputBlur = element => e => {
    const value = e.target.value
    let isValid
    let message = ''

    switch (element) {
      case 'userName':
        isValid = value && value.match(/^[a-z0-9]+$/i) ? true : false
        if (!isValid) message = 'Only numbers and letters are alowed.'
        break
      case 'userPwd':
        isValid = value && value.length > 7 ? true : false
        if (!isValid) message = 'Password length must be at least 8 characters.'
        break
      case 'userPwdConf':
        isValid = value && value === this.state.userPwd.value ? true : false
        if (!isValid) message = 'Must be the same as password.'
        break
      case 'userEmail':
       isValid = value && value.match(/^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i) ? true : false
       if (!isValid) message = 'Not valid email address.'
       break
      case 'userFName':
        isValid = value && value.match(/^[a-z '-]+$/i) ? true : false
        if (!isValid) message = 'Only letters are alowed.'
        break
      case 'userLName':
        isValid = value && value.match(/^[a-z '-]+$/i) ? true : false
        if (!isValid) message = 'Only letters are alowed.'
        break
      case 'userPhone':
        isValid = value && value.match(/^[0-9]+$/) ? true : false
        if (!isValid) message = 'Only numbers are alowed.'
        break
      case 'userPostcode':
        isValid = value && value.match(/^[0-9]+$/) ? true : false
        if (!isValid) message = 'Only numbers are alowed.'
        break
      case 'userSuburb':
        isValid = value && value.match(/^[a-z -,]+$/i) ? true : false
        if (!isValid) message = 'Only letters are alowed.'
        break
      case 'userAddress':
        isValid = value ? true : false
        break
    }

    if (!value.length) {
      message = 'Empty field.'
    }

    this.setState({
      [element]: {
        value: value,
        valid: isValid,
        wasFocused: true,
        message: message
      }
    })
  }

  agreementOnChange = () => {
    this.setState({
      agreement: !this.state.agreement
    })
  }

  setErrorMessage = message => {
    this.setState({
      errorMessage: message
    })
    window.scrollTo(0, 0)
  }

  render() {

    const { currentStep, userId, orderId, authToken, errorMessage,
            userName, userPwd, userPwdConf, userEmail, userFName, userLName, userPhone, userPostcode, userSuburb, userAddress, userState, userCountry,
            agreement, paymentType, order, paymentDate } = this.state

    const signUpState = {
      userName, userPwd, userPwdConf, userEmail, userFName, userLName, userPhone, userPostcode, userSuburb, userAddress, userState, userCountry
    }

    const dataForPaymentStep = {
      userFName, userLName, userPhone, userEmail, agreement, paymentType, order
    }

    const stepInfo = [
      {
        name: 'Sign up',
        tip: 'Register to sign in'
      },
      {
        name: 'Payment',
        tip: 'Choose payment'
      },
      {
        name: 'Receipt',
        tip: 'Review payment'
      }
    ]

    const stepHeaders = stepInfo.map((step, index) => {
      const stepHeaderClass = classnames({
        'su__step-header': true,
        'su__step-header--active': index == currentStep
      })

      return (
        <div key={index} className={stepHeaderClass}>
          <div className="su__step-name">{step.name}</div>
          <div className="su__step-tip">{step.tip}</div>
        </div>
      )
    })


    let activeStep
    switch (currentStep) {
      case 0:
        activeStep = <SignUpStep
          signUpState={signUpState}
          onInputChange={this.onInputChange}
          onSelectChange={this.onSelectChange}
          onSignUpSubmit={this.onSignUpSubmit}
          onSignUpInputBlur={this.onSignUpInputBlur}
          />
        break
      case 1:
        activeStep = <PaymentStep
          dataForPaymentStep={dataForPaymentStep}
          onBankPaymentSubmit={this.onBankPaymentSubmit}
          agreementOnChange={this.agreementOnChange}
          onPaymentTypeChange={this.onPaymentTypeChange}
          setErrorMessage={this.setErrorMessage}
          userId={userId}
          saveOrderData={this.saveOrderData}
          orderId={orderId}
          authToken={authToken}
          />
        break
      case 2:
        activeStep = <ReceiptStep
          order={order}
          paymentType={paymentType}
          paymentDate={paymentDate}
          />
        break
    }

    const errorMessageBlock = !errorMessage ? null :
      <div className="su__error-message">
        {errorMessage}
      </div>

    return(
      <div className="su">
        <div className="su__header">
          {stepHeaders}
        </div>
        <div className="su__body">
          {activeStep}
        </div>
        {errorMessageBlock}
      </div>
    )
  }
}

render(<SignUp />, document.getElementById('sign-up-component'))
