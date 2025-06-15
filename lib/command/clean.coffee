# Clean temporary files
{rmSync, existsSync} = require 'fs'

exports.run = (args) ->
  cleaned = []

  # Clean dist if requested
  if args[0] is '--all'
    if existsSync 'dist'
      rmSync 'dist', recursive: true, force: true
      cleaned.push 'dist/'

  if cleaned.length > 0
    console.log "✓ Cleaned: #{cleaned.join ', '}"
  else
    console.log 'Nothing to clean'

  if args[0] isnt '--all' and existsSync 'dist'
    console.log 'Use "cake clean --all" to remove built dictionary'