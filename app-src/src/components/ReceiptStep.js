import React, { Component, PropTypes } from 'react'

class ReceiptStep extends Component {
  static propTypes = {
    order: PropTypes.object,
    paymentType: PropTypes.string,
    paymentDate: PropTypes.string
  }

  render() {
    const { order, paymentType, paymentDate } = this.props

    let paymentMethod
    switch (paymentType.value) {
      case 'bank':
        paymentMethod = 'Bank Transfer'
        break
      case 'online':
        paymentMethod = 'Online Transfer'
        break
    }

    return (
      <div className="su__receipt">
        <h3>Thank you!</h3>
        <div className="su__receipt-img">
          Success operation.
        </div>
        <p className="su__receipt-message">
          Your transfer might take up to 7 days to reach us, we will contact you as soon as we recieve transfer.
        </p>
        <h4>
          Payment details
        </h4>
        <p className="su__receipt-details">
          Course: <span>{order.course}</span> - Price: <span>${order.price}</span>
        </p>
        <p className="su__receipt-details">
          Payment method: <span>{paymentMethod}</span> - Payment date: <span>{paymentDate}</span>
        </p>
      </div>
    )
  }
}

export default ReceiptStep
