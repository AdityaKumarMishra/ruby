module ContactHelper

  def appropriate_class_question(product_line)
    button_class=["new-ticket btn btn-gradready"]

    case product_line
      when "umat"
        button_class.append(:blue)
      when "vce"
        button_class.append(:purple)
      when "hsc"
        button_class.append(:red)
      else
        button_class.append(:green)
    end

    return button_class
  end

  def fetch_contact_team_url(product_line)
    case product_line
    when "umat"
      umat_preparation_courses_team_path
    when "hsc"
      hsc_team_path
    when "vce"
      vce_team_path
    else
      gamsat_preparation_courses_team_path
    end
  end
end
