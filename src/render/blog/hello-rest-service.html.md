---
title: Hello Rest Service
description: "Hello Rest Service - Tutorial showing how Knot.x can be used to transform static website into dynamic one. Tutorial uses Google Books API to fetch data about books, and inject it onto HTML"
author: tomaszmichalak
date: 2017-02-23
---
## Overview

In this tutorial, we’re going to show how Knot.x can be used to quickly transform your 
static website into dynamic one. Instead of manually coded HTML presenting available books, 
we’re going to inject this data to the HTML, while data about books will come from external service.

This article concentrates on integration with service using Knot.x, instead of client side. 
In the next article we are going to compare that solution with a frontend integration.

What you’re going to learn:
- How to transform static HTML into dynamic content
- How configure Knot.x to use simple REST services to get data
- How to use data from services to dynamically populate HTML

If you want to skip configuration part and simply run the demo, please checkout
[Github/hello-rest-service](https://github.com/Knotx/knotx-tutorials/tree/master/hello-rest-service) and follow the README.md to see how to run it.
              
## Book service – the service we’re going to integrate with             

We’re going to use [Google Books API](https://developers.google.com/books/) as a service feed with books. 
To make the tutorial easy, we use very simple endpoint that [search all volumes](https://developers.google.com/books/docs/v1/using#WorkingVolumes) for the given query.

The goal is to display all volumes related to <strong>java</strong> term 
([https://www.googleapis.com/books/v1/volumes?q=java](https://www.googleapis.com/books/v1/volumes?q=java)).
Sample JSON result of the service looks like below:

``` json
{
   "kind":"books#volumes",
   "totalItems":605,
   "items":[
      {
         "kind":"books#volume",
         "id":"87totx4p3ZcC",
         "etag":"mviM5CD/Vg8",
         "selfLink":"https://www.googleapis.com/books/v1/volumes/87totx4p3ZcC",
         "volumeInfo":{
            "title":"Java in a Time of Revolution",
            "subtitle":"Occupation and Resistance, 1944-1946",
            "authors":[
               "Benedict Anderson"
            ],
            "publisher":"Equinox Publishing",
            "publishedDate":"2005-12-01",
            "description":"With remarkable scope and in scrupulous detail...",
            "pageCount":494,
            "imageLinks":{
               "smallThumbnail":"...",
               "thumbnail":",,,"
            },
            "language":"en"
         }
      },
      ...
   ]
}
```
## Run "dynamic" page
So, now it’s time to run our new "dynamic" page. Just start Knot.x using `./run.sh` command and go to `http://localhost:8092/html/books.html` in your favourite browser.

