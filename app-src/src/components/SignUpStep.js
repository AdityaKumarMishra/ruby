import React, { Component, PropTypes } from 'react'
import classnames from 'classnames'

class SignUpStep extends Component {
  static propTypes = {
    signUpState: PropTypes.object,
    onInputChange: PropTypes.func,
    onSelectChange: PropTypes.func,
    onSignUpSubmit: PropTypes.func,
    onSignUpInputBlur: PropTypes.func
  }

  render() {
    const { onInputChange, onSelectChange, onSignUpSubmit, onSignUpInputBlur, signUpState } = this.props

    const signUpFields = [
      {
        name: 'userName',
        type: 'text',
        placeholder: 'Username'
      },
      {
        name: 'userPwd',
        type: 'password',
        placeholder: 'Password'
      },
      {
        name: 'userPwdConf',
        type: 'password',
        placeholder: 'Password confirmation'
      },
      {
        name: 'userEmail',
        type: 'email',
        placeholder: 'Email'
      },
      {
        name: 'userFName',
        type: 'text',
        placeholder: 'First name'
      },
      {
        name: 'userLName',
        type: 'text',
        placeholder: 'Last name'
      },
      {
        name: 'userPhone',
        type: 'text',
        placeholder: 'Phone number'
      },
      {
        name: 'userAddress',
        type: 'text',
        placeholder: 'Address'
      },
      {
        name: 'userSuburb',
        type: 'text',
        placeholder: 'Suburb'
      },
      {
        name: 'userPostcode',
        type: 'text',
        placeholder: 'Postcode'
      }
    ]

    const signUpInputs = signUpFields.map((field, index) => {
      const valueFromState = signUpState[field.name]

      const fieldClass = classnames({
        'su__input su__input--sign-up': true,
        'su__input-valid': valueFromState.valid && valueFromState.wasFocused,
        'su__input-invalid': !valueFromState.valid && valueFromState.wasFocused
      })

      const validationTipClass = classnames({
        'su__validation': true,
        'su__validation--on': valueFromState.message
      })

      return (
        <div key={field.name + index} className="su__input-block">
          <input type={field.type}
            className={fieldClass}
            placeholder={field.placeholder}
            value={valueFromState.value}
            onChange={onInputChange(field.name)}
            onBlur={onSignUpInputBlur(field.name)}
          />
        <div className={validationTipClass}>{valueFromState.message}</div>
        </div>
      )
    })

    const signUpSelectFields = [
      {
        name: 'userState',
        type: 'select',
        options: ['Other', 'VIC', 'NSW', 'QLD', 'ACT', 'SA', 'NT', 'WA', 'TAS']
      },
      {
        name: 'userCountry',
        type: 'select',
        options: ['Australia', 'Asia Pacific', 'Europe', 'Americas']
      }
    ]

    const signUpSelects = signUpSelectFields.map((select, selectKey) => {
      const valueFromState = signUpState[select.name].value
      const options = select.options.map((option, optionKey) => <option key={optionKey} value={optionKey}>{option}</option>)

      return (
        <div key={selectKey} className="su__select-block">
          <select className="su__input su__input--sign-up" name={select.name} value={valueFromState} onChange={onSelectChange(select.name)}>
            {options}
          </select>
        </div>
      )
    })

    return (
      <form className="su__sign-up" onSubmit={onSignUpSubmit}>
        {signUpInputs}
        <div>
          {signUpSelects}
        </div>
        <div className="su__submit-block">
          <input type="submit" className="su__btn" value="Register" />
        </div>
      </form>
    )
  }
}

export default SignUpStep
