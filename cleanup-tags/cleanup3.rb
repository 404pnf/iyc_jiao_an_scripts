# -*- coding: utf-8 -*-
require 'find'
require './lib/cleanup3.rb'

# usage script inputfile-contains-xml
# output .md file will be reside in the same folder
$input = ARGV[0]
# $output = ARGV[1]
path = $input
Find.find(path) do |file|
  next if File.directory? file
  next unless file =~ /.xml$/i
  filename = File.basename(file, '.xml')
  filepath = File.dirname file
  outputfilename = filename + '.md'
  str = remove_unwanted_lines(to_markdown(File.read(file)))
  str = squeez_lines str
  str = replace_html_entities str
  p " writing #{filepath}/#{outputfilename}"
  File.open("#{filepath}/#{outputfilename}", 'w') do |f|
    f.puts str
  end
end

  
