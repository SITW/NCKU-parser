require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'json'


class Crawler
  def initialize
    # list
    @units =[
      { :name => '文學院', :unit_n => '62000000',
        :depts => {
          '文學院' => '62000000',
          '中文系' => '62030200',
          '外文系' => '62060200',
          '歷史系' => '62090200',
          '藝術所' => '62120000',
          '華語中心' => '62150500',
          '外語中心' => '62150600',
          '台文系所' => '62180000',
          '台文系' => '62180200'
        }
      },
    { :name => '理學院', :unit_n => '65000000',
      :depts => {
        '數學系' => '65030200',
        '物理系' => '65060200',
        '化學系' => '65090200',
        '地科系' => '65120200',
        '光電系所' => '65210000',
        '光電系' => '65210200',
        '電漿所' => '65270000',
        }
      },
    { :name => '工學院', :unit_n => '68000000',
      :depts => {
        '工學院' => '68000000',
        '機械系' => '68030200',
        '化工系' => '68210200',
        '資源系' => '68270200',
        '材料系' => '68300200',
        '土木系' => '68330200',
        '水利系' => '68360200',
        '工科系' => '68420200',
        '醫工系所' => '68450000',
        '醫工系' => '68450200',
        '系統系' => '68480200',
        '航太系' => '68570200',
        '民航研究所' => '68590000',
        '環工系' => '68600200',
        '測量系' => '68630200',
        '奈微所' => '68690000',
        '海事所' => '68730000',
        }
      },
    { :name => '電資學院', :unit_n => '69000000',
      :depts => {
        '製造所' => '69090000',
        '電機系' => '69120200',
        '資訊系' => '69180200',
        '光電工程系' => '69210200',
        '微電所' => '69660000',
        '醫資所' => '69710000',
        '電通所' => '69720000',
        }
      },
    { :name => '設計學院', :unit_n => '70000000',
      :depts => {
        '建築系' => '70390200',
        '都計系' => '70510200',
        '工設系' => '70540200',
        '創產所' => '70570000',
        }
      },
    { :name => '管理學院', :unit_n => '71000000',
      :depts => {
        '管理學院' => '71000000',
        '工資管系' => '71030200',
        '交管系' => '71060200',
        '企管系' => '71090200',
        '會計系' => '71120200',
        '統計系' => '71150200',
        '國企所' => '71180000',
        '資管所' => '71210000',
        '財金所' => '71240000',
        '電信所' => '71270000',
        '國經所' => '71300000',
        '體健休所' => '71330000',
        }
      },
    { :name => '醫學院', :unit_n => '74000000',
      :depts => {
        '醫學院' => '74000000',
        '醫學系' => '74030000',
        '解剖科所' => '74030201',
        '生化科所' => '74030202',
        '生理科所' => '74030203',
        '微生物科所' => '74030204',
        '藥理科所' => '74030205',
        '寄生蟲科' => '74030206',
        '病理科' => '74030207',
        '工衛科' => '74030208',
        '公衛科所' => '74030209',
        '內科' => '74030210',
        '外科' => '74030211',
        '骨科' => '74030212',
        '麻醉科' => '74030213',
        '婦產科' => '74030214',
        '小兒科' => '74030215',
        '眼科' => '74030216',
        '耳鼻喉科' => '74030217',
        '泌尿科' => '74030218',
        '皮膚科' => '74030219',
        '神經科' => '74030220',
        '精神科' => '74030221',
        '放射線科' => '74030222',
        '核醫科' => '74030223',
        '復健科' => '74030224',
        '家醫科' => '74030225',
        '口醫科所' => '74030226',
        '急診科' => '74030227',
        '法醫科' => '74030229',
        '職業及環醫科' => '74030230',
        '醫技系' => '74060200',
        '護理系' => '74090200',
        '物治系' => '74120200',
        '職治系' => '74150200',
        '臨藥科技所' => '74300000',
        '基醫所' => '74330000',
        '行醫所' => '74390000',
        '分醫所' => '74420000',
        '臨醫所' => '74450000',
        '口醫所' => '74480000',
        '健康照護所' => '74490000',
        '藥學生技所' => '74510000',
        '老年學所' => '74570000',
        }
      },
    { :name => '社科學院', :unit_n => '77000000',
      :depts => {
        '政治系' => '77010200',
        '經濟系' => '77020200',
        '政經所' => '77030000',
        '教育所' => '77040000',
        '法律系所' => '77060000',
        '法律系' => '77060200',
        '社科中心' => '77090000',
        '認知科學所' => '77150000',
        '心理學系' => '77180000',
        }
      },
    { :name => '生科學院', :unit_n => '79000000',
      :depts => {
        '生科系' => '79150200',
        '生物科技所' => '79180000',
        '生多所' => '79240000',
        '生訊所' => '79270000',
        '生資所' => '79330000',
        '熱植所' => '79360000',
        '生資生訊所' => '79390000'
        }
      }
    ]

    #以院所科系搜尋時所需要的參數
    @dept_params = {
      "query_by" => "dept",
      "staff_name" => "",
      "units" => "",
      "dept" => "",
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
    @units.each do |unit|

      @dept_params['units'] = unit[:unit_n]

      unit[:depts].each do |dept_name, dept_n|
        profiles = []

        @dept_params["dept"] = dept_n
        dept_page = getpage(@url, @dept_params) # 取得科系資料頁面

        dept_page.xpath('//form[@name="result_report_form"]//a').each do |link|
          @per_params['staff_num']=link['onclick'][11,8]
          per_page = getpage(@url_p, @per_params) # 取得教師資料頁面
          profiles << get_profile(per_page)

        end

        puts "#{dept_name} ok"
        output(profiles, dept_name)
      end
    end
  end
end

app = Crawler.new
app.main



