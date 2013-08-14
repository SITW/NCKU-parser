# -*- coding: utf-8 -*-  

import urllib  

courseWeb = urllib.urlopen("http://140.116.165.74/qry/qry001.php?dept_no=H3")  
webContent = courseWeb.read().decode('utf_8')  
courseWeb.close()  

import HTMLParser  

count = 0 
counter = 0
title = []

class courseHTMLParser(HTMLParser.HTMLParser):  

	def handle_starttag(self, tag, attrs): 
		if tag == 'tr':# or tag == 'tr':
			print u'%s' % (tag) , 
	
#	def handle_startendtag(self, tag, attrs):
#		print u'空標籤 %s %s' % (tag, attrs)  
  
	def handle_endtag(self, tag):  
		if tag == 'tr':
			print u'%s\n' % tag  
  
	def handle_data(self, data):
		if data.find("  ") is not -1 and data.find("\t") != 1 :
			print " ",
		else:
			print u'%s' % (data),
#		global count,counter
#		count = count +1
#		if count > 64:
#			if data.find("  ") is not -1 and data.find("\t") != 1 :
#				print " "  ,
#			else:
 #				print "%s" %  (data),
#		if (count - 64) % 20 == 0:
#				print "\n"
 #   def handle_comment(self, data):  
  #      print u'註解 "%s"' % data  
	
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
  
#raw_input()  
