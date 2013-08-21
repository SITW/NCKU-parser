#encoding=UTF-8

require 'nokogiri'
require 'open-uri'
require 'json'
require 'ruby-progressbar'

progressbar = ProgressBar.create(:format => '%a |%b>>%i| %p%% %t')

club_url = Nokogiri::HTML(open('http://mis.osa.ncku.edu.tw/club2/test02/assquery.php'))

club_data = {}
club_info = []
def parse_club_to_json(key)
  club_info_url = Nokogiri::HTML(open("http://mis.osa.ncku.edu.tw/club2/club_new/club_detail_view.php?orgid=#{key}").read, nil, 'big5')
  info = {}
  club_info_url.css('//table/tr').each do |p|
    td1, td2 = p.xpath('./td')
    tmp_title = td1.content.delete(' ')
    title = case tmp_title
    when '社團編號'
      'serial'
    when '社團名稱(中)'
      'name'
    when '社團名稱(英)'
      'name_eng'
    when '社長姓名'
      'president'
    when '輔導老師'
      'teacher'
    when '社團宗旨'
      'aim'
    when '社團簡介'
      'description'
    when '例行活動時間'
      'operating_hour'
    when '主要活動場地'
      'place'
    when '網頁網址'
      'url'
    end
    content = td2.content
    info[title] = content
  end
  return info
end

club_url.css('//#man_list_2/option').each_with_index do |p, i|
  club_id = p["value"]
  club_name = p.content
  club_data[club_id] = club_name
  progressbar.total = i+1
end


club_data.each do |key, value|
  # puts "Parsing " + club_data[key]
  progressbar.increment
  club_info << parse_club_to_json(key)
end

result_path = '../club-result'
Dir.mkdir(result_path) unless File.directory? result_path
begin
  File.open(result_path + "/to_eng.json","w") do |f|
    f.write(club_info.to_json)
  end
rescue => ex
  puts ex.message
end