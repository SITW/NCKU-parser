# NCKU-parser

Refined the data of NCKU

##Usage

- Course Parser:
Course Parser is a Parser to parse courses of NCKU

```
python course-parser/courseParser.py
```

- Club Parser
Club Parser is a Parser to parse club info of NCKU

```
ruby club-parser/club-parser.rb
```

- Club Event Parser
Club Event Parser is a Parser to parse club event info of NCKU

```
ruby club-event-parser/club-event-parser.rb
```

> When Using ruby parser have error msg, run :


- Club activity year fragment

Required: npm, nodejs

```
node club-event-parser/club-event-yfragment.js
```

> seperate activities into year fragment


```
gem install ruby-progressbar
gem install nokogiri
gem install json
gem install open-uri
```

Author
---

[@Lee-W](https://github.com/lee-w) -> course parser

[@garylai1990](https://github.com/garylai1990) -> activity parser, club parser

[@chilijung](https:?/github.com/chilijung) -> activity seperate into fragment(month, year units)
