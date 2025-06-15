# Build final dictionary
{readFileSync, writeFileSync, mkdirSync} = require 'fs'
{dirname}                                 = require 'path'
yaml                                      = require 'js-yaml'
chalk                                     = require 'chalk'

loadConfig = ->
  yaml.load readFileSync 'config.yaml', 'utf8'

applyFilters = (words, config) ->
  {min_length, max_length, allowed_chars, exclude_patterns} = config.processing

  charRegex = new RegExp "^[#{allowed_chars}]+$"
  excludes = exclude_patterns.map (p) -> new RegExp p

  words.filter (word) ->
    # Length check
    return false if word.length < min_length
    return false if word.length > max_length

    # Character check
    return false unless charRegex.test word

    # Exclusion patterns
    for pattern in excludes
      return false if pattern.test word

    true

exports.run = (args) ->
  config = loadConfig()

  wordLists = global.clodWordLists

  unless wordLists
    console.log chalk.yellow '⚠ No word lists available'
    console.log 'Run "cake extract" first'
    return

  # Combine all word lists
  console.log 'Combining word lists...'
  allWords = new Set()

  for name, words of wordLists
    for word in words
      allWords.add word

  console.log "  • Total unique: #{allWords.size}"

  # Apply filters
  console.log 'Applying filters...'
  filtered = applyFilters Array.from(allWords), config
  console.log "  • After filters: #{filtered.length}"

  # Sort
  console.log 'Sorting...'
  filtered.sort()

  # Write output
  output = config.output.dict_path
  mkdirSync dirname(output), recursive: true

  # Firefox format: one word per line
  writeFileSync output, filtered.join('\n') + '\n'

  size = Math.round(filtered.join('\n').length / 1024)
  console.log chalk.green "✓ Built #{output} (#{size}KB, #{filtered.length} words)"

  filtered.length