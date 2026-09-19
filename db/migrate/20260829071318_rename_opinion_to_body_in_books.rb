class RenameOpinionToBodyInBooks < ActiveRecord::Migration[6.1]
  def change
     rename_column :books, :opinion, :body
  end
end
