import strutils

proc GetColumnWidths(table: seq[seq[string]], headers: seq[string]): seq[int] =
  result = newSeq[int](headers.len)

  for i in 0..table.len - 1:
    for j in 0..headers.len - 1:
      if table[i][j].len > result[j]:
        result[j] = table[i][j].len

  for i in 0..headers.len - 1:
    if headers[i].len > result[i]:
      result[i] = headers[i].len

proc PrintFillerLine(str: var string, widths: seq[int]) =
  str &= "+"

  for width in widths:
    str &= repeat('-', width + 2)
    str &= "+"

  str &= "\n"

proc PrintLine(str: var string, row: seq[string], columnWidths: seq[int]) =
  str &= "|"

  for i, val in row:
    str &= " "

    str &= val & repeat(' ', columnWidths[i] - val.len)

    str &= " |"

  str &= "\n"

proc PrintTable*(headers: seq[string], values: seq[seq[string]]) =
  var str = ""

  var
    columnWidths = values.GetColumnWidths headers
    tableWidth = headers.len + 1 + headers.len * 2

  for width in columnWidths:
    tableWidth += width

  str.PrintFillerLine columnWidths

  str.PrintLine(headers, columnWidths)

  str.PrintFillerLine columnWidths

  for row in  values:
    str.PrintLine(row, columnWidths)
    str.PrintFillerLine columnWidths

  echo str