
Gulp rev manifest replace
------

Plugin to replace assets urls based on generated manifest file.

### Usage

```
npm i -D gulp-rev-manifest-replace
```

The way it works is to read files and replace patterns recorded in the manifest.

#### Options

* `base`(required): `<absolute filepath>`

Since `rev-manifest.json` provides absolute paths, I have to figure out the relative ones.

* `manifest`(required): `<JSON>`

The generated manifest, and in JSON.

A demo:

```coffee
replace = require 'gulp-rev-manifest-replace'

# generate manifest first
gulp.task 'rev', ['clean-dist'], ->
  gulp
  .src ['build/*.js', 'build/*.css', 'images/*'], base: './'
  .pipe rev()
  .pipe gulp.dest('dist/')
  .pipe rev.manifest()
  .pipe gulp.dest('./')

# begin to replace
gulp.task 'replace', ['rev'], ->

  manifest = require './rev-manifest.json'

  gulp
  .src ['dist/build/*.css']
  .pipe replaceRev(base: __dirname, manifest: manifest)
  .pipe gulp.dest('dist/build/')

  gulp
  .src ['views/*.jade']
  .pipe replaceRev(base: __dirname, manifest: manifest)
  .pipe gulp.dest('dist/views/')
```

### License

MIT