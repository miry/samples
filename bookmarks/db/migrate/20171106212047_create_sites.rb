# frozen_string_literal: true

class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.string :url, null: false, index: true

      t.timestamps
    end
  end
end
