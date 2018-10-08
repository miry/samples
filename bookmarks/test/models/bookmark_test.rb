# frozen_string_literal: true

require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
  def setup
    @site = Site.create! url: 'http://google.com'
    @bookmark = Bookmark.new(site_id: @site.id, title: 'Google App', url: 'http://google.com/app')
  end

  def test_valid
    assert(@bookmark.valid?)
  end

  def test_invalidate_without_site
    @bookmark.site_id = nil
    assert(@bookmark.invalid?)
  end

  def test_invalidate_with_unexisting_id
    @bookmark.site_id = -1
    assert(@bookmark.invalid?)
  end

  def test_invalid_without_url
    @bookmark.url = nil
    assert(@bookmark.invalid?)
  end

  def test_invalid_with_empty_url
    @bookmark.url = ''
    assert(@bookmark.invalid?)
  end

  def test_invalid_with_bad_url
    @bookmark.url = 'boom'
    assert(@bookmark.invalid?)
  end

  def test_invalidate_without_title
    @bookmark.title = nil
    assert(@bookmark.invalid?)
  end

  def test_invalidate_with_empty_title
    @bookmark.title = ''
    assert(@bookmark.invalid?)
  end

  def test_short_does_not_require
    @bookmark.short = nil
    assert(@bookmark.valid?)
  end
end
