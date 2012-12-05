# -*- coding: utf-8 -*-
require_relative '../lib/sanitize_title.rb'
require 'minitest/autorun'

$input = 'test'
$output = 'test'
class TestSanitize < MiniTest::Unit::TestCase
  INPUT = '/home/WTF/got-me/input'
  SIZE = INPUT.size
  FILENAME = '/home/WTF/got-me/input/some-file_With-8*&^.txt'
  def test_sanitize
    assert_equal "this_is_a_title", sanitize('this is-a title ')
    assert_equal "经常_有_中_文_符_号", sanitize('经常@!有#中$文%&符*（号）')
    assert_equal "开头结尾有很多空格", sanitize('  开头结尾有很多空格   ')
    assert_equal "/home/WTF/got-me/input/some_file_with_8.txt", INPUT + sanitize(FILENAME[SIZE..-1]), 'FIXME: do not sanitize root folder!'
  end
end


