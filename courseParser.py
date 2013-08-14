# -*- coding: utf-8 -*-  

import urllib  

courseWeb = urllib.urlopen("http://140.116.165.74/qry/qry001.php?dept_no="+"AA")  
webContent = courseWeb.read().decode('utf_8')  
courseWeb.close()  

import HTMLParser  

added = False
formStart = False
columnStart = False

result = [] 
course = []

class courseHTMLParser(HTMLParser.HTMLParser):  

	def handle_starttag(self, tag, attrs): 
		global  added , course , formStart ,columnStart

		if tag == 'tr':
			formStart = True
			course = []
		if tag == 'td' :
			columnStart = True
			added = False
	
	def handle_data(self, data):
		global added , course, formStart ,columnStart
		
		if formStart == True:
			if data.strip() == "":
				added = True
				course.append('empty')
			else:
				if added ==True and columnStart == True:
					course[ len(course)-1 ] += " " + data.strip()
				else:	
					added = True
					course.append( data.strip() )
	
	def handle_endtag(self, tag): 
		global added , course , formStart ,columnStart , result

		if tag == 'tr':
			formStart = False
			result.append(course)
		if tag == 'td':
			column = False
			if added == False:
				course.append('empty')
  
	
	def unknown_decl(self, data):
		"""Override unknown handle method to avoid exception"""  
        pass  
  
Parser = courseHTMLParser()  
  
try:  
    # 將網頁內容拆成一行一行餵給Parser  
    for line in webContent.splitlines():  
        # 如果出現停止旗標，停止餵食資料，並且跳出迴圈  
        if hasattr(Parser, 'stop') and Parser.stop:  
            break  
        Parser.feed(line)  
except HTMLParser.HTMLParseError, data:  
    print "# Parser error : " + data.msg  
  
Parser.close()  
  
  
title = [ "系所名稱" , "系號" , "序號" , "課程碼" , "分班碼" , "班別" , "年級" , "類別" , "英語授課" , "課程名稱 (連結課程地圖)" , "選必修" , "學分" , "教師姓名 *:主負責老師" , "已選課人數 " , "餘額 " , "時間" , "教室" , "備註" , "限選條件" , "業界專家參與" , "屬性碼" , "跨領域學分學程" ] 

result[0] = title
  
#raw_input()

for i in range(0,len(result)):
	for j in range( 0 , len(result[i]) ):
		print "%d  %s" %(j+1,result[i][j])
	print "\n"
