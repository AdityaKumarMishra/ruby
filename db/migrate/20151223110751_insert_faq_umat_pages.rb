class InsertFaqUmatPages < ActiveRecord::Migration[6.1]
  def up
    FaqPage.create! faq_topic: FaqTopic.for_code('und_umat'), content:File.read("faq_defaults/und_umat.html")
    FaqPage.create! faq_topic: FaqTopic.for_code('eligibility'), content:File.read("faq_defaults/eligibility.html")
    FaqPage.create! faq_topic: FaqTopic.for_code('preparation'), content:File.read("faq_defaults/preparation.html")
    FaqPage.create! faq_topic: FaqTopic.for_code('umatready'), content:File.read("faq_defaults/umatready.html")
    FaqPage.create! faq_topic: FaqTopic.for_code('undergraduate'), content:File.read("faq_defaults/undergraduate.html")
    FaqPage.create! faq_topic: FaqTopic.for_code('enrolment'), content:File.read("faq_defaults/enrolment.html")
  end

  def down
    FaqPage.joins(:faq_topic).where('faq_topics.faq_type' => FaqTopic.faq_types[:umat]).delete_all
  end
end
