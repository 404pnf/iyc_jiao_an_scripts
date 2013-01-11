# -*- coding: undecided -*-
require 'find'
require 'reverse_markdown'

=begin
Usage
-----
 1. Include ReverseMarkdown class to your application
 2. get an instance: r = ReverseMarkdown.new
 3. parse a HTML string and save the return value: markdown = r.parse_string(html_string)
=end


input = ARGV[0]
Find.find input do |f|
  next unless f =~ /\.html$/
  str = File.read(input)
  r = ReverseMarkdown
  r.print_errors   
  File.open('#{input}.md', 'w') do |f|
    f.puts markdown
  end
  p "生成文件 #{input}.md"
end
       

  
