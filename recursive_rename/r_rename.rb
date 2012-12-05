# -*- coding: utf-8 -*-
require_relative './lib/sanitize_title.rb'
require 'fileutils'
require 'minitest/autorun'

# usage: script.rb inputfolder outputfolder

$input = File.expand_path(ARGV[0].chomp('/'))
# 我只想对绝对目录的最后一个目录进行sanitize
# BUG: /home/WTF/got-me/inputfolder will be renamed to
#      /home/wtf/got_me/outputfolder
# 我只会用这种笨方法 ^_^
$char_count_of_higher_path = $input.size
$output = File.expand_path(ARGV[1].chomp('/'))
def recursive_rename(input, output)
  input = $input
  output = $output
  Dir.glob("#{input}/**/*").each do |file|
    next if File.directory? file
    # p file # file已经是展开的绝对目录了
    normalized_fn = $input + sanitize(file[$char_count_of_higher_path..-1])
    newfilename = normalized_fn.sub("#{$input}", "#{$output}") 
    # p normalized_fn
    # p newfilename
    path = File.dirname(normalized_fn)
    newpath = path.sub(input, output)
    FileUtils.mkdir_p(newpath) unless File.exist?(newpath)
    # p newpath
    # next unless newfilename =~ /(srt|ass)$/i
    FileUtils.cp(file, newfilename, :verbose => true)
  end  
end
recursive_rename($input, $output)
