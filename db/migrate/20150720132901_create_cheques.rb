class CreateCheques < ActiveRecord::Migration
  def change
    create_table :cheques do |t|
      t.string :name
      t.date :date
      t.float :nominal_value

      t.timestamps null: false
    end
  end
end
