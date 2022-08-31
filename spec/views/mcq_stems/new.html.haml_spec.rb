require 'rails_helper'

RSpec.describe 'mcq_stems/new', type: :view do
  login_superadmin
  let!(:user) {FactoryGirl.create(:user, email: "tt@gradready.com.au")}
  before(:each) do
    assign(:mcq_stem, McqStem.new(
                        title: 'MyString',
                        description: 'MyText',
                        author: FactoryGirl.create(:user, :tutor),
                        reviewer: FactoryGirl.create(:user, :tutor),
                        reviewed: true
    ))
    allow(view).to receive(:policy_scope).and_return(Pundit.policy_scope(FactoryGirl.create(:user), Tag))
  end

  it 'renders new mcq_stem form' do
    render

    assert_select 'form[action=?][method=?]', mcq_stems_path, 'post' do
      assert_select 'input#mcq_stem_title[name=?]', 'mcq_stem[title]'
      assert_select 'input#mcq_stem_examinable[name=?]', 'mcq_stem[examinable]'
      assert_select 'input#mcq_stem_published[name=?]', 'mcq_stem[published]'
      assert_select 'textarea#mcq_stem_description[name=?]', 'mcq_stem[description]'
      assert_select 'select#mcq_stem_author[name=?]', 'mcq_stem[author]'
      assert_select 'select#mcq_stem_reviewer_id[name=?]', 'mcq_stem[reviewer_id]'
    end
  end
end
