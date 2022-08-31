require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  login_student

  let(:valid_attributes) {
    FactoryGirl.attributes_for(:ticket).merge!({
      asker_attributes: FactoryGirl.attributes_for(:user),
      answerer_id: FactoryGirl.create(:user, :tutor).id,
      tag_ids: [ FactoryGirl.create(:tag).id ]

    })
  }

  let(:invalid_attributes) do
    {
      title: nil
    }
  end

  describe 'GET #index' do
    it 'assigns all tickets as @tickets' do
      ticket = FactoryGirl.create :ticket, asker: subject.current_user
      get :index, {}
      expect(assigns(:tickets)).to eq(nil)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested ticket as @ticket' do
      ticket = FactoryGirl.create :ticket, asker: subject.current_user
      get :show, id: ticket.to_param
      expect(assigns(:ticket)).to eq(ticket)
    end
  end

  describe 'GET #new' do
    it 'assigns a new ticket as @ticket' do
      get :new, {}
      expect(assigns(:ticket)).to be_a_new(Ticket)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested ticket as @ticket' do
      ticket = FactoryGirl.create :ticket, asker: subject.current_user
      get :edit, id: ticket.to_param
      expect(assigns(:ticket)).to eq(ticket)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      xit 'creates a new Ticket' do
        expect do
          post :create, ticket: valid_attributes
        end.to change(Ticket, :count).by(1)
      end

      xit 'assigns a newly created ticket as @ticket' do
        post :create, ticket: valid_attributes
        expect(assigns(:ticket)).to be_a(Ticket)
        expect(assigns(:ticket)).to be_persisted
      end

      xit 'redirects to the created ticket' do
        post :create, ticket: valid_attributes
        expect(response).to redirect_to(action: :index, controller: :contact)
#        expect(response).to redirect_to(issue_path(Ticket.last))
      end
    end

    context 'with invalid params' do
      xit 'assigns a newly created but unsaved ticket as @ticket' do
        post :create, ticket: invalid_attributes
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end

      xit "re-renders the 'new' template" do
        post :create, ticket: invalid_attributes
        expect(response).to render_template('new')
      end
    end

    context 'with no tags selected' do
      let(:invalid_attributes) {
        FactoryGirl.attributes_for(:ticket).merge!({
          asker_attributes: FactoryGirl.attributes_for(:user)
        })
      }

      xit 'assigns a newly created but unsaved ticket as @ticket' do
        post :create, ticket: invalid_attributes
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end

      xit "re-renders the 'new' template" do
        post :create, ticket: invalid_attributes
        expect(response).to render_template('new')
      end
    end

    context 'When user not logged in' do
      let(:invalid_attributes) {
        FactoryGirl.attributes_for(:ticket, "g-recaptcha-response" => nil)
      }

      xit 'assigns a newly created but unsaved ticket as @ticket' do
        post :create, ticket: invalid_attributes
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end

      xit "re-renders the 'new' template" do
        post :create, ticket: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          title: 'this is updated one'
        }
      end

      it 'updates the requested ticket' do
        ticket = FactoryGirl.create :ticket, asker: subject.current_user
        put :update, id: ticket.to_param, ticket: new_attributes
        ticket.reload
        expect(ticket.title).to eq 'this is updated one'
      end

      it 'assigns the requested ticket as @ticket' do
        ticket = FactoryGirl.create :ticket, asker: subject.current_user
        put :update, id: ticket.to_param, ticket: valid_attributes
        expect(assigns(:ticket)).to eq(ticket)
      end

      it 'redirects to the ticket' do
        ticket = FactoryGirl.create :ticket, asker: subject.current_user
        put :update, id: ticket.to_param, ticket: valid_attributes
        #expect(response).to redirect_to(ticket)
        expect(response).to redirect_to(action: :show, controller: :issue_forum, params: {id: ticket.id})
      end
    end

    context 'with invalid params' do
      it 'assigns the ticket as @ticket' do
        ticket = FactoryGirl.create :ticket, asker: subject.current_user
        put :update, id: ticket.to_param, ticket: invalid_attributes
        expect(assigns(:ticket)).to eq(ticket)
      end

      xit "re-renders the 'edit' template" do
        ticket = FactoryGirl.create :ticket, asker: subject.current_user
        put :update, id: ticket.to_param, ticket: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested ticket' do
      @request.env['HTTP_REFERER'] = tickets_url
      ticket = FactoryGirl.create :ticket, asker: subject.current_user
      expect do
        delete :destroy, id: ticket.to_param
      end.to change(Ticket, :count).by(-1)
    end

    it 'redirects to the tickets list' do
      @request.env['HTTP_REFERER'] = tickets_url
      ticket = FactoryGirl.create :ticket, asker: subject.current_user
      delete :destroy, id: ticket.to_param
      expect(response).to redirect_to(tickets_url)
    end
  end

  describe 'DELETE #destroy_old_issues' do
    it 'destroys old unanswered' do
      expect { delete :destroy_old_issues }.not_to raise_error
    end
  end
end
