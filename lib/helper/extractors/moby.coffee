# Extract words from Moby wordlists
AdmZip = require 'adm-zip'

exports.extract = (buffer, source) ->
  zip = new AdmZip buffer
  entries = zip.getEntries()

  words = new Set()

  # Moby has multiple word files
  wordFiles = [
    'mwords/COMMON.TXT'
    'mwords/SINGLE.TXT'
    'mwords/CROSSWD.TXT'
  ]

  for entry in entries
    continue unless entry.entryName in wordFiles

    content = entry.getData().toString 'utf8'
    items = content.split /[,\r\n]+/

    for item in items
      word = item.trim().toLowerCase()

      # Skip empty or invalid
      continue if word.length < 2
      continue if word.length > 50
      continue unless word.match /^[a-z'-]+$/

      words.add word

  Array.from words