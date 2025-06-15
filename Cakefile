# ClodWords Cakefile - Primary Interface
{existsSync, mkdirSync} = require 'fs'
chalk                   = require 'chalk'

# Ensure dist directory exists
mkdirSync 'dist', recursive: true unless existsSync 'dist'

# Core commands
commands =
  init:      require './lib/command/init'
  configure: require './lib/command/configure'
  source:    require './lib/command/source'
  publish:   require './lib/command/publish'
  fetch:     require './lib/command/fetch'
  extract:   require './lib/command/extract'
  build:     require './lib/command/build'
  deploy:    require './lib/command/deploy'
  clean:     require './lib/command/clean'
  status:    require './lib/command/status'

# Command descriptions
desc =
  init:      'Initialize ClodWords configuration'
  configure: 'View/modify configuration'
  source:    'Manage word sources'
  publish:   'Complete pipeline: fetch→build→deploy'
  fetch:     'Download configured sources'
  extract:   'Process sources into word lists'
  build:     'Combine and filter final dictionary'
  deploy:    'Install to Firefox profiles'
  clean:     'Remove temporary files'
  status:    'Show current state'

# Register tasks
for name, cmd of commands
  do (name, cmd) ->
    task name, desc[name], ->
      console.log chalk.blue "→ #{name}"
      await cmd.run process.argv[3..]

# Default task shows help
task 'default', 'Show available commands', ->
  console.log chalk.bold '\nClodWords Commands:\n'

  cmds = Object.keys(desc).sort()
  maxLen = Math.max ...(cmds.map (c) -> c.length)

  for cmd in cmds
    pad = ' '.repeat maxLen - cmd.length + 2
    console.log "  #{chalk.green 'cake'} #{chalk.yellow cmd}#{pad}#{desc[cmd]}"

  console.log '\nExamples:'
  console.log '  cake init                    # First time setup'
  console.log '  cake configure               # View config'
  console.log '  cake configure browser       # Setup Firefox'
  console.log '  cake source list             # Show sources'
  console.log '  cake source disable webster  # Skip a source'
  console.log '  cake publish                 # Build & deploy'
  console.log ''