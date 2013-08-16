# -*- coding:utf-8 -*-

import urllib 

courseIndex = urllib.urlopen("http://140.116.165.74/qry/index.php")
webContent = courseIndex.read().decode('utf_8')
courseIndex.close()

import HTMLParser

departmentNo = []
departmentName = []

class departmentHTMLParser(HTMLParser.HTMLParser):

	def handle_data(self,data):
		if data.find('( ') >= 0:
#			print "%s" %data[3:5]
			departmentNo.append(data[3:5])
			departmentName.append(data[7:])

Parser = departmentHTMLParser()

try:
	for line in webContent.splitlines():
		if hasattr(Parser,'stop') and Parser.stop:
			break
		Parser.feed(line)
except HTMLParser.HTMLParseError,data:
	print "error" + data.msh
Parser.close()

for i in range(len(departmentName)):
	print departmentName[i]

