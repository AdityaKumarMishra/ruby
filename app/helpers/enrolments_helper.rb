module EnrolmentsHelper
  def available_product_line
    ProductLine.order(:name).map { |product_line| [product_line.name.capitalize,product_line.name.capitalize]}
  end
  def available_product_version
    ProductVersion.all.map{|p| [p.name, p.id]}.sort_by { |name, id| name }
  end

  def available_city
    Course.options_for_city
  end

  def enrolment_status_change_button(enrolment, student)
    if enrolment.Unenrolled?
      link_to 'Re-enroll', unenrol_or_renrol_enrolment_path(enrolment, new_state: enrolment.previous_state_before_unenrolled || 'Applied', user_id: student.id), method: :patch, data: { confirm: 'Are you sure?' }, class: 'btn btn-success btn-sm'
    else
      link_to 'Unenroll', unenrol_or_renrol_enrolment_path(enrolment, new_state: 'Unenrolled', user_id: student.id), method: :patch, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-sm'
    end
  end

  def enrolment_status(enrolment_state, order_state)
    return 'Paid - Placeholder' if order_state == 'registered' && enrolment_state != 'Unenrolled'

    case enrolment_state
    when 'Applied'
      'Active - Paid'
    when 'Transferred'
      'Active - Transferred'
    when 'Manual Enrolment'
      'Active - New Enrolment by Staff'
    else
      enrolment_state
    end
  end
  def reset_mock_exam_select
    level = [["Section I", "section_1"], ["Section II (Essays)", "section_2"], ["Section III", "section_3"]]
  end

  def enrolment_feature_orders(enrolment, user)
    fls = FeatureLog.includes(:purchase_item).where("enrolment_id = #{enrolment.id} AND purchase_items.order_id IN (#{user.orders.ids.join(',')})").references(:purchase_item)
    fls.map{ |fl| fl.purchase_item.order_id }.uniq.reject(&:blank?)
  end

  def enrolment_invoice(enrolment, user)
    if enrolment.paid_at.present? && (current_user.admin? || current_user.superadmin?) && user.student?
      case enrolment.state
      when 'Transferred', 'Manual Enrolment'
        'No Initial Invoice Available'
      when 'Unenrolled'
        case enrolment.previous_state_before_unenrolled
        when 'Transferred', 'Manual Enrolment'
          'No Invoice Available'
        else
          link_to 'Download', enrolment_path(enrolment, format: :pdf), class: 'btn btn-default'
        end
      else
        link_to 'Download', enrolment_path(enrolment, format: :pdf), class: 'btn btn-default'
      end
    elsif enrolment.order.total_cost > 0.1
      link_to 'Download', enrolment_path(enrolment, format: :pdf), class: 'btn btn-default'
    else
      'No Initial Invoice Available'
    end
  end
end
