namespace :faq_topic do
  task :add_vce_hsc_topic => :environment do
    FaqTopic.vce.destroy_all
    FaqTopic.hsc.destroy_all
    # for vce
    vce_topics = [FaqTopic.create(faq_type: FaqTopic.faq_types[:vce], code: 'und_vce', title: 'Understanding VCE'),
    FaqTopic.create(faq_type: FaqTopic.faq_types[:vce], code: 'preparation', title: 'Understanding the value of Preparation'),
    FaqTopic.create(faq_type: FaqTopic.faq_types[:vce], code: 'vceready', title: 'Understanding VCE Ready'),
    FaqTopic.create(faq_type: FaqTopic.faq_types[:vce], code: 'enrolment', title: 'Enrolment and Payment Queries'),
    FaqTopic.create(faq_type: FaqTopic.faq_types[:vce], code: 'university-admissions', title: 'University Admissions'),
    ]

    # for hsc
    hsc_topics = [FaqTopic.create(faq_type: FaqTopic.faq_types[:hsc], code: 'und_hsc', title: 'Understanding HSC'),
    FaqTopic.create(faq_type: FaqTopic.faq_types[:hsc], code: 'preparation', title: 'Understanding the value of Preparation'),
    FaqTopic.create(faq_type: FaqTopic.faq_types[:hsc], code: 'hscready', title: 'Understanding HSCReady'),
    FaqTopic.create(faq_type: FaqTopic.faq_types[:hsc], code: 'enrolment', title: 'Enrolment and Payment Queries'),
    FaqTopic.create(faq_type: FaqTopic.faq_types[:hsc], code: 'university-admissions', title: 'University Admissions')
    ]

    (vce_topics + hsc_topics).each do |topic|
      FaqPage.create(faq_topic: topic, content: 'Input the content here!')
    end
  end
end
