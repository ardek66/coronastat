import json, httpclient, times, strformat
import options

Parse()

var 
  requestURL = "https://corona.lmao.ninja/"
  client = newHttpClient()
  node: JsonNode
  countryMode = false

if country == "":
  requestURL &= "all"
else:
  requestURL &= "countries/" & country
  countryMode = true

let data = client.getContent(requestURL)

node = parseJson(data)

var
  cases      = node["cases"].getInt()
  deaths     = node["deaths"].getInt()
  recovered  = node["recovered"].getInt()
  lastUpdated: string
  output: string

if not countryMode:
  let unixStart = parse("1970-01-01", "yyyy-MM-dd")
  let now = initDuration(milliseconds = node["updated"].getInt())

  lastUpdated = $(unixStart + now)

  output = fmt"cases: {cases} deaths: {deaths} recovered: {recovered} last updated: {lastUpdated}"
else:
  if showNew:
    var
      newCases  = node["todayCases"]
      newDeaths = node["todayDeaths"]

    output = fmt"new cases: {newCases} ; new deaths: {newDeaths}"
  else:
    output = fmt"cases: {cases} ; deaths: {deaths} ; recovered: {recovered}"

echo output