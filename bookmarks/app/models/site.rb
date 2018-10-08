# frozen_string_literal: true

class Site < ApplicationRecord
  has_many :bookmarks, dependent: :destroy

  validates :url, url: { root: true }, uniqueness: true
end
