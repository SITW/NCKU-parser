#encoding=UTF-8

require 'nokogiri'
require 'open-uri'
require 'json'
require 'ruby-progressbar'

url = "http://mis.osa.ncku.edu.tw/club2/club/actquery.php?sdate=&edate=&orgtype=O&orgid=0&squery=send"

doc = Nokogiri::HTML(open(url).read, nil, 'big5')

event_info = []

progressbar = ProgressBar.create(:format => '%a |%b>>%i| %p%% %t')

doc.css('//center/a').each_with_index do |p, i|
  progressbar.total = i+1
end

doc.css('//center/a').each_with_index do |p, i|
  url_page = "http://mis.osa.ncku.edu.tw/club2/club/actquery.php?sdate=&edate=&orgtype=O&orgid=0&page=#{i+1}&squery=send"
  doc_per_page = Nokogiri::HTML(open(url_page).read, nil, 'big5')
  doc_per_page.css('//td/a').each do |q|
    event_url = "http://mis.osa.ncku.edu.tw/club2/club/" + q['href']
    doc_event =  Nokogiri::HTML(open(event_url).read, nil, 'big5')
    info = {}
    doc_event.css('//table/tr').each do |r|
      progressbar.refresh
      td1, td2 = r.xpath('./td')
      title = td1.content
      content = td2.content
      info[title] = content
    end
    event_info << info
  end
  progressbar.increment
end


result_path = '../club-event-result'
Dir.mkdir(result_path) unless File.directory? result_path
begin
  File.open(result_path + "/club_event_result.json","w") do |f|
    f.write(event_info.to_json)
  end
rescue => ex
  puts ex.message
end