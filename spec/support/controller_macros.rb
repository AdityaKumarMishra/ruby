module ControllerMacros
  def login_superadmin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      superadmin = FactoryGirl.create(:user, :superadmin)
      sign_in superadmin
    end
  end

  def login_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      admin = FactoryGirl.create(:user, :admin)
      sign_in admin
    end
  end

  def login_manager
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      manager = FactoryGirl.create(:user, :manager)
      sign_in manager
    end
  end

  def login_tutor
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      tutor = FactoryGirl.create(:user, :tutor)
      sign_in tutor
    end
  end

  def login_student
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      student = FactoryGirl.create(:user, :student)
      sign_in student
    end
  end
end
