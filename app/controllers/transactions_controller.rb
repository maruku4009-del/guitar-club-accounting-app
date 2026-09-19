class TransactionsController < ApplicationController

  before_action :set_transaction, only: [:show, :edit, :update, :destroy, :mark_as_paid]
  before_action :require_accountant, only: [:new, :create, :edit, :update, :destroy, :mark_as_paid, :export]

  
  def index
    @year = (params[:year] || current_fiscal_year).to_i

    @transactions = Transaction.by_fiscal_year(@year).order(date: :desc)
    @total_balance = Transaction.by_fiscal_year(@year).total_balance
    @bank_balance = Transaction.by_fiscal_year(@year).balance_by_method("bank")
    @cash_balance = Transaction.by_fiscal_year(@year).balance_by_method("cash")
  end


  def unpaid
    @transactions = Transaction.unpaid.order(date: :desc)
  end

  def export
    @transactions = Transaction.order(:date)
  end

  def show
  end

  def new
    @transaction = Transaction.new(date: Time.zone.today)
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      redirect_to transactions_path, notice: "登録しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transaction_path(@transaction), notice: "更新しました"
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_path, notice: "削除しました"
  end

  def mark_as_paid
    @transaction.update(status: "paid")
    redirect_to transaction_path(@transaction), notice: "支払済みに更新しました"
  end

  private

  def current_fiscal_year
    today = Time.zone.today
    today.month >= 4 ? today.year : today.year - 1
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def require_accountant
    unless accountant?
      redirect_to transactions_path, alert: "この操作は会計のみ行えます"
    end
  end

  def transaction_params
    params.require(:transaction).permit(:date, :item_name, :amount,  :transaction_type, :payee, :payment_method, :status, :payer_type, :note, :receipt_photo )
  end


end