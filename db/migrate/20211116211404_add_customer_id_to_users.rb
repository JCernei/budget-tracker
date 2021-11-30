class AddCustomerIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :customer_id, :integer
  end
end
