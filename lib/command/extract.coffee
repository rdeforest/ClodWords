# Extract words from sources
{readFileSync} = require 'fs'
yaml           = require 'js-yaml'
chalk          = require 'chalk'

# Import extractors
extractors =
  scowl:   require '../helper/extractors/scowl'
  webster: require '../helper/extractors/webster'
  moby:    require '../helper/extractors/moby'

loadConfig = ->
  yaml.load readFileSync 'config.yaml', 'utf8'

exports.run = (args) ->
  config = loadConfig()

  # Use global data from fetch
  sourceData = global.clodSourceData

  unless sourceData
    console.log chalk.yellow '⚠ No source data available'
    console.log 'Run "cake fetch" first'
    return {}

  global.clodWordLists = {}

  for name, data of sourceData
    source = config.sources[name]
    extractor = extractors[source.processor]

    unless extractor
      console.log chalk.red "✗ No extractor for #{source.processor}"
      continue

    try
      console.log chalk.blue "→ Extracting #{name}..."
      words = await extractor.extract data, source
      global.clodWordLists[name] = words
      console.log chalk.green "  ✓ Extracted #{words.length} words"
    catch error
      console.log chalk.red "  ✗ Failed: #{error.message}"

  global.clodWordLists