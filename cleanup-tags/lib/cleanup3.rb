# -*- coding: utf-8 -*-

def remove_tags str
  str = str.gsub(/<[^>]+>/, '')
end
def to_markdown str
  str = str.gsub(/\r/, "\n")
  arr = str.split(/\n/).delete_if {|i| i == ''}
  r = []
  strange_lines = []
  arr.each do |line|
    if line =~ /<\/[a-z]+:[^ >]+> /i
     #  p "rdf tags?" 因为他们有英文引号这个特殊字符 <someword:otherword>
    elsif line =~ /<\/*table>/i
      r << line
    elsif line =~ /<\/*tr>/i
      r << line
    elsif line =~ /<\/*th>/i
      r << line
    elsif line =~ /<\/*td>/i
      r << line
    elsif match = line.match(/<\/*h([0-9])\s*([^>]+)*>/i)
      times = match[1].to_i
      line = remove_tags(line)
      header = '#' * times + ' '
      line = line.sub(/^/, header)
      line = "\n\n" + line + "\n\n"
      r << line
    elsif line =~ /<\/*li_title>/i
      header = '- '
      line = line.sub(/^/, header)
      r << "\n\n" + remove_tags(line) + "\n\n"
    elsif line =~ /<\/*li>/i
      header = '- '
      line = remove_tags(line)
      line = line.sub(/^/, header)
      r << remove_tags(line)  + "\n\n"
    elsif line =~ /<\/*li_label>/i
      line = remove_tags(line) 
      header = '- '
      if line.size > 3 # 如果label是真是的label，是一个符号并不含有文字，我们就忽略它 比如只是 * 
        line = line.sub(/^/, header)
        r << line + "\n\n"
      end
    elsif line =~ /<\/*normal>/i
      r << remove_tags(line) unless line == '<Normal> </Normal>' # some zh xml have many of this
    elsif line =~ /<\/*lbody>/i
      header = '- '
      line = line.sub(/^/, header)
      r << remove_tags(line) + "\n\n"
    elsif not line =~ /<\/*.+>$/i
      # to cover case like:
      # <p> some words
      # more chinese word
      # </p>
      # is it possible a case like this appear? YES!! MANY OF THEM!!
      # r << remove_tags(line) 
    elsif line =~ /^<imagedata/i
      m = line.match(/ImageData +src="([^"]+)"/)
      if m == nil
        # some src="" is empty so there is no m[1] and calling m[1] throws exception
      else
        img_url = m[1]
        line = '![](' + img_url + ')'
        line = "\n\n" + line + "\n\n"
        r << line
      end
    else
      line = remove_tags(line)
      line = "\n\n" + line + "\n\n"
      r << line
    end
  end
#  strange_lines       
#  error_msg = []
#  p  strange_lines
  File.open('error.txt', 'a') do |f| # must be append, because for each file, script will write to error.txt
    f.puts strange_lines
  end
  return r.join("\n")
end
def add_line_space str
  str.each_line do |line|
    line = "\n\n" + line + "\n\n" # add \n first
    if line =~ /\++ / # if list, remove the \n
      line = line.gsub(/\n/, '')
    end
  end
  str = str.gsub(/\n\n+/, "\n\n")
end

def remove_unwanted_lines str
  newstr = ''
  str.each_line do |line|
    line = line.sub(/^- –/, '- ')
    line = line.sub(/^- •/, '- ')
    newstr << line unless line =~ /^-\s+$/  # remove empty list
  end
  newstr
end
def squeez_lines str
  str = str.gsub(/\A\n+/, '')
  str = str.gsub(/\Z\n+/, '') # 替换后\Z后面还是会有一个\n 不知道为什么，在irb中验证
                              # 如果没有写测试发现不了这个问题
  str = str.gsub(/^\s+$/, '')
  str = str.gsub(/\n\n+/, "\n\n")
end
def replace_html_entities str
  str.gsub('&quot;', '"')
end


  
