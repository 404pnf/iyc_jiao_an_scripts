# -*- coding: utf-8 -*-

require 'find'
require 'micro-optparse'
#require 'reverse_mardkown'

options = Parser.new do |p|
  p.banner = "转html到markdown的脚本。支持目录递归"
  p.version = " 0.0.1"
  p.option :reverse_markdown, '使用reverse_markdown', :default => nil
  p.option :verbose, '运行时显示更多信息', :default => nil
end.process!

p options

input = ARGV[0].chomp('/')
output = ARGV[1].chomp('/')
p "输入目录是#{input}" if options[:verbose]

Find.find input do |f|
  next unless f =~ /\.html/
  output_file = f.sub(input, output)
                 .sub(/\.html$/, '.md')
  output_path = File.dirname output_file
  Dir.mkdir output_path unless File.directory? output_path
  system "pandoc -f html -t markdown #{f} > #{output_file}"
end
