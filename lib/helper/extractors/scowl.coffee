# Extract words from SCOWL wordlist
AdmZip = require 'adm-zip'

exports.extract = (buffer, source) ->
  zip = new AdmZip buffer
  entries = zip.getEntries()

  words = new Set()

  # SCOWL has numbered word lists
  # Higher numbers = more obscure words
  # We want all of them
  for entry in entries
    name = entry.entryName

    # Skip non-wordlist files
    continue unless name.match /\b(english|american|british|canadian)-\w+\.\d+$/
    continue if name.includes 'abbreviations'
    continue if name.includes 'proper-names'

    # Extract words from this file
    content = entry.getData().toString 'utf8'
    lines = content.split /\r?\n/

    for line in lines
      word = line.trim()
      continue if word.length is 0
      continue if word.startsWith '#'

      # Basic validation
      continue if word.length < 2
      continue if word.length > 50
      continue unless word.match /^[a-zA-Z'-]+$/

      words.add word.toLowerCase()

  Array.from words