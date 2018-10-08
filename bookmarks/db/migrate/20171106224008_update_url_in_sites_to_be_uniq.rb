# frozen_string_literal: true

class UpdateUrlInSitesToBeUniq < ActiveRecord::Migration[5.1]
  def change
    remove_index :sites, :url
    add_index :sites, :url, unique: true
  end
end
