# Tutorial section

This page explains how to write a tutorial.

## How to write a tutorial

- Fork the https://github.com/knotx/knotx-website repository in order to create a pull request with your content.
- Create a new branch from the `master` branch, e.g. `tutorial/my-tutorial-name`
- Inside the `src/render/tutorials` folder create a folder
- Inside the `src/render/tutorials/my-tutorial-name` folder, create a markdown file.
- The markdown filename must be in the form `version.html.md`. For example, you want to create the 
tutorial for Knot.x 1.3 then the filename should be `1_3.html.md`.
- Inside the `src/render/tutorials/my-tutorial-name` folder, create a redirect file named `index.html.md`
that points to the last released version.

Please read [BLOG-HOWTO.md](BLOG-HOWTO.md) to learn the basics of blogging.

The `1_3.html.md` file contains a metadata and a content. In the metadata section we need to add
some additional entries:

```
keywords: tutorial
knotxVersions:
  - 1.3.0
  - 1.2.0
```

The `index.html.md` file contains redirect details:

```
---
...
layout: redirect
target: /tutorials/my-tutorial-name/1_3/
---
```

## Making a Pull Request
Once you finish writing your tutorial:
- create a pull request and we will review/publish your tutorial soon.
- the pull request should only contain files related to your post.
