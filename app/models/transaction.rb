class Transaction < ApplicationRecord
  has_one_attached :receipt_photo
  
  # 収入 or 支出
  enum transaction_type: { income: 0, expense: 1 }

  # 支払方法
  enum payment_method: { bank: 0, cash: 1 }

  # 処理状況
  enum status: { unpaid: 0, paid: 1 }

  # 立替 or 会計直接払い
  enum payer_type: { reimbursement: 0, direct: 1 }

  scope :incomes, -> { where(transaction_type: "income") }
  scope :expenses, -> { where(transaction_type: "expense") }

  validates :date, presence: true
  validates :item_name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payee, presence: true

    # 会計年度(4月始まり)で絞り込む
  scope :by_fiscal_year, ->(year) {
    where(date: Date.new(year, 4, 1)..Date.new(year + 1, 3, 31))
  }

  # 月で絞り込む(必要なら後から使う)
  scope :by_month, ->(year, month) {
    where(date: Date.new(year, month, 1)..Date.new(year, month, -1))
  }

    # 全体の残高(収入合計 - 支出合計)
  def self.total_balance
    incomes.sum(:amount) - expenses.sum(:amount)
  end

  # 支払方法別の残高(口座 or 現金)
  def self.balance_by_method(method)
    incomes.where(payment_method: method).sum(:amount) -
      expenses.where(payment_method: method).sum(:amount)
  end

end