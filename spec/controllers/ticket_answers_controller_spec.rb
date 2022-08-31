require 'rails_helper'

RSpec.describe TicketAnswersController, type: :controller do
  login_tutor
  let(:ticket) { FactoryGirl.create :ticket }
  let(:valid_attributes) do
    {
      content: 'this is some content'
    }
  end

  let(:invalid_attributes) do
    {
      content: nil
    }
  end

  describe 'GET #index' do
    it 'assigns all ticket_answers as @ticket_answers' do
      ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
      get :index, ticket_id: ticket.to_param
      expect(assigns(:ticket_answers)).to eq([ticket_answer])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested ticket_answer as @ticket_answer' do
      ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
      get :show, id: ticket_answer.to_param, ticket_id: ticket.to_param
      expect(assigns(:ticket_answer)).to eq(ticket_answer)
    end
  end

  describe 'GET #new' do
    it 'assigns a new ticket_answer as @ticket_answer' do
      get :new, ticket_id: ticket.to_param
      expect(assigns(:ticket_answer)).to be_a_new(TicketAnswer)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested ticket_answer as @ticket_answer' do
      ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
      get :edit, id: ticket_answer.to_param, ticket_id: ticket.to_param
      expect(assigns(:ticket_answer)).to eq(ticket_answer)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new TicketAnswer' do
        expect do
          post :create, ticket_answer: valid_attributes, ticket_id: ticket.to_param
        end.to change(TicketAnswer, :count).by(1)
      end

      it 'assigns a newly created ticket_answer as @ticket_answer' do
        post :create, ticket_answer: valid_attributes, ticket_id: ticket.to_param
        expect(assigns(:ticket_answer)).to be_a(TicketAnswer)
        expect(assigns(:ticket_answer)).to be_persisted
      end

      it 'redirects to the created ticket_answer' do
        post :create, ticket_answer: valid_attributes, ticket_id: ticket.to_param
        expect(response).to redirect_to(action: :show, controller: :issue_forum, params: {id: ticket.id})
#        expect(response).to redirect_to(issue_path(ticket))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved ticket_answer as @ticket_answer' do
        post :create, ticket_answer: invalid_attributes, ticket_id: ticket.to_param
        expect(assigns(:ticket_answer)).to be_a_new(TicketAnswer)
      end

      it "re-renders the 'new' template" do
        post :create, ticket_answer: invalid_attributes, ticket_id: ticket.to_param
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          content: 'new content'
        }
      end

      it 'updates the requested ticket_answer' do
        ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
        put :update, id: ticket_answer.to_param, ticket_id: ticket.to_param, ticket_answer: new_attributes
        ticket_answer.reload
        expect(ticket_answer.content).to eq 'new content'
      end

      it 'assigns the requested ticket_answer as @ticket_answer' do
        ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
        put :update, id: ticket_answer.to_param, ticket_id: ticket.to_param, ticket_answer: valid_attributes
        expect(assigns(:ticket_answer)).to eq(ticket_answer)
      end

      it 'redirects to the ticket_answer' do
        ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
        put :update, id: ticket_answer.to_param, ticket_id: ticket.to_param, ticket_answer: valid_attributes
        #expect(response).to redirect_to(issue_path(ticket))

        expect(response).to redirect_to(action: :show, controller: :issue_forum, params: {id: ticket.id})
      end
    end

    context 'with invalid params' do
      it 'assigns the ticket_answer as @ticket_answer' do
        ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
        put :update, id: ticket_answer.to_param, ticket_id: ticket.to_param, ticket_answer: invalid_attributes
        expect(assigns(:ticket_answer)).to eq(ticket_answer)
      end

      it "re-renders the 'edit' template" do
        ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
        put :update, id: ticket_answer.to_param, ticket_id: ticket.to_param, ticket_answer: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested ticket_answer' do
      ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
      expect do
        delete :destroy, id: ticket_answer.to_param, ticket_id: ticket.to_param
      end.to change(TicketAnswer, :count).by(-1)
    end

    it 'redirects to the ticket_answers list' do
      ticket_answer = FactoryGirl.create :ticket_answer, ticket: ticket
      delete :destroy, id: ticket_answer.to_param, ticket_id: ticket.to_param
      expect(response).to redirect_to(ticket_ticket_answers_url(ticket))
    end
  end
end
