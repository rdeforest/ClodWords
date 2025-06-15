# Show current ClodWords status
{readFileSync, existsSync, statSync} = require 'fs'
yaml                                 = require 'js-yaml'
chalk                                = require 'chalk'

formatSize = (bytes) ->
  kb = Math.round bytes / 1024
  if kb > 1024
    "#{(kb / 1024).toFixed 1}MB"
  else
    "#{kb}KB"

formatAge = (mtime) ->
  age = Date.now() - mtime
  mins = Math.floor age / 60000
  hours = Math.floor mins / 60
  days = Math.floor hours / 24

  if days > 0
    "#{days}d ago"
  else if hours > 0
    "#{hours}h ago"
  else if mins > 0
    "#{mins}m ago"
  else
    'just now'

exports.run = (args) ->
  console.log chalk.bold '\nClodWords Status\n'

  # Config status
  if existsSync 'config.yaml'
    config = yaml.load readFileSync 'config.yaml', 'utf8'
    sources = Object.entries config.sources
    enabled = sources.filter ([,s]) -> s.enabled

    console.log chalk.green '✓ Configuration'
    console.log "  • #{sources.length} sources (#{enabled.length} enabled)"
    console.log "  • #{config.firefox.profiles.length} Firefox profiles"
  else
    console.log chalk.red '✗ No configuration'
    console.log '  Run "cake init" to start'
    return

  # Dictionary status
  if existsSync config.output.dict_path
    stat = statSync config.output.dict_path
    content = readFileSync config.output.dict_path, 'utf8'
    words = content.trim().split('\n').length

    console.log chalk.green '\n✓ Dictionary built'
    console.log "  • #{words.toLocaleString()} words"
    console.log "  • #{formatSize stat.size}"
    console.log "  • Updated #{formatAge stat.mtime}"
  else
    console.log chalk.yellow '\n⚠ No dictionary built'
    console.log '  Run "cake publish" to build'

  # Deployment status
  if config?.firefox?.profiles?.length > 0
    console.log '\nDeployment:'
    deployed = 0

    for profile in config.firefox.profiles
      dictPath = "#{profile}/#{config.firefox.dict_filename}"
      if existsSync dictPath
        stat = statSync dictPath
        console.log chalk.green "  ✓ #{profile}"
        console.log chalk.gray "    Updated #{formatAge stat.mtime}"
        deployed++
      else
        console.log chalk.yellow "  ⚠ #{profile}"
        console.log chalk.gray "    Not deployed"

    if deployed is 0
      console.log chalk.yellow '\n⚠ Not deployed to any profiles'
      console.log '  Run "cake deploy" after building'

  console.log ''