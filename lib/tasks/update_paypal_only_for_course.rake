
namespace :courses do
    task update_paypal_only_for_course: :environment do
        courses=Course.where(paypal_only: true)
        courses.update_all(activate_paypal: :paypal_only)
    end
  end
  