# -*- coding:utf-8 -*-

import urllib , HTMLParser , os ,re

courseIndex = urllib.urlopen("http://140.116.165.74/qry/index.php")
webContent = courseIndex.read().decode('utf_8')
courseIndex.close()

departmentNo = []
departmentName = []

class departmentHTMLParser(HTMLParser.HTMLParser):

  def handle_data(self,data):
    if data.find('( ') >= 0:
      departmentNo.append(data[3:5])
      departmentName.append(re.sub(' +',' ',data[7:]))

Parser = departmentHTMLParser()

try:
  for line in webContent.splitlines():
    if hasattr(Parser,'stop') and Parser.stop:
      break
    Parser.feed(line)
except HTMLParser.HTMLParseError,data:
  print "error" + data.msh
Parser.close()

result = []

inputFile = open('departmentComparisonTable.json','w')
inputFile.write("[\n")
for i in range(len(departmentNo)):
  inputFile.write("\t\"%s\":" %(departmentNo[i]))
  inputFile.write("\"%s\"" %departmentName[i].encode('utf-8'))
  if i is not len(departmentNo)-1:
    inputFile.write(",\n")
  else:
    inputFile.write("\n]")
