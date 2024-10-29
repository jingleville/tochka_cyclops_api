# frozen_string_literal: true

# ResponsesMigration generator
class CreateTochkaCyclopsResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :tochka_cyclops_response do |t|
      t.jsonb :body
      t.jsonb :result
      t.timestamps
    end
  end
end
