# KNOTX.io source repository

This repository contains Knot.x website source. The target website is generated using DocPad.

## Building
### Prerequisites

- Node.js v10.24.1
- Npm

### Bulding a dev version

If you have npm installed and want to work on website with live reload, just go to the repo and run
```
$> npm install
```
After all dependencies are downloaded run it as follows:
```
$> npm start
```
You will see something like this:
```
> knotx-website@1.0.0 start C:\repos\knotx-website
> docpad-server

info: Welcome to DocPad v6.79.0 (global installation: C:\Repos\knotx-website\node_modules\docpad)
notice: Please donate to DocPad or have your company sponsor it: http://docpad.org/donate
info: Contribute: http://docpad.org/docs/contribute
info: Plugins: cleanurls, coffeescript, eco, highlightjs, less, livereload, marked, partials, stylus
info: Environment: development
info: LiveReload listening to new socket on channel /docpad-livereload
info: Server started on http://YOUR_MACHINE_NAME:3010
info: Generating...
info: Generated 31/42 files in 3.355 seconds
OK
```
The site is started on port `3010` under you machine name:
```
http://YOUR_MACHINE_NAME:3010
```

## Contributors section

Read [CONTRIBUTORS-HOWTO.md](CONTRIBUTORS-HOWTO.md) for instructions how to add information about Contributors to the site.

## Blogs

Read [BLOG-HOWTO.md](BLOG-HOWTO.md) for instructions how to write a blog post.

## Tutorials

Read [TUTORIAL-HOWTO.md](TUTORIAL-HOWTO.md) for instructions how to write a tutorial.

1. Add additional `remote` to this repository
```
$> git remote add gh git@github.com:Knotx/knotx.github.io.git
```
2. Clean `out/` folder
3. Deploy to Github Pages
```
$> npm run-script deploy-gh
```
