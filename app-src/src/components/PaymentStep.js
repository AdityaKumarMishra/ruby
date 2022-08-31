import React, { Component, PropTypes } from 'react'
import classnames from 'classnames'
import { formatDateForPayment } from '../utils'

class PaymentStep extends Component {
  static propTypes = {
    dataForPaymentStep: PropTypes.object,
    onBankPaymentSubmit: PropTypes.func,
    agreementOnChange: PropTypes.func,
    onPaymentTypeChange: PropTypes.func,
    setErrorMessage: PropTypes.func,
    saveOrderData: PropTypes.func,
    userId: PropTypes.number,
    orderId: PropTypes.number,
    authToken: PropTypes.string
  }

  state = {
    courseId: null,
    clientToken: null,
    reference: '',
    discountRate: '0',
    discountCodeEntered: '',
    discountsApplied: [],
    discountError: '',
    bankPayment: {
      bank: 'Australia and New Zealand Banking Group',
      accountName: 'GradReady Pty Ltd.',
      bsb: '013030',
      accountNum: '296915073',
    }
  }

  componentWillMount() {
    const { saveOrderData } = this.props
    $.ajax({
      url: '/enrolments/attach_enrolment_details',
      method: 'PUT',
      data: { user_id: this.props.userId }
    })
    .done(response => {
      saveOrderData('orderId', response.order_id)
      this.setState({
        courseId: response.course_id,
        reference: response.reference_number,
        discountRate: response.discount_rate
      })
    })
    .error(error => {
      this.props.setErrorMessage('We are sorry but server responded with error. \nPlease, contact us about it or try this operation later.')
    })

    $.ajax({
      url: '/orders/client_token.json',
      method: 'GET'
    })
    .done(response => {
      this.setState({
        clientToken: response.client_token
      })
      this.appendBraintreeLib()
      this.activateBraintree()
    })
    .fail(error => {
      this.props.setErrorMessage('We are sorry but server responded with error. \nPlease, contact us about it or try this operation later.')
    })
  }

  componentDidUpdate(prevProps, prevState) {
    const { courseId } = this.state
    const { saveOrderData } = this.props
    const { paymentType } = this.props.dataForPaymentStep
    const prevPaymentType = prevProps.dataForPaymentStep.paymentType

    if (!prevState.courseId && courseId) {
      $.ajax({
        url: '/courses/' + courseId + '.json',
      })
      .done(response => {
        saveOrderData('order', {
          course: response.type.replace('Ready', '').toUpperCase() + ' ' + response.name,
          city: response.city,
          closureDate: formatDateForPayment(new Date(response.enrolment_end_date)),
          price: response.price
        })
      })
      .fail(error => {
        this.props.setErrorMessage('We are sorry but server responded with error. \nPlease, contact us about it or try this operation later.')
      })
    }

    if (prevPaymentType.value === 'bank' && paymentType.value === 'online') {
      this.appendBraintreeLib()
      this.activateBraintree()
    }
  }

  activateBraintree = () => {
    if (typeof braintree === 'undefined') {
      const btTimer = setInterval(() => {
        if (typeof braintree !== 'undefined') {
          braintreeSetup(this.state.clientToken, this.props.dataForPaymentStep.order.price)
          clearInterval(btTimer)
        }
      }, 300)
    } else {
      const oldFrame = document.getElementById('braintree-dropin-modal-frame')
      if (oldFrame) document.body.removeChild(oldFrame)
      braintreeSetup(this.state.clientToken, this.props.dataForPaymentStep.order.price)
    }

    function braintreeSetup(token, amount) {
      braintree.setup(token, 'dropin', {
        container: 'payment-form'
      })
    }
  }

  appendBraintreeLib = () => {
    if (typeof braintree === 'undefined') {
      const script = document.createElement('script')
      script.src = 'https://js.braintreegateway.com/js/braintree-2.24.0.min.js'
      script.async = true
      document.body.appendChild(script)
    }
  }

