# -*- coding: utf-8 -*-
require 'fileutils'
require 'minitest/autorun'

# usage: script.rb inputfolder outputfolder
# BUG: /home/WTF/got-me/inputfolder will be renamed to
#      /home/wtf/got_me/outputfolder
# !! I don't know how to solve the problem :(
# I want to run the sanitize function only on inputfolder and its subfolder
# But how?

$input = File.expand_path(ARGV[0].chomp('/'))
$output = File.expand_path(ARGV[1].chomp('/'))
def sanitize(title)
  # 不要替换 / 否则路径分割符号也被替换了
  # 因为下面的file是含有路径的
  # 也不要替换英文句号，因为作为文件后缀分割符号
  # 例子： "source//TLF/PBS自由选择/PBS.自由选择_2_/_PBS自由选择_PBS.Free_to_Choose_1990.Vol.4"
  title = title.tr(' `~!@#$%^&*()_+=\|][{}"\';:>,<-', '_')
  title = title.tr('？ －·～！@#￥%……&*（）——+、|】』【『‘“”；：。》，《', '_')
  title = title.gsub(/_+/, '_').gsub(/^_/, '').gsub(/_$/, '') # 对开头，结尾和多个 _ 做处理
  title = title.gsub('_/', '/') #如果路径分割前后有下划线也不要
  title = title.gsub('/_', '/')
  # 不知何时引入了多个连续的 // 可这 连续的 // 给我伤害
  # 哦，我知道何时引入的了，是ARGV[0]没有chomp掉目录的结尾 /
  title = title.gsub(/\/\/+/, '/')
  title = title.downcase
#  title = title.gsub(/srt$/i,'srt' ) # 为了后面匹配文件名后缀方便，都换成小写
#  title = title.gsub(/ass$/i,'ass' )
end
def recursive_rename(input, output)
  input = $input
  output = $output
  Dir.glob("#{input}/**/*").each do |file|
    next if File.directory? file
    # p file # file已经是展开的绝对目录了
    normalized_fn = sanitize(file)
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

# begiin tests
# 现在每次运行这个脚本都会test一下
# 单独test还需要加上两个假的ARGV参数 ruby script.rb a b
class TestSanitize < MiniTest::Unit::TestCase

  def test_sanitize
    assert_equal "this_is_a_title", sanitize('this is-a title ')
    assert_equal "经常_有_中_文_符_号", sanitize('经常@!有#中$文%&符*（号）')
    assert_equal "开头结尾有很多空格", sanitize('  开头结尾有很多空格   ')
    assert_equal "/home/WTF/got-me/input_folder", sanitize('  /home/WTF/got-me/input-folder   '), 'FIXME: do not sanitize root folder!'
  end

end
