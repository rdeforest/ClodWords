# Configure ClodWords settings
{readFileSync, writeFileSync} = require 'fs'
yaml                          = require 'js-yaml'
chalk                         = require 'chalk'
{detectProfiles}              = require '../helper/firefox'

loadConfig = ->
  try
    yaml.load readFileSync 'config.yaml', 'utf8'
  catch
    console.log chalk.red '✗ No config.yaml found'
    console.log 'Run "cake init" first'
    process.exit 1

saveConfig = (config) ->
  writeFileSync 'config.yaml', yaml.dump config

showConfig = (config, section = null) ->
  if section
    if config[section]?
      console.log chalk.bold "\n#{section}:"
      console.log yaml.dump config[section]
    else
      console.log chalk.red "✗ Unknown section: #{section}"
  else
    console.log chalk.bold '\nCurrent Configuration:'
    console.log yaml.dump config

configureBrowser = (config) ->
  console.log chalk.blue '→ Detecting Firefox profiles...'

  detected = detectProfiles()
  current  = config.firefox.profiles

  if detected.length is 0
    console.log chalk.yellow '⚠ No profiles detected'
    console.log 'Please specify profile paths manually'
    return config

  console.log chalk.green "✓ Found #{detected.length} profiles:"
  for p, i in detected
    status = if p in current then '✓' else ' '
    console.log "  #{status} #{i+1}. #{p}"

  # For now, just use all detected
  config.firefox.profiles = detected
  console.log chalk.green '✓ Updated profile list'

  config

exports.run = (args) ->
  config = loadConfig()

  if args.length is 0
    showConfig config
    return

  [cmd, ...params] = args

  switch cmd
    when 'show'
      showConfig config, params[0]

    when 'browser', 'firefox'
      config = configureBrowser config
      saveConfig config

    when 'set'
      if params.length < 2
        console.log chalk.red '✗ Usage: cake configure set <path> <value>'
        return

      [path, value] = params
      # Simple dot notation for now
      parts = path.split '.'
      obj = config

      for part, i in parts[...-1]
        obj[part] ?= {}
        obj = obj[part]

      obj[parts[-1..][0]] = value
      saveConfig config
      console.log chalk.green "✓ Set #{path} = #{value}"

    else
      console.log chalk.red "✗ Unknown command: #{cmd}"
      console.log 'Try: show, browser, set'