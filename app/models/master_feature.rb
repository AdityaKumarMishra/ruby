class MasterFeature < ApplicationRecord
  has_many :product_version_feature_prices
  has_many :product_versions, through: :product_version_feature_prices
  has_many :feature_logs, through: :product_version_feature_prices
  has_many :enrolments, through: :feature_logs
  has_many :tags, through: :product_version_feature_prices
  belongs_to :product_line, optional: true
  has_one :announcement

  scope :type, ->(type) { where("? = ANY (types)", type) }
  scope :by_product_line, -> (product_line) { where('name like ?', "#{product_line}%") }
  scope :by_product_version, -> (product_version) { includes(:product_version_feature_prices).where(product_version_feature_prices: { product_version_id: product_version })}


  filterrific(
      available_filters: [
          :by_product_line
      ]
  )

  def private_tutoring?
    name.include? 'PrivateTutoringFeature'
  end


  def find_pvfps(current_user, enrolment_ids, custom_course = nil)
    if custom_course.present?
      product_version_id = custom_course.product_version_id
      @enrolment = current_user.enrolments.find_by(course_id: custom_course.id)
    elsif current_user.active_course
      product_version_id = current_user.active_course.product_version_id
      @enrolment = current_user.enrolments.find_by(course_id: current_user.active_course.id)
    else
      @enrolment = Enrolment.find(enrolment_ids)
      product_version_id = @enrolment.course.product_version.id
    end
    pvv = ProductVersionFeaturePrice.where(product_version_id: product_version_id, master_feature_id: [29, 8, 20, 30, 65], is_additional: false).find_by('price > ?', 0)
    if pvv.present? && pvv.qty.present?
      qty = pvv.qty
      price = pvv.price
      price_for_one = price / qty
      pvfp = ProductVersionFeaturePrice.find_by(product_version_id: product_version_id, master_feature_id:pvv.master_feature_id, price: pvv.price, qty: pvv.qty,is_default: false, is_additional: true )
      unless pvfp.present?
        # pvfp = ProductVersionFeaturePrice.find_or_create_by(product_version_id: product_version_id, master_feature_id:pvv.master_feature_id, price: pvv.price, qty: pvv.qty,is_default: false, is_additional: true )
        for i in 1..10
          pvfp = ProductVersionFeaturePrice.find_or_create_by(product_version_id: product_version_id, master_feature_id:pvv.master_feature_id, price: price_for_one*i, qty: i,is_default: false, is_additional: true )
        end
        if pvfp.tags.empty?
          pvv.tags.each do |tag|
            pvfp.tags << tag
          end
        end
        description = pvv.master_feature.essay? ? "#{pvv.qty} numbers of essays" : "#{pvv.qty} hours of tutoring"
        FeatureLog.create(description: description, qty: pvv.qty,
                          product_version_feature_price: pvfp,
                          enrolment: @enrolment
                          )
      end

      f_prices = product_version_feature_prices.where(product_version_id: product_version_id)
      feature_prices = f_prices.where("(price = ? AND qty = ?) OR (price = ? AND qty = ?) OR (price = ? AND qty = ?) OR (price = ? AND qty = ?) OR (price = ? AND qty = ?) OR (price = ? AND qty = ?) OR (price = ? AND qty = ?) OR (price = ? AND qty = ?) OR (price = ? AND qty = ?) OR (price = ? AND qty = ?)", price_for_one, 1 , price_for_one * 2, 2 , price_for_one * 3, 3, price_for_one * 4, 4, price_for_one * 5, 5, price_for_one * 6, 6, price_for_one * 7, 7, price_for_one * 8, 8, price_for_one * 9, 9, price_for_one * 10, 10).order(:qty)
      feature_prices.all.each do |a|
        items = ProductVersionFeaturePrice.where(product_version_id: a.product_version_id, master_feature_id: a.master_feature_id, price: a.price, is_default: a.is_default, is_additional: a.is_additional).where.not(id: a.id)
        if items
          items.destroy_all
        end
      end
      # current_user.feature_logs.where(enrolment_id: enrolment_ids).each {|fe| fe.validate_feature_log}
      feature_prices.where(is_additional: true)
    end
  end

  def essay?
    name.include? 'EssayFeature'
  end

  def get_clarity?
    name.include? 'ClarityFeature'
  end

  def textbook?
    name.include? 'TextbookFeature'
  end

  def hardcopy?
    name.include? 'TextbookHardCopyFeature'
  end

  def video?
    name.include? 'VideoFeature'
  end

  def live_exam?
    name.include? 'LiveMockExamFeature'
  end

  def online_mock_exam?
    name.include? 'OnlineMockExamFeature'
  end

  def mcq_feature?
    name.include? 'McqFeature'
  end

  def exam_feature?
    name.include?('ExamFeature') && !(name.include?('Live')) && !(name.include?('Mock'))
  end

  def diagnostic_feature?
    name.include?('DiagnosticsFeature')
  end

  def document_feature?
    name.include?('DocumentsFeature')
  end

  def friendly_feature_name
    #name.to_s.split(/(?=[A-Z])/).join(' ')
    title
  end

  def attendance?
    name.include?('TutorialsFeature')
  end

  def weekend_feature?
    name.include?('WeekendCourse')
  end

  def addons_name
    if name == "GamsatOnlineMockExamFeature2"
      "Online Mock Exam 2"
    elsif name == "GamsatOnlineMockExamFeature1"
      "Online Mock Exam 1"
    else
      (name.to_s.split(/(?=[A-Z])/) - ["Gamsat", "Umat"]).join(' ')
    end
  end

  def custom_feature_name(qty, type=nil)
    if essay?
      '10 Essays'
    elsif get_clarity?
      'GetClarity System'
    elsif textbook?
      case type
      when 'UmatReady'
        '400+ page Online Textbook'
      else
        '1200+ page Online Textbook'
      end
    elsif hardcopy?
      'Hard Copy Edition of Course Book'
    elsif video?
      'Course Videos'
    elsif live_exam?
      'Mock Exam Day'
    elsif private_tutoring?
      "#{qty} x 1 Hour Private Tutoring Sessions"
    elsif mcq_feature?
      case type
      when 'UmatReady'
        '2000+ MCQs'
      else
        '4000 MCQs'
      end
    elsif diagnostic_feature?
      'Diagnostics Assessment'
    elsif online_mock_exam?
      if self.name == "GamsatOnlineMockExamFeature1"
        "Online Mock Exam 1"
      else
        "Online Mock Exam 2"
      end
       # "Mock Exam Day"
    elsif exam_feature?
      case type
      when 'UmatReady'
        '4 Online Exams'
      else
        '8 Online Exams (Essays not included)'
      end
    elsif attendance?
      case type
      when 'UmatReady'
        'UMAT Attendance Tutorials Feature'
      else
        'GAMSAT Attendance Tutorials Feature'
      end
    elsif weekend_feature?
      'GAMSAT Weekend Course'
    else
      self.name
    end
  end

  def custom_feature_qty(qty, type=nil)
    if essay?
      10
    elsif private_tutoring?
      qty
    elsif exam_feature?
      case type
      when 'UmatReady'
        4
      else
        8
      end
    else
      nil
    end
  end

  def update_maximum_qty tag
    qty = 0
    tag_ids = tag.self_and_descendants_ids
    if mcq_feature?
      qty = Mcq.includes(:mcq_stem, :tagging).where(mcq_stems: { published: true, examinable: false }, taggings: { tag_id: tag_ids }).count
    elsif video?
      qty = Vod.includes(:taggings).where(published:true, taggings: { tag_id: tag_ids }).count
    elsif textbook?
      qty = Textbook.includes(:taggings).where('(for_textbook = true OR for_textbook_slide = true) AND taggings.tag_id IN(?)', tag_ids).references(:taggings).count
    elsif document_feature?
      qty = Textbook.includes(:taggings).where('(for_document = true OR for_downloadable_resource = true) AND taggings.tag_id IN(?)', tag_ids).references(:taggings).count
    elsif exam_feature?
      qty = OnlineExam.eager_load(:tags).where(published: true).where('tags.id IN (?)', tag_ids).count
    end
    self.update_attribute(:max_qty, qty)
    qty
  end

  def product_version_feature_price(p_id)
    product_version_feature_prices.find_by(product_version_id: p_id)
  end

  def exam_max_qty
    OnlineExam.where(published: true).includes(:tags).where(tags: {id: tags.ids}).count
  end
end
