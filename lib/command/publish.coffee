# Complete build pipeline
chalk = require 'chalk'

# Import other commands
fetch   = require './fetch'
extract = require './extract'
build   = require './build'
deploy  = require './deploy'

exports.run = (args) ->
  console.log chalk.bold.blue '\n→ Publishing Dictionary\n'

  try
    # Run pipeline stages
    console.log chalk.blue '→ Fetching sources...'
    await fetch.run []

    console.log chalk.blue '\n→ Extracting words...'
    await extract.run []

    console.log chalk.blue '\n→ Building dictionary...'
    await build.run []

    console.log chalk.blue '\n→ Deploying to Firefox...'
    await deploy.run []

    console.log chalk.bold.green '\n✓ Dictionary published!'

  catch error
    console.log chalk.red "\n✗ Pipeline failed: #{error.message}"
    process.exit 1