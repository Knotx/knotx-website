---
title: Hello Rest Service
description: "Hello Rest Service - Tutorial showing how Knot.x can be used to transform static website into dynamic one. Tutorial uses Google Books API to fetch data about books, and inject it onto HTML"
author: "tomaszmichalak"
date: "2017-02-23"
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

The goal is to display all volumes related to **java** term 
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
           "thumbnail":"..."
         },
         "language":"en"
       }
    },
    ...
  ]
}
```

## Our application
Knot.x provides the functionality that combines service data with HTML in a very efficient manner. 
It can get a JSON response from a service and then using Handlebars engine render the dynamic part. 
This can be achieved without any custom code – it is only the matter of configuration.

The diagram below depicts how a request from a user is handled with the Knot.x application.

<img src="/img/blog/hello-rest-service/books-service-diagram.jpg" class="img-responsive img-centered" alt="Books service diagram"/>

As soon as request comes to Knot.x, it initiates HTML template fetch from the repository. 
In real cases, the repository is used to be an external system like CMS that is available through HTTP. 
However for the demonstration purposes we simply get those HTML pages from local filesystem, using 
Knot.x File system repository connector.

At this point, Knot.x detects all services required to render your dynamic page. Actual service 
endpoints are defined in Knot.x configuration, on the HTML level, each dynamic part simply points 
which endpoint it requires (by name). The unique set of services required, initiates process of 
querying services for the data, followed by invocation of the Handlebars engine. Handlebars engine 
takes the markup plus data of services and produces the final markup of the dynamic HTML snippet.

Finally, the rendered HTML is returned to the requesting user.

## Start with Knot.x

Now it’s the time to prepare the environment in order to run Knot.x. 
First, let’s download required files from nexus repository and create the folder structure that we’re going to use in this tutorial.

Download the following files:
1. [Knot.x standalone fat jar](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.0.0/knotx-standalone-1.0.0.fat.jar)
2. [JSON configuration file](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.0.0/knotx-standalone-1.0.0.json)
3. [Log configuration file](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.0.0/knotx-standalone-1.0.0.logback.xml)

Additionally, download books.html file from github, that we’re going to transform into a dynamic one.

The directory three will be like this:

```
├── knotx-standalone-1.0.0.json  (download from nexus)
├── knotx-standalone-1.0.0.logback.xml (download from nexus)
├── app
│   ├── knotx-standalone-1.0.0.fat.jar (download from nexus)
├── library
│   ├── html
│       ├── books.html (Taken from our Github)
```


To simplify Knot.x execution, create run.sh script in the root folder with the following content:

```
#!/bin/bash
java -Dvertx.disableDnsResolver=true -Dlogback.configurationFile=knotx-standalone-1.0.0.logback.xml 
-cp "app/*" io.knotx.launcher.LogbackLauncher -conf knotx-standalone-1.0.0.json
```

You can try to run Knot.x application with `./run.sh` command. But for now stop it and follow next steps to configure.
More details about Knot.x deployment and setup can be found [here](https://github.com/Cognifide/knotx/wiki/KnotxDeployment).

## Configure Knot.x

<blockquote>
All the configurations used in this tutorial are available on 
<a href="https://github.com/Knotx/knotx-tutorials/tree/master/hello-rest-service" target="_blank">Github/knotx-tutorials</a>.
</blockquote>

As we already have base Knot.x setup, let’s start adopting it to our needs. 
If you open `knotx-standalone-1.0.0.json` file in text editor, you can find that it contains array 
with list of modules. These are the [Knot.x modules](https://github.com/Cognifide/knotx/wiki/KnotxModules) 
that are going to be started.

```json
{
  "modules":[
    "knotx:io.knotx.KnotxServer",
    "knotx:io.knotx.HttpRepositoryConnector",
    "knotx:io.knotx.FilesystemRepositoryConnector",
    "knotx:io.knotx.FragmentSplitter",
    "knotx:io.knotx.FragmentAssembler",
    "knotx:io.knotx.ServiceKnot",
    "knotx:io.knotx.ActionKnot",
    "knotx:io.knotx.HandlebarsKnot",
    "knotx:io.knotx.HttpServiceAdapter"
  ]
}
```

All of the above modules are explained on the project [Wiki](https://github.com/Cognifide/knotx/wiki). 
In this tutorial, we’re going to pay attention only about a few of them.

In order to change default configuration of any of the module, you need to modify 
this configuration JSON by adding `config` JsonObject for the module(s) you want to modify, e.g.:

```json
 "modules":[..],
 "config": {
   "knotx:io.knotx.KnotxServer": {
     "options": {
        "config": {
           ...
        }
      }
    }
  }
