
Gulp rev manifest replace
------

Plugin to replace assets urls based on generated manifest file.
As it sounds like, it needs to be used after [`gulp-rev`][rev] created the `rev-manifest.json`.

[rev]: https://github.com/sindresorhus/gulp-rev

### Usage

```
npm i -D gulp-rev-manifest-replace
```

The way it works is to read files and replace patterns listed in the manifest.

This plugin is created for projects with simple pages like single pages apps.
And we still need tool replacing links to put them on CDNs.
There are nice plugins like [`gulp-rev-replace`][revReplace],
but suppose we write HTML in Jade, or the way we using CDN differently.
I think it can me easier with tools like this.

[revReplace]: https://github.com/jamesknelson/gulp-rev-replace

##### Options

* `base`(**required**): `<absolute filepath>`

Since `rev-manifest.json` provides absolute paths, I have to figure out the relative ones.

* `manifest`(**required**): `<JSON>`

The generated manifest, and in JSON.

* `path`(optional): `<url in absolute path>`

If `path` is added, it will be prefixed to the relative path as the searching pattern.

* `cdnPrefix`(optinal): `<url>`

If `cdnPrefix` is specified, it willbe prepended to the replace results.

So, to replace:

```jade
if config.dev
  script(src="/site/build/a.js")
else
  img(src="/site/images/b.png")
```

to:

```jade
if config.dev
  script(src="http://tiye.me/cdn/build/a.js")
else
  img(src="http://tiye.me/cdn/images/b.png")
```

You may need this(the demo is in fake code though):

```coffee
rev = require 'gulp-rev'
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
  .pipe replaceRev
    base: __dirname
    manifest: manifest
    path: '/site'
    cdnPrefix: 'http://tiye.me/cdn/'
  .pipe gulp.dest('dist/build/')

  gulp
  .src ['views/*.jade']
  .pipe replaceRev
    base: __dirname
    manifest: manifest
    path: '/site'
    cdnPrefix: 'http://tiye.me/cdn/'
  .pipe gulp.dest('dist/views/')
```

### License

MIT
