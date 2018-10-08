# frozen_string_literal: true

class BookmarkService
  def initialize(params)
    @params = params || {}
    @site = nil
  end

  def perform
    find_or_create_site
    create_bookmark
  end

  private

  def extract_sitename
    result = URI.parse(@params[:url])
    result.path = ''
    result.to_s
  rescue URI::InvalidURIError
    ''
  end

  def find_or_create_site
    @site = Site.find_or_create_by(url: extract_sitename)
  end

  def create_bookmark
    Bookmark.create(@params.merge(site: @site))
  end
end