```

You can find more details on how to configure Knot.x on [Wiki – How to Configure](https://github.com/Cognifide/knotx/wiki/KnotxDeployment#how-to-configure-).

### Repository configuration

As mentioned before, we are going to fetch HTML template from our local file system. 
Knot.x is shipped with a dedicated module called [FileSystemRepositoryConnector](https://github.com/Cognifide/knotx/wiki/FilesystemRepositoryConnector)
for this purpose. You need set up the connector to use `/library` folder from where requested HTML files 
(consisting of handlebars snippets) will be fetched.

```json
  "modules": [...],
  "config": {
    "knotx:io.knotx.FilesystemRepositoryConnector": {
      "options": {
        "config": {
          "catalogue": "./library/"
        }
      }
    }
  }
```

Different repository connectors can be used, so we need to somehow tell Knot.x which one should be used. 
You can define a condition when our repository should be used, and the condition is simply a RegExp of the requested URI.

Our template file (books.html) is available in `html` folder, under `library` root folder. 
It means, that our target is that whenever user does `GET /html/books.html` request, 
the Knot.x should look for the `/html/books.html` file in `/library` folder on local file system.
In order to achieve that, we need to tell KnotxServer module that:

<blockquote>
Any request to <strong>/html/.*</strong> should fetch template from file system repository.
</blockquote>

```json
  "modules":[...],
  "config": {
    "knotx:io.knotx.FilesystemRepositoryConnector": {...},
    "knotx:io.knotx.KnotxServer": {
      "options": {
        "config": {
          "repositories": [{
            "path": "/html/.*",
             "address": "knotx.core.repository.filesystem"
          }]
        }
      }
    }
  }
```

You might notice the `address` field in the above configuration. This is the internal event bus 
address of the Repository Connector, in this case it’s the address of our File System Repository Connector.

<blockquote>
All configuration options and default values, such as address fields, for each Knot.x module are described in the 
<a href="https://github.com/Cognifide/knotx/wiki" target="_blank">Wiki documentation</a>.
</blockquote>

### Processing chain configuration

Next step, is to configure how HTML template should be processed. We want to configure that:

- Only `GET` requests with URI starting with `/html` will be allowed
- If requested template requires data from services, they should be delivered
- Handlebars engine will be used

Just change the KnotxServer module configuration as below:

```json
  "knotx:io.knotx.KnotxServer": {
    "options": {
      "config": {
        "repositories": [
          {
            "path": "/html/.*",
            "address": "knotx.core.repository.filesystem"
          }
        ],
        "routing": {
          "GET": [
            {
              "path": "/html/.*",
              "address": "knotx.knot.service",
              "onTransition": {
                "next": {
                  "address": "knotx.knot.handlebars"
                }
              }
            }
          ]
        }
      }
    }
  }
```

We added `routing` object to this configuration. As you see, we specified the request 
condition as intended. And we said Knot.x that if condition is met, the module on `knotx.knot.service`
address should process our snippets. This is the [Service Knot](https://github.com/Cognifide/knotx/wiki/ServiceKnot)
module, that in fact is responsible for an integration with external services.

Then, according to the configuration, next element in the processing chain is the 
[Handlebars Knot](https://github.com/Cognifide/knotx/wiki/HandlebarsKnot), that supposed to do 
actual evaluation of page.

### Book service configuration
The last module to configure, is the previously mentioned [Service Knot](https://github.com/Cognifide/knotx/wiki/ServiceKnot). 
The configuration of this module consists of services which can be used in any template 
processed by Knot.x. Each service has associated `name`, that is actually being used on HTML 
level and address of the Adapter that is handling the actual communication with external world.
This kind of mapping, makes possible a quick exchange of service that’s being used. 
You can supply multiple Adapter modules for any kind of protocol or interface. And as soon as 
your adapter implementation provides same structure of data, you can use it instead of other implementation.

```json
  "modules": [
    ...
  ],
  "config": {
    "knotx:io.knotx.KnotxServer": {
      ...
    },
    "knotx:io.knotx.FilesystemRepositoryConnector": {
      ...
    }
    "knotx:io.knotx.ServiceKnot": {
      "options": {
        "config": {
          "services": [
            {
              "name": "bookslist",
              "address": "knotx.adapter.service.http",
              "params": {
                "path": "/books/v1/volumes?q=java"
              }
            }
          ]
        }
      }
    }
  }
