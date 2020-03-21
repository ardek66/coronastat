import json, httpclient, times, strformat, strutils, sequtils, unidecode
import options, table

Parse()

var 
  requestURL = "https://corona.lmao.ninja/"
  client = newHttpClient()
  node: JsonNode
  countryMode = false

if country == "":
  requestURL &= "all"
else:
  if country == "all":
    requestURL &= "countries"
  else:
    requestURL &= "countries/" & country

  countryMode = true

let data = client.getContent(requestURL)

node = parseJson(data)

var
  cases: int
  deaths: int
  recovered: int
  lastUpdated: string
  output: string

if country != "all":
  cases     = node["cases"].getInt()
  deaths    = node["deaths"].getInt()
  recovered = node["recovered"].getInt()

if not countryMode:
  let unixStart = parse("1970-01-01", "yyyy-MM-dd")
  let now = initDuration(milliseconds = node["updated"].getInt())

  lastUpdated = $(unixStart + now)

  output = fmt"cases: {cases} deaths: {deaths} recovered: {recovered} last updated: {lastUpdated}"
else:
  if country != "all":
    if showNew:
      var
        newCases  = node["todayCases"]
        newDeaths = node["todayDeaths"]

      output = fmt"new cases: {newCases} ; new deaths: {newDeaths}"
    else:
      output = fmt"cases: {cases} ; deaths: {deaths} ; recovered: {recovered}"
  else:
    var 
      countries: seq[seq[string]]
      i = 0

    for item in node.items:
      var row: seq[string]
      row.add(intToStr(i + 1))
      row.add(unidecode(item["country"].getStr()))
      row.add(intToStr(item["cases"].getInt()))
      row.add(intToStr(item["deaths"].getInt()))
      row.add(intToStr(item["recovered"].getInt()))
      countries.add(row)
      inc i

    PrintTable(@["", "country", "cases", "deaths", "recovered"], countries)

echo output