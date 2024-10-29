# frozen_string_literal: true

# ErrorsMigration generator
class CreateTochkaCyclopsErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :tochka_cyclops_errors do |t|
      t.jsonb :body
      t.integer :code
      t.string :message
      t.timestamps
    end
  end
end
