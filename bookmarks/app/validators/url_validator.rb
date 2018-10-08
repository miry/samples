# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validation_result = url_valid?(value, options[:root])
    record.errors[attribute] << (options[:message] || 'must be a valid URL') unless validation_result
  end

  def url_valid?(url, hostname_only = false)
    return false if url.nil?
    url = URI.parse(url)
    return false if hostname_only && !url.path.empty?
    url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  end
end
