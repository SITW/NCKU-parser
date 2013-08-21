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
    title = td1.content
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
  File.open(result_path + "/club_result.json","w") do |f|
    f.write(club_info.to_json)
  end
rescue => ex
  puts ex.message
end