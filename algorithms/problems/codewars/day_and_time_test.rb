# frozen_string_literal: true

require 'minitest/autorun'

require_relative 'day_and_time.rb'

class DayAndTimeTest < Minitest::Test
  def test_zero_diff
    assert_equal 'Sunday 00:00', day_and_time(0)
  end

  def test_minus_three
    assert_equal 'Saturday 23:57', day_and_time(-3)
  end

  def test_plus_minutes
    assert_equal 'Sunday 00:45'  , day_and_time(45)      
    assert_equal 'Sunday 12:39'  , day_and_time(759)     
    assert_equal 'Sunday 20:36'  , day_and_time(1236)    
  end

  def test_next_day
    assert_equal 'Monday 00:07'  , day_and_time(1447)    
  end

  def test_cases
    assert_equal 'Friday 10:32'  , day_and_time(7832)    
    assert_equal 'Saturday 02:36', day_and_time(18876)   
    assert_equal 'Thursday 23:40', day_and_time(259180)   
    assert_equal 'Tuesday 15:20' , day_and_time(-349000) 
  end
end
