class ChangeDataTypeInPackages < ActiveRecord::Migration
  def change
    add_column :packages, :start_date, :date
  end
end
