class TransferTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transfer_transaction, only: [:show, :course_transfer, :edit, :update, :destroy]

  # GET /transfer_transactions
  # GET /transfer_transactions.json
  def index
    if current_user.role == "student"
      redirect_to(root_url)
    end
    @transfer_transactions = TransferTransaction.all
  end

  # GET /transfer_transactions/1
  # GET /transfer_transactions/1.json
  def show(transfer_reference = nil)
    if (@transfer_transaction.user_id != current_user.id) && (current_user.role == "student")
      redirect_to(root_url)
    end
  end

  # POST /transfer_transaction/transfer_course
  def course_transfer
    if current_user.role == "student"
      redirect_to(root_url)
    end
  end

  # GET /transfer_transactions/new
  def new
    if (current_user.role == "student")
      redirect_to(root_url)
    end
    @transfer_transaction = TransferTransaction.new
  end

  # GET /transfer_transactions/1/edit
  def edit
    if (current_user.role == "student")
      redirect_to(root_url)
    end
  end

  # POST /transfer_transactions
  # POST /transfer_transactions.json
  def create
    if (current_user.role == "student")
      redirect_to(root_url)
    end
    @transfer_transaction = TransferTransaction.new(transfer_transaction_params)

    respond_to do |format|
      if @transfer_transaction.save
        format.html { redirect_to @transfer_transaction, notice: 'Transfer transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transfer_transaction }
      else
        format.html { render :new }
        format.json { render json: @transfer_transaction.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # PATCH/PUT /transfer_transactions/1
  # PATCH/PUT /transfer_transactions/1.json
  def update
    if current_user.role == "student"
      redirect_to(root_url)
    end
    respond_to do |format|
      if @transfer_transaction.update(transfer_transaction_params)
        @transfer_transaction.enrol_student
        format.html { redirect_to @transfer_transaction, notice: 'Transfer transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer_transaction }
      else
        format.html { render :edit }
        format.json { render json: @transfer_transaction.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  # DELETE /transfer_transactions/1
  # DELETE /transfer_transactions/1.json
  def destroy
    if (current_user.role == "student")
      redirect_to(root_url)
    end
    @transfer_transaction.destroy
    respond_to do |format|
      format.html { redirect_to transfer_transactions_url, notice: 'Transfer transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer_transaction
      @transfer_transaction = TransferTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_transaction_params
      params.require(:transfer_transaction).permit(:payment_confirmed, :amount, :paid, :banking_reference, :course)
    end
end
