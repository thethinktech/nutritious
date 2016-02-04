class ChangeDataTypePackages < ActiveRecord::Migration
  def change
    change_column :packages, :cost, :string
  end
end
