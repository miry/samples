# frozen_string_literal: true

require 'test_helper'

class CreateBookmarkServiceTest < ActiveSupport::TestCase
  def setup
    @params = { url: 'http://bing.com/flights', title: 'Bing Flights!' }
  end

  def test_invalid_bookmark
    @service = BookmarkService.new(nil)
    bookmark = @service.perform
    assert(bookmark)
    assert(bookmark.invalid?)
  end

  def test_create_bookmark
    bookmark = BookmarkService.new(@params).perform
    assert(bookmark.id)
    assert(bookmark.valid?)
  end

  def test_init_site_with_url
    bookmark = BookmarkService.new(@params).perform
    assert_equal('http://bing.com', bookmark.site.url)
  end

  def test_use_existing_site
    existing_site = Site.create! url: 'http://bing.com'
    bookmark = BookmarkService.new(@params).perform
    assert_equal(existing_site.id, bookmark.site.id)
  end
end
