# frozen_string_literal: true

require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def setup
    @site = Site.new url: 'http://google.com'
  end

  def test_create_minimal
    @site.save!
  end

  def test_dont_create_without_url
    @site.url = nil
    assert(@site.invalid?)
  end

  def test_dont_create_with_empty_url
    @site.url = ''
    assert(@site.invalid?)
  end

  def test_dont_create_with_invalid_url
    @site.url = 'booom'
    assert(@site.invalid?)
  end

  def test_dont_create_with_uri_path
    @site.url = 'http://google.com/path'
    assert(@site.invalid?)
  end

  def test_url_is_uniq
    @site.save!
    with_same_url = Site.new url: 'http://google.com'
    assert(with_same_url.invalid?)
  end
end
