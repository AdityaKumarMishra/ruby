class InsertFaqGamsatPages < ActiveRecord::Migration[6.1]
    def up
      FaqPage.create! faq_topic: FaqTopic.for_code('understanding-gamsat'), content:File.read("faq_defaults/understanding-gamsat.html")
      FaqPage.create! faq_topic: FaqTopic.for_code('preparing-gamsat'), content:File.read("faq_defaults/preparing-gamsat.html")
      FaqPage.create! faq_topic: FaqTopic.for_code('about-gradready'), content:File.read("faq_defaults/about-gradready.html")
      FaqPage.create! faq_topic: FaqTopic.for_code('enrolment-payment'), content:File.read("faq_defaults/enrolment-payment.html")
      FaqPage.create! faq_topic: FaqTopic.for_code('non-science-background'), content:File.read("faq_defaults/non-science-background.html")
      FaqPage.create! faq_topic: FaqTopic.for_code('postgraduate-medical-school-admissions'), content:File.read("faq_defaults/postgraduate-medical-school-admissions.html")
    end

    def down
      FaqPage.joins(:faq_topic).where('faq_topics.faq_type' => FaqTopic.faq_types[:gamsat]).delete_all
    end
end
