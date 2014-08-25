
through = require 'through2'
gutil = require 'gulp-util'
path = require 'path'

c = (str) ->
  "\x1B[34m#{str}\x1B[39m"

module.exports = (options) ->
  options = options or {}
  unless options.base?
    throw new Error 'options.base has to be a string of an absolute path'
  unless options.manifest?
    throw new Error 'options.manifest is required'
  through.obj (file, enc, callback) ->
    outfile = file.clone()
    contents = String outfile.contents
    for fullpath, wanted of options.manifest
      short = path.relative options.base, fullpath
      if options.path?
        short = path.join options.path, short
      if options.cdnPrefix?
        wanted = path.join options.cdnPrefix, wanted
      parts = contents.split short
      if parts.length > 1
        logPath = path.relative options.base, file.path
        gutil.log "Rev replacing #{c short} to #{c wanted} in #{c logPath}"
      contents = parts.join wanted
    outfile.contents = new Buffer contents
    @push outfile
    callback()
