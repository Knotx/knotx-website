This page explains how to write a blog post.

## The Blog

As you noticed on Knotx.io website, we have the blog and tutorial section. You can contribute to this sections by writing posts.

> If it's the first time you're contributing, you need to create separate PR by adding yourself to the list of contributors on knotx.io/community page. So, follow the [CONTRIBUTORS-HOWTO.md](CONTRIBUTORS-HOWTO.md) first.

## How to write post

- Fork https://github.com/knotx/knotx-website repository in order to create a pull request with your content.
- Create new branch from the `master` branch, e.g. `blog/my-blog-name`
- Inside `src/render/blog` folder create markdown file.
> Post markdown filename must be in the form `title.html.md`. For example, you want to create post with the title `My neat blog post` then filename should be `my-neat-blog-post.html.md`
- Inside `src/render/tutorials` folder create markdown file.
> - If it is only one version for tutorial, markdown filename must be in the form `tutorial-name/index.html.md`. For example, you want to create tutorial with the title `My neat tutorial post` then filename should be `index.html.md` in folder  `my-neat-tutorial-post` 
> - If it is more versions for tutorial, markdown filename must be in the form `tutorial-name/version.html.md`. For example, you want to create tutorial with the title `My neat tutorial post` for Knot.x 1.3 then filename should be `1_3.html.md` in folder  `my-neat-tutorial-post`. Last stable version should be a `target` 
metadata for redirect in index.html.md inside tutorial folder.

Remember about `knotxVersions` metadata in post.

- Content of the file must start with metadata in the header of the file:

``` md
---
title: My neat blog post
description: Short description of the post, simply excerpt
author: marcinczeczko
date: 2017-02-23
---
## Hello

This is sample blog post, etc...
...
```

Each line between the `---` lines are metadata. The **required** metadata fields are:

* **title**: the post title
* **description**: the excerpt of the post, visible on the post list
* **date**: the publication date. The date must be provided using the `YYYY-MM-DD` format
* **author**: the Github account of the author, such as `marcinczeczko` or `skejven`

After the metadata section, you can start the post. 

### Few guidelines
- Use heading sections starting from `##` for sections, then `###` for  sub-sections.
- You can use markdown styles, like lists, code snippets are delimited using ` ``` lang `, where `lang` is the language of the snippet, e.g. `json`, `java`, `javascript` and so on, ensure proper language/syntax is chosen.
- Make sure your post does not contain hard wraps.
- **Do not use tables !**

### Assets

If your post have images:
- Add them into `src/static/img/blog/a_directory_identifying_your_post`.
- Assets are references using an absolute URL such as: `/img/blog/...`.
- Please keep assets size small. 

For instance, for your neat post, you want use one asset `asset.png`, so:
- create `src/static/img/blog/my-neat-blog-post` folder
- put there your `asset.png`
- place asset on post using markdown
``` md
![Asset Title](/img/blog/my-neat-blog-post/asset.png)
```

### Making a Pull Request
Once you finish writing your post:
- create a pull request and we will review/publish your post soon.
- the pull request should only contain files related to your post.
