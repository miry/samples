# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :site

  validates :title, presence: true
  validates :url, url: true
end
