This page explains how to write a blog post for Knot.x website.

## The Blog

As you noticed on Knotx.io website, we have a blog section. You can contribute to this section by writing blog posts.

> If it's the first time you're contributing, you need to create separate PR by adding yourself to the list of contributors on knotx.io/community page. So, follow the [CONTRIBUTORS-HOWTO.md](CONTRIBUTORS-HOWTO.md) first.

## How to write post

- Fork https://github.com/knotx/knotx-website repository in order to create a pull request with your content.
- Create new brnach from the `master` branch, e.g. `blog/my-blog-name`
- Inside `src/render/blog` folder create markdown file.
> Post markdown filename must be in the form `title.html.md`. For example, you want to create post with the title `My neat blog post` then filename should be `my-neat-blog-post.html.md`
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
* **description**: excerpt of the post, visible on the post list
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
- create a pull request and will review/publish your post soon.
- The pull request should only contain the file related to your post.
