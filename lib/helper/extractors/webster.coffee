# Extract words from Webster's 1913
exports.extract = (buffer, source) ->
  content = buffer.toString 'utf8'
  words = new Set()

  # Webster's format: headwords in CAPS
  # Skip BOM if present
  content = content.replace /^\uFEFF/, ''

  lines = content.split /\r?\n/

  for line in lines
    # Look for headword lines
    match = line.match /^([A-Z][A-Z'-]+)/
    continue unless match

    word = match[1].toLowerCase()

    # Validate
    continue if word.length < 2
    continue if word.length > 50
    continue unless word.match /^[a-z'-]+$/

    words.add word

  Array.from words