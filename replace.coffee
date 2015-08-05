
through = require 'through2'
gutil = require 'gulp-util'
path = require 'path'
urljoin = require 'url-join'

c = (str) ->
  "\x1B[34m#{str}\x1B[39m"

gutil.log gutil.colors.red('gulp-rev-manifest-replace is no longer maintained, use Webpack or gulp-rev-all instead')

module.exports = (options) ->
  options = options or {}
  unless options.base?
    throw new Error 'options.base has to be a string of an absolute path'
  unless options.manifest?
    throw new Error 'options.manifest is required'

  sortFunc = (a, b) ->
    if a.fullpath.length == b.fullpath.length
      0
    else if a.fullpath.length > b.fullpath.length
      -1
    else
      1

  through.obj (file, enc, callback) ->
    outfile = file.clone()
    contents = String outfile.contents
    paths = []
    for fullpath, wanted of options.manifest
      paths.push { fullpath: fullpath, wanted: wanted }
    paths = paths.sort sortFunc
    for pathObj in paths
      fullpath = pathObj.fullpath
      wanted = pathObj.wanted
      short = path.relative options.base, fullpath
      if options.path?
        short = path.join options.path, short
      if options.cdnPrefix?
        wanted = urljoin options.cdnPrefix, wanted
      if path.sep is '\\'
        short = short.replace /\\/g, '/'
      parts = contents.split short
      if parts.length > 1
        logPath = path.relative options.base, file.path
        gutil.log "Rev replacing #{c short} to #{c wanted} in #{c logPath}"
      contents = parts.join wanted
    outfile.contents = new Buffer contents
    @push outfile
    callback()
