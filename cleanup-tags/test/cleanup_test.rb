# -*- coding: utf-8 -*-
require 'minitest/autorun'
require_relative '../lib/cleanup3.rb'

class TestCleanup < MiniTest::Unit::TestCase

  def test_remove_tags
    assert_equal 'some should be.', remove_tags('some <tags>should be</removed>.') 
    assert_equal 'some should be.', remove_tags('some <tags>should be</removed>.') 
    assert_equal 'some should be.', remove_tags('<nested>some</wrongtag> <tags>should be</removed><nested>.') 
  end

  def test_remove_unwanted_lines
    # 如果某一行只有开头的横线，那么删除该行
    # 这是xml转markdown之后遗留的一些问题
    lines = <<-eof
- first line
-
- second line
-
eof

    expected = <<-eof
- first line
- second line
eof
    assert_equal expected, remove_unwanted_lines(lines)

  end

  def test_squeez_lines 
    assert_equal "line1\n\nline2", squeez_lines("line1\n\n\nline2")
    assert_equal "newline at the beginning\n\nline2", squeez_lines("\n\n\nnewline at the beginning\n\n\n\n\nline2")
   assert_equal "line1\n\nnewline at the end\n", squeez_lines("line1\n\n\n\n\nnewline at the end\n\n\n")
    assert_equal "", squeez_lines("       ")# 只有spache和tab等
  end

  def test_replace_html_entities
    assert_equal '"', replace_html_entities('&quot;')
    assert_equal '"some words"', replace_html_entities('&quot;some words&quot;') 
  end


end
