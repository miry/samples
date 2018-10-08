# frozen_string_literal: true

class CreateBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :bookmarks do |t|
      t.references :site, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false, index: true
      t.string :short, null: false, default: ''

      t.timestamps
    end
  end
end
