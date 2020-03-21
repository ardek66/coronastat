import parseopt, os, strutils, strformat
import globals

type
  OptionCallback* = proc(val: string)

  Option* = object
    long*: string
    short*: string
    description*: string
    callback*: OptionCallback

var
  options*: seq[Option]
  country* = ""
  showNew* = false

proc GetOptionLength(option: Option): int =
  return (option.short & ", " & option.long).len()

proc GetLongestOption(): int =
  result = 0
  for option in options:
    let len = GetOptionLength(option)
    if len > result:
      result = len

proc PrintVersion() =
  echo &"Coronastat Version {version}"
  echo &"Compiled at {CompileDate} {CompileTime}"
  echo &"Author: {author}"

proc VersionCallback(val: string) =
  PrintVersion()
  quit()

proc HelpCallback(val: string) =
  PrintVersion()
  echo "\nOptions:"

  for option in options:
    stdout.write(&"\t-{option.short}, --{option.long}")
    
    let descPos = GetLongestOption() + 4
    let diff = descPos - GetOptionLength(option)

    stdout.write(' '.repeat(diff))
    echo option.description

  quit()

proc Parse*() =
  options.add(Option(long: "version", short: "v", description: "show version info", callback: VersionCallback))
  options.add(Option(long: "help", short: "h", description: "show help", callback: HelpCallback))
  options.add(Option(long: "country", short: "c", description: "set country", callback: (proc (val: string) = country = val)))
  options.add(Option(long: "new", short: "n", description: "only shows new data(only works if a country is specified)", callback: (proc (val: string) = showNew = true)))

  let args = commandLineParams().join(" ")

  var opt = initOptParser(args)

  while true:
    opt.next()
    case opt.kind
      of cmdEnd: break
      of cmdShortOption:
        for option in options:
          if option.short == opt.key:
            option.callback(opt.val)
      of cmdLongOption: 
        for option in options:
          if option.long == opt.key:
            option.callback(opt.val)
      of cmdArgument: break