# frozen_string_literal: true

# RequestsMigration generator
class CreateTochkaCyclopsRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :tochka_cyclops_requests do |t|
      t.string :method
      t.jsonb :body
      t.integer :status
      t.string :request_identifier
      t.references :result, polymorphic: true, index: false, null: true
      t.string :idempotency_key, null: true
      t.timestamps
    end
  end
end
