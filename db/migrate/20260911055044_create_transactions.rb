class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.date :date
      t.string :item_name
      t.integer :amount
      t.integer :transaction_type, default: 0 # 収入(0) or 支出(1)
      t.string  :payee                         # 支払先・収入元
      t.integer :payment_method, default: 0    # 口座(0) or 現金(1)
      t.integer :status, default: 0            # 未処理(0) or 処理済み(1)
      t.integer :payer_type, default: 0        # 立替(0) or 会計直接払い(1)
      t.string  :category                      # イベント/カテゴリタグ
      t.text    :note                          # 備考

      t.timestamps
    end
  end
end
