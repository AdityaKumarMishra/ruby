class ErrorsController < ApplicationController
  layout 'layouts/public_page'
  def not_found
    render(:status => 404)
  end

  def internal_server_error
    render(:status => 500)
  end

  def unprocessable_error
    render(:status => 422)
  end
end