```

We’re saying here, that:
- One service will be used, and its name is `bookslist`
- The adapter address for this name is `knotx.adapter.service.http`
- Each service request using this name will be done under the path `/books/v1/volumes?q=java`

<blockquote>
As you see we specified the URI but not the address of the service. The actual endpoint will be 
configured on the Adapter level. This approach to the configuration, allows you to have two services
defined, each using same adapter (so the same endpoint also), but have different name and 
different path.
</blockquote>

The adapter address points to the [HttpServiceAdapter](https://github.com/Cognifide/knotx/wiki/HttpServiceAdapter) 
that is available out of the box. So, as you can suspect, remaining configuration 
will happen in the adapter module.

So let’s do this.

```json
  "modules": [
    ...
  ],
  "config": {
    "knotx:io.knotx.KnotxServer": {
      ...
    },
    "knotx:io.knotx.FilesystemRepositoryConnector": {
      ...
    },
    "knotx:io.knotx.ServiceKnot": {
      ...
    },
    "knotx:io.knotx.HttpServiceAdapter": {
      "options": {
        "config": {
          "clientOptions": {
            "ssl": true
          },
          "services": [
            {
              "path": "/books.*",
              "domain": "www.googleapis.com",
              "port": 443
            }
          ]
        }
      }
    }
  }
```

We’re saying here:

- HTTP Client making actual calls to HTTP service, should consider using SSL if required
- List of services to which we’re going to make calls, in our case just one
  - If the service URI starts with `/books`, e.g. `/books/v1/volumes?q=java`
  - Then use `www.googleapis.com:443`

At this point, we can say that Knot.x configuration is finished. You can download final 
configuration file [here](https://github.com/Knotx/knotx-tutorials/blob/master/hello-rest-service/knotx-standalone-1.0.0.json).

## Template definition

Now it’s the time for the markup. You started with `books.html` having only static markup. 
Now, you can modify it, by removing  book items and insert new “dynamic” snippet.

```html
<script data-knotx-knots="services,handlebars"
   data-knotx-service="bookslist"
   type="text/knotx-snippet">
   {{#each _result.items}}
     <div class="col-sm-3">
     <div class="card">
       <img class="card-img-top"
          src="{{volumeInfo.imageLinks.thumbnail}}"
          alt="{{volumeInfo.title}}">
       <div class="card-block">
         <h4 class="card-title">{{volumeInfo.title}}</h4>
         <p class="card-text">
           {{#each volumeInfo.authors as |author|}}
             {{author}}{{#unless @last}}, {{/unless}}
           {{/each}}<br />
           Published: {{volumeInfo.publishedDate}}
         </p>
       </div>
      </div>
      </div>
   {{/each}}
</script>
```

The most important elements of the above markup are:

- `data-knotx-service="bookslist"` - defines that service name `bookslist` is required,
- `_result` object in Handlebars expressions, is the root of data fetched from service,
- the path to object under `_result` is actually the path to object in the JSON returned by the service 
`https://www.googleapis.com/books/v1/volumes?q=java`

<blockquote>
Knot.x provides the extendable Handlebars mechanism, that allows you to specify very lightweight templates by implementing your own custom Handlebars helpers.
</blockquote>

The final HTML markup can be found [here](https://github.com/Knotx/knotx-tutorials/blob/master/hello-rest-service/library/html/books.html).

## Run “dynamic” page
So, now it’s time to run our new “dynamic” page. Just start Knot.x using `./run.sh` command 
and go to `http://localhost:8092/html/books.html` in your favourite browser.
