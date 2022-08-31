class InsertDefaultFaqTopics < ActiveRecord::Migration[6.1]
  def up
    [
        {name: 'Understanding the GAMSAT', code: FaqTopic.codes[:understanding_gamsat], type: FaqTopic.faq_types[:gamsat]},
        {name: 'Preparing for the GAMSAT', code: FaqTopic.codes[:preparing_gamsat], type: FaqTopic.faq_types[:gamsat]},
        {name: 'About GradReady', code: FaqTopic.codes[:about_gradready], type: FaqTopic.faq_types[:gamsat]},
        {name: 'Enrolment and Payment', code: FaqTopic.codes[:enrolment_payment], type: FaqTopic.faq_types[:gamsat]},
        {name: 'For students from a non-science background', code: FaqTopic.codes[:non_science_background], type: FaqTopic.faq_types[:gamsat]},
        {name: 'Postgraduate Medical School Admissions', code: FaqTopic.codes[:postgraduate_medical_school_admissions], type: FaqTopic.faq_types[:gamsat]},

        {name: 'Understanding the UMAT', code: FaqTopic.codes[:und_umat], type: FaqTopic.faq_types[:umat]},
        {name: 'Eligibility', code: FaqTopic.codes[:eligibility], type: FaqTopic.faq_types[:umat]},
        {name: 'Understanding the value of Preparation', code: FaqTopic.codes[:preparation], type: FaqTopic.faq_types[:umat]},
        {name: 'Understanding UMATReady', code: FaqTopic.codes[:umatready], type: FaqTopic.faq_types[:umat]},
        {name: 'Undergraduate Medical School Admissions', code: FaqTopic.codes[:undergraduate], type: FaqTopic.faq_types[:umat]},
        {name: 'Enrolment and Payment Queries', code: FaqTopic.codes[:enrolment], type: FaqTopic.faq_types[:umat]},
    ].each { |topic|
      FaqTopic.create!(faq_type: topic[:type], code: topic[:code], title:topic[:name])
    }
  end

  def down
    FaqTopic.delete_all
  end
end