  discountChange = e => {
    e.preventDefault()
    this.setState({
      discountCodeEntered: e.target.value
    })
  }

  removeDiscount = discountToRemove => e => {
    e.preventDefault()
    const { orderId, dataForPaymentStep, saveOrderData } = this.props
    const { discountsApplied } = this.state
    const { order } = dataForPaymentStep

    $.ajax({
      url: '/orders/' + orderId + '/remove_promo.json',
      method: 'DELETE',
      data: { id: orderId, promo_code: discountToRemove }
    })
    .done(response => {
      saveOrderData('order', {
        ...order,
        price: response.total_cost
      })
      const newDiscountArr = discountsApplied.filter((discount) => {
        if (discount !== discountToRemove) return discount
      })
      this.setState({
        discountsApplied: newDiscountArr
      })
    })
    .error(error => {
      this.setState({
        discountError: 'Error while removing discount code.'
      })
    })
  }

  applyDiscount = e => {
    e.preventDefault()
    const { orderId, dataForPaymentStep, saveOrderData } = this.props
    const { discountCodeEntered, discountsApplied } = this.state
    const { order } = dataForPaymentStep

    if (orderId && discountCodeEntered) {
      $.ajax({
        url: '/orders/' + orderId + '/add_promo.json',
        method: 'POST',
        data: { id: orderId, promo_code: discountCodeEntered }
      })
      .done(response => {
        // apply discount percentage
        saveOrderData('order', {
          ...order,
          price: response.total_cost
        })
        const newDiscountArr = discountsApplied.slice()
        newDiscountArr.push(discountCodeEntered)
        this.setState({
          discountsApplied: newDiscountArr,
          discountCodeEntered: ''
        })
      })
      .error((xhr, statusText, err) => {
        if (xhr.status === 400) {
          this.setState({
            discountError: 'Discount code not valid or doesn\'t exist.'
          })
        } else if (xhr.status === 406) {
          this.setState({
            discountError: 'Discount code can\'t be stacked with added code.'
          })
        }
      })
    }
  }

