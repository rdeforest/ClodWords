# Deploy dictionary to Firefox
{readFileSync, existsSync, symlinkSync, unlinkSync, copyFileSync} = require 'fs'
{join, resolve}                                                    = require 'path'
yaml                                                               = require 'js-yaml'
chalk                                                              = require 'chalk'

loadConfig = ->
  yaml.load readFileSync 'config.yaml', 'utf8'

deployToProfile = (profile, dictPath, config) ->
  target = join profile, config.firefox.dict_filename
  source = resolve dictPath

  # Remove existing if present
  if existsSync target
    if config.firefox.backup_original
      backup = "#{target}.backup"
      copyFileSync target, backup unless existsSync backup
    unlinkSync target

  # Deploy as symlink or copy
  if config.firefox.create_symlinks
    symlinkSync source, target
    console.log chalk.green "  ✓ Linked to #{profile}"
  else
    copyFileSync source, target
    console.log chalk.green "  ✓ Copied to #{profile}"

exports.run = (args) ->
  config = loadConfig()

  unless existsSync config.output.dict_path
    console.log chalk.red '✗ No dictionary built yet'
    console.log 'Run "cake build" first'
    return

  profiles = config.firefox.profiles

  if profiles.length is 0
    console.log chalk.yellow '⚠ No Firefox profiles configured'
    console.log 'Run "cake configure browser" first'
    return

  console.log "Deploying to #{profiles.length} profiles..."

  for profile in profiles
    unless existsSync profile
      console.log chalk.yellow "  ⚠ Profile not found: #{profile}"
      continue

    try
      deployToProfile profile, config.output.dict_path, config
    catch error
      console.log chalk.red "  ✗ Failed: #{error.message}"

  console.log chalk.bold '\nRestart Firefox to use new dictionary'