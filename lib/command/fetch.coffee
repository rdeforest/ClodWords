# Fetch configured sources
{readFileSync}     = require 'fs'
yaml               = require 'js-yaml'
chalk              = require 'chalk'
{downloadSource}   = require '../helper/downloader'

loadConfig = ->
  try
    yaml.load readFileSync 'config.yaml', 'utf8'
  catch
    throw new Error 'No config.yaml found'

exports.run = (args) ->
  config = loadConfig()

  sources = Object.entries config.sources
    .filter ([n, s]) -> s.enabled
    .sort ([,a], [,b]) -> a.priority - b.priority

  if sources.length is 0
    console.log chalk.yellow '⚠ No sources enabled'
    return

  console.log "Fetching #{sources.length} sources..."

  global.clodSourceData = {}

  for [name, source] in sources
    try
      console.log chalk.blue "→ #{name}"
      data = await downloadSource name, source
      global.clodSourceData[name] = data
      size = Math.round data.length / 1024
      console.log chalk.green "  ✓ Downloaded #{size}KB"
    catch error
      console.log chalk.red "  ✗ Failed: #{error.message}"
      throw error

  # Return results for pipeline
  global.clodSourceData