require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  before(:each) do
    request.env["HTTP_REFERER"] = "http://test.host/comments/"
  end

  login_student
  let(:ticket_answer) { FactoryGirl.create :ticket_answer, public: true }
  let(:valid_attributes) do
    {
      content: 'dummy data',
      commentable_id: ticket_answer.to_param,
      commentable_type: ticket_answer.class.name
    }
  end

  let(:invalid_attributes) do
    {
      content: '',
      commentable_id: ticket_answer.to_param,
      commentable_type: ticket_answer.class.name
    }
  end

  describe 'GET #index' do
    xit 'assigns all comments as @comments' do
      comment = FactoryGirl.create :comment
      get :index, {}
      expect(assigns(:comments)).to eq([comment])
    end
  end

  describe 'GET #show' do
    xit 'assigns the requested comment as @comment' do
      comment = FactoryGirl.create :comment
      get :show, id: comment.to_param
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe 'GET #new' do
    xit 'assigns a new comment as @comment' do
      get :new, {}
      expect(assigns(:comment)).to be_a_new(Comment)
    end
  end

  describe 'GET #edit' do
    xit 'assigns the requested comment as @comment' do
      comment = FactoryGirl.create :comment
      get :edit, id: comment.to_param
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      xit 'creates a new Comment' do
        expect do
          post :create, comment: valid_attributes
        end.to change(Comment, :count).by(1)
      end

      xit 'assigns a newly created comment as @comment' do
        post :create, comment: valid_attributes
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      xit 'redirects to the created comment' do
        post :create, comment: valid_attributes
        expect(response).to redirect_to(comments_url+'/')
        #Note above is a hotfix that should be changed.
      end
    end

    context 'with invalid params' do
      xit 'assigns a newly created but unsaved comment as @comment' do
        post :create, comment: invalid_attributes
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      xit "re-renders the 'new' template" do
        post :create, comment: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          content: 'whatever'
        }
      end

      xit 'updates the requested comment' do
        comment = FactoryGirl.create :comment, user: subject.current_user
        put :update, id: comment.to_param, comment: new_attributes
        comment.reload
        expect(comment.content).to eq 'whatever'
      end

      xit 'cannot update commentable as student' do
        comment = FactoryGirl.create :comment, user: subject.current_user # default commentable is ticket_answer
        put :update, id: comment.to_param, comment: { commentable_id: comment.commentable.ticket.to_param,
                                                      commentable_type: comment.commentable.ticket.class.name }
        comment.reload
        expect(comment.commentable).to eq comment.commentable
      end

      xit 'assigns the requested comment as @comment' do
        comment = FactoryGirl.create :comment, user: subject.current_user
        put :update, id: comment.to_param, comment: valid_attributes
        expect(assigns(:comment)).to eq(comment)
      end

      xit 'redirects to the comment' do
        comment = FactoryGirl.create :comment, user: subject.current_user
        put :update, id: comment.to_param, comment: valid_attributes
        expect(response).to redirect_to(comment)
      end
    end

    context 'with invalid params' do
      xit 'assigns the comment as @comment' do
        comment = FactoryGirl.create :comment, user: subject.current_user
        put :update, id: comment.to_param, comment: invalid_attributes
        expect(assigns(:comment)).to eq(comment)
      end

      xit "re-renders the 'edit' template" do
        comment = FactoryGirl.create :comment, user: subject.current_user
        put :update, id: comment.to_param, comment: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    xit 'destroys the requested comment' do
      comment = FactoryGirl.create :comment, user: subject.current_user
      expect do
        delete :destroy, id: comment.to_param
      end.to change(Comment, :count).by(-1)
    end

    xit 'redirects to the comments list' do
      comment = FactoryGirl.create :comment, user: subject.current_user
      delete :destroy, id: comment.to_param
      expect(response).to redirect_to(comments_url)
    end
  end
end
