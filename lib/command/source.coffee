# Manage word sources
{readFileSync, writeFileSync} = require 'fs'
yaml                          = require 'js-yaml'
chalk                         = require 'chalk'

loadConfig = ->
  try
    yaml.load readFileSync 'config.yaml', 'utf8'
  catch
    console.log chalk.red '✗ No config.yaml found'
    process.exit 1

saveConfig = (config) ->
  writeFileSync 'config.yaml', yaml.dump config

listSources = (config) ->
  console.log chalk.bold '\nConfigured Sources:\n'

  sources = Object.entries config.sources
  sources.sort ([,a], [,b]) -> a.priority - b.priority

  for [name, src] in sources
    status = if src.enabled then '✓' else '✗'
    color  = if src.enabled then 'green' else 'gray'

    console.log chalk[color] "  #{status} #{name}"
    console.log chalk.gray "      Priority: #{src.priority}"
    console.log chalk.gray "      Type: #{src.processor}"
    console.log chalk.gray "      URL: #{src.url[..60]}..."
    console.log ''

findSource = (config, pattern) ->
  names = Object.keys config.sources
  matches = names.filter (n) -> n.includes pattern

  if matches.length is 0
    console.log chalk.red "✗ No source matching '#{pattern}'"
    null
  else if matches.length > 1
    console.log chalk.yellow "⚠ Multiple matches for '#{pattern}':"
    console.log "  • #{m}" for m in matches
    null
  else
    matches[0]

exports.run = (args) ->
  config = loadConfig()

  if args.length is 0
    args = ['list']

  [cmd, ...params] = args

  switch cmd
    when 'list', 'ls'
      listSources config

    when 'enable'
      for pattern in params
        if name = findSource config, pattern
          config.sources[name].enabled = true
          console.log chalk.green "✓ Enabled #{name}"
          saveConfig config

    when 'disable'
      for pattern in params
        if name = findSource config, pattern
          config.sources[name].enabled = false
          console.log chalk.yellow "✓ Disabled #{name}"
          saveConfig config

    when 'priority'
      if params.length < 2
        console.log chalk.red '✗ Usage: cake source priority <name> <number>'
        return

      [pattern, pri] = params
      if name = findSource config, pattern
        config.sources[name].priority = parseInt pri
        console.log chalk.green "✓ Set #{name} priority to #{pri}"
        saveConfig config

    else
      console.log chalk.red "✗ Unknown command: #{cmd}"
      console.log 'Try: list, enable, disable, priority'