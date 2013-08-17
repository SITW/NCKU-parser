# -*- coding: utf-8 -*-

import urllib, HTMLParser, os, errno, re

#courseWeb = urllib.urlopen("http://140.116.165.74/qry/qry001.php?dept_no="+"H3")
#webContent = courseWeb.read().decode('utf_8')
#courseWeb.close()


added = False
formStart = False
columnStart = False
result = []
course = []

title = [ "系所名稱" , "系號" , "序號" , "課程碼" , "分班碼" , "班別" , "年級" , "類別" , "英語授課" , "課程名稱 (連結課程地圖)" , "選必修" , "學分" , "教師姓名 *:主負責老師" , "已選課人數 " , "餘額 " , "時間" , "教室" , "備註" , "限選條件" , "業界專家參與" , "屬性碼" , "跨領域學分學程" ]

departNum=["A2","A3","A4","A5","A6","AA","AH","AN","C0","XZ","A1","A7","A8","A9","AG","B1","K1","B2","K2","B3","K3","B5","K5","K4","C1","L1","C2","L2","C3","L3","C4","L4","F8","L7","LA","VF","E0","E1","N1","E3","N3","E4","N4","E5","N5","E6","N6","E8","N8","E9","N9","F0","F1","P1","F4","P4","F5","P5","F6","P6","F9","P8","N0","NA","NB","NC","Q4","H1","R1","H2","R2","H3","R3","H4","R4","H5","R5","R0","R6","R7","R8","R9","RA","RB","RC","RD","RZ","I2","T2","I3","T3","I5","I6","T6","I7","T7","S0","S1","S2","S3","S4","S5","S6","S7","S8","S9","T1","T4","T8","T9","TA","TB","TC","D2","U2","U6","D4","D5","U5","D8","U7","U1","U3","E2","N2","F7","P7","ND","P9","Q1","Q3","Q5","Q6","V1","V2","V3","V4","V5","V6","V7","V8","V9","VA","VB","VC","VD","VE","VG","VH","VJ","VK","E7","N7","F2","P2","F3","P3","PA","C5","L5","L6","L8","Z0","Z1","Z2","Z3","A2","A3","A4","A5","A6","AA","AH","AN","C0","XZ","A1","A7","A8","A9","AG","B1","K1","B2","K2","B3","K3","B5","K5","K4","C1","L1","C2","L2","C3","L3","C4","L4","F8","L7","LA","VF","E0","E1","N1","E3","N3","E4","N4","E5","N5","E6","N6","E8","N8","E9","N9","F0","F1","P1","F4","P4","F5","P5","F6","P6","F9","P8","N0","NA","NB","NC","Q4","H1","R1","H2","R2","H3","R3","H4","R4","H5","R5","R0","R6","R7","R8","R9","RA","RB","RC","RD","RZ","I2","T2","I3","T3","I5","I6","T6","I7","T7","S0","S1","S2","S3","S4","S5","S6","S7","S8","S9","T1","T4","T8","T9","TA","TB","TC","D2","U2","U6","D4","D5","U5","D8","U7","U1","U3","E2","N2","F7","P7","ND","P9","Q1","Q3","Q5","Q6","V1","V2","V3","V4","V5","V6","V7","V8","V9","VA","VB","VC","VD","VE","VG","VH","VJ","VK","E7","N7","F2","P2","F3","P3","PA","C5","L5","L6","L8","Z0","Z1","Z2","Z3"]

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
        course.append(u'empty')
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
        course.append(u'empty')


  def unknown_decl(self, data):
    """Override unknown handle method to avoid exception"""
    pass

def mainProcess(fileName):
  courseWeb = urllib.urlopen("http://140.116.165.74/qry/qry001.php?dept_no="+fileName)
  webContent = courseWeb.read().decode('utf_8')
  courseWeb.close()
  Parser = courseHTMLParser()

  try:
    for line in webContent.splitlines():
      if hasattr(Parser, 'stop') and Parser.stop:
        break
      Parser.feed(line)
  except HTMLParser.HTMLParseError, data:
    print "# Parser error : " + data.msg

  Parser.close()
  result[0] = title

  inputFile = open("./result/"+ fileName+".json" , 'w' )
  print ("Open File" + fileName )
  inputFile.write("[\n")
  for i in range (1,len(result)):
    inputFile.write("\t{\n")
    for j in range (0 , len( result[i]) ):
      result[0][j] = re.sub(' +', ' ', result[0][j])
      result[i][j] = re.sub(' +', ' ', result[i][j])
      inputFile.write( "\t\t\"%s\":\"%s\"" % ( result[0][j] , result[i][j].encode('utf-8') ) )
      if j is not len(result[i])-1:
        inputFile.write(",\n")
      else:
        inputFile.write( "\n")
    inputFile.write("\t}")
    if i is not len(result)-1:
      inputFile.write( ",\n")
  inputFile.write("\n]")
  inputFile.close()
  print ("Close File" + fileName )

def mkdir_p(path):
  try:
    os.makedirs(path)
    print ("Create a Dir ./result")
  except OSError as exc: # Python >2.5
    if exc.errno == errno.EEXIST and os.path.isdir(path):
      print ("Dir already exists")
      pass
    else: raise

mkdir_p("./result")
for i in range(len(departNum)):

  added = False
  formStart = False
  columnStart = False
  result = []
  course = []

  if(departNum[i]=="RZ"):
    continue
  mainProcess(departNum[i])
