require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'json'

class Crawler

  def initialize
    #搜尋時直接列出所有老師所需要的參數
    @all_params = {
      "query_by" => "staff_name",
      "staff_name" => "",
      "units" => "62000000",
      "dept" => "62000000",
      "year1" => "2003",
      "year2" => "2013",
      "target_data" => "all",
      "sort_by" => "desc",
      "tpl_type" => "personal_report_css_1",
    }

    #找個人資料時所要的參數
    @per_params = {
      "staff_num" => "",
      "year1" => "2003",
      "year2" => "2013",
      "target_data" => "all",
      "sort_by" => "desc",
      "tpl_type" => "personal_report_css_1",
      }

    #要用的網址
    @url = 'http://radb.ncku.edu.tw/Personal_Report/index.php'
    @url_p = "http://radb.ncku.edu.tw/Personal_Report/result_report.php"
  end

  def getpage (url, params)
    #get page source code
    begin
      re = Net::HTTP.post_form(URI.parse(url),params)
      content = Nokogiri::HTML(re.body)
    rescue
      getpage(url, params)
    end
    return getpage(url, params) if content.nil?
    return content
  end

  def get_profile(page)
    # generate profile hash table

    info = {}
    nodes = page.css('div.cate_info_content')


    # profile
    profile = page.css('div#profile_info')
    info['相片'] ="http://radb.ncku.edu.tw/"+ page.css('image#profile_photo_image')[0]['src'][3..-1]
    info['姓名'] = profile.css('span').text
    profile.to_s.split('<br>')[1..3].each do |item|
      key, value = item.split("：").map{|i| i.strip()}
      info[key] = value
    end
    info['電子信箱'], info['實驗室'],info['個人網頁'] = profile.css('a').map{|link| link['href']}


    #education
    info['學歷'] = []
    nodes[0].css('li').each do |e|
      v = e.text.split().join(' ')
      info['學歷'].push(v)
    end

    # profile
    profile = page.css('div#profile_info')

    info['相片'] ="http://radb.ncku.edu.tw/"+ page.css('image#profile_photo_image')[0]['src'][3..-1]
    info['姓名'] = page.css('span').text

    profile.to_s.split('<br>')[1..3].each do |item|
            key, value = item.split("：").map{|i| i.strip()}
            info[key] = value
    end

    info['電子信箱'], info['實驗室'],info['個人網頁'] = profile.css('a').map{|link| link['href']}

    #experience
    info['經歷'] = nodes[1].text.strip

    #reserch interest
    info['專長及研究領域'] = nodes[2].text.strip

    #course
    info["開授課程"] = []
    nodes[3].to_s.sub(/<.*>/,'').split('<br>')[0..-2].each do |course|
      info["開授課程"] << course.split.join(' ')
    end

    # publication
    info['著作'] = {}

    nodes[4].css('h3').each_with_index do |title, t_index|
      name = title.text.strip
      info['著作'][name] = []

      title.next_element.css('li').each_with_index do |item, i_index|
        str = item.text

        if t_index == 0
          str = str.gsub('[link]','')
        elsif t_index == 1
          if str.include? '，;，[link]'
            str = str.gsub('，;，[link]','')
          else
            str = str.gsub('，[link]','')
          end
        end

        info['著作'][name].push(str)
      end
    end

    #patent
    info['專利']=[]
    nodes[5].css('li').each do |item|
      str = item.text
      info['專利'].push(str)
    end

    #Service Job
    info['兼任職務']={}
    nodes[6].css('h3').each do |title|
      name = title.text.strip
      info['兼任職務'][name] = []

      title.next_element.css('li').each do |item|
        str = item.text
        info['兼任職務'][name].push(str)
      end
    end

    #Academic Activities
    info['學術活動']={}
    nodes[7].css('h3').each do |title|
      name = title.text.strip
      info['學術活動'][name] = []

      title.next_element.css('li').each do |item|
        str = item.text
        info['學術活動'][name].push(str)
      end
    end

      return info
  end

  def output (data, dept_name)
    result_path = './teacher-result'
    Dir.mkdir(result_path) unless File.directory? result_path
    begin
      File.open(result_path + "/#{dept_name}.json","w") do |f|
        f.write(data.to_json)
      end
    rescue => ex
      puts ex.message
    end
  end

  def main
    
    profiles = []
    temp = ""

    all_page = getpage(@url, @all_params)
    data_list = all_page.css('table.datatable')[1]

    data_list.css('tr')[1..-1].each_with_index do |row, index|
      
      unit, dept, staff_num = row.css('td')
      unit = unit.text
      dept = dept.text
      staff_num = staff_num.css('a')[0]['onclick'][11,8] # 取得員工編號

      @per_params['staff_num'] = staff_num
      per_page = getpage(@url_p, @per_params) # 取得教師資料頁面
      
      if index == 0
        temp = dept
        profiles << get_profile(per_page)
      else
        if temp == dept 
          profiles << get_profile(per_page)
        else
          puts "#{temp} ok"
          output(profiles,temp)
          profiles = []
          profiles << get_profile(per_page)
          temp = dept
        end
      end
    end
  end
end


app = Crawler.new
app.main