  render() {
    const { onBankPaymentSubmit, agreementOnChange, onPaymentTypeChange, dataForPaymentStep, orderId, authToken } = this.props
    const { userFName, userLName, userPhone, userEmail, agreement, paymentType, order } = dataForPaymentStep
    const { bankPayment, reference, discountCodeEntered, discountsApplied, discountError, discountRate } = this.state

    const paymentMethodClass = classnames({
      'su__payment-method': true,
      'su__payment-method--disabled': !agreement
    })

    const bankSubmit = !agreement ? null :
      <a href="#" className="su__btn su__btn--bank" onClick={onBankPaymentSubmit}>
        I have completed payment of ${order.price}
      </a>

    const onlineSubmit = !agreement ? null : <input type="submit" className="su__btn" value="Proceed Payment" />

    let paymentBlock
    if (paymentType.value === 'online') {
      const actionLink = '/orders/' + orderId + '/paypal_complete'

      paymentBlock =
        <form id="checkout" method="post" action={actionLink} className="su__payment-online">
          <div className="su__payment-paypal-info">
            <span>Note</span> there is a {discountRate}% additional fee for using a card or PayPal account. To avoid such fees, use the Direct Debit option. Note that AMEX is not accepted by the Credit Card facility. However, you are able to pay via AMEX through PayPal, by clicking on the "PayPal" button below.
          </div>
          <div id="payment-form" />
          <input name="authenticity_token" type="hidden" value={authToken}/>
          <div className="su__payment-online-note">
            <span className="su__payment-green-text">Wait period for online access:</span> Note, you will be redirected back to the GradReady site after payment, upon which you will have full access to the appropriate Online Content.
          </div>
          {onlineSubmit}
        </form>

    } else if (paymentType.value === 'bank') {

      paymentBlock =
        <div className="su__payment-bank">
          <h4>Bank Details</h4>
          <p>Bank: <span>{bankPayment.bank}</span></p>
          <p>Account Name: <span>{bankPayment.accountName}</span></p>
          <p>BSB: <span>{bankPayment.bsb}</span></p>
          <p>Account Number: <span>{bankPayment.accountNum}</span></p>
          <p><span>Using the reference: {reference}</span></p>
          <h4>Enrolment Process:</h4>
          <p>
            Complete Direct Debit transfer AND press the "I have completed payment of ${order.price}" button. Pressing the button will ensure that the GradReady Enrolment department receives your Enrolment request.
          </p>
          <p>
            <span className="su__payment-green-text">Wait period for online access:</span> Up to 1 week
            <span className="su__payment-wait-info">
              Once your payment is confirmed by the GradReady Enrolment Department, you will receive a Welcome Email and access to the Online Content. Depending on your bank this may take up to 3-5 working days to occur. For any questions related to your Direct Debit payment, please contact <a href="mailto:enrolments@gradready.com.au">enrolments@gradready.com.au</a>
            </span>
          </p>
          {bankSubmit}
        </div>
    }

    const discountsElements = discountsApplied.map((discount) => {
      return (
        <li className="su__discount-applied">
          <span>{discount}</span>
          <button onTouchTap={this.removeDiscount(discount)}>Remove</button>
        </li>
      )
    })

    const listOfDiscounts = !discountsApplied.length ? null : discountsApplied.length == 0 ? null :
      <div className="su__discount-list">
        Applied discounts:
        <ul>
          {discountsElements}
        </ul>
      </div>

    const discountErrorBlock = !discountError ? null :
      <div className="su__discount-error">{discountError}</div>

    return (
      <div className="su__payment">
        <div className="su__payment-top">
          <section className="su__payment-info">
            <h3>Account Information</h3>
            <p>
              Username: <span>{userFName.value + ' ' + userLName.value}</span>
            </p>
            <p>
              Phone: <span>{userPhone.value}</span>
            </p>
            <p>
              Email: <span>{userEmail.value}</span>
            </p>
          </section>
          <section className="su__payment-details">
            <h3>Payment Details</h3>
              <p>
                Course name: <span>{order.course}</span>
              </p>
              <p>
                City: <span>{order.city}</span>
              </p>
              <p>
                Enrolment Closure Date: <span>{order.closureDate}</span>
              </p>
              <p>
                Price: <span>${order.price}</span>
              </p>
          </section>
        </div>

        <div className="su__payment-discount">
          {listOfDiscounts}
          <form onSubmit={this.applyDiscount}>
            <input type="text" value={discountCodeEntered} onChange={this.discountChange} placeholder="Discount" />
            <input type="submit" value="Apply" />
          </form>
          {discountErrorBlock}
        </div>

        <div className="su__payment-agreement">
          <input type="checkbox" id="agreement" checked={agreement} onChange={agreementOnChange}/>
          <label htmlFor="agreement">
            I agree to <a href="https://gradready.com.au/terms">Terms and Conditions</a> set forth by GradReady, including, but not limited to, Course and Essay-Submission expiration dates (if applicable), and the <a href="#">GradReady Refund Policy</a>
          </label>
        </div>

        <div className={paymentMethodClass}>
          <h3>Payment Method</h3>
          <div className="su__payment-transfer">
            <p>
              <input
                type="radio"
                id="online-transfer-field"
                name="transfer-type"
                checked={paymentType.value === 'online'}
                value="online"
                disabled={!agreement}
                onChange={onPaymentTypeChange('paymentType')}
              />
              <label htmlFor="online-transfer-field">Online Transfer</label>
            </p>
            <p>
              <input
                type="radio"
                id="bank-transfer-field"
                name="transfer-type"
                checked={paymentType.value === 'bank'}
                value="bank"
                disabled={!agreement}
                onChange={onPaymentTypeChange('paymentType')}
              />
              <label htmlFor="bank-transfer-field">Bank Transfer</label>
            </p>
          </div>
          {paymentBlock}
        </div>
      </div>
    )
  }
}

export default PaymentStep
