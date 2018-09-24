---
title: Getting Started with Knot.x Stack
author: skejven
keywords: tutorial
date: 2018-09-10
layout: tutorial
knotxVersions:
  - edge
---
## Overview

We start this tutorial with great news! Finally [Knot.x Stack](https://github.com/Knotx/knotx-stack) is available.

Let's just cut to the point. In this tutorial we will configure Knot.x instance with simple page that
uses external datasource (Google API Books) to fetch the dynamic data and display it on our page.

What you’re going to learn:

- How to setup Knot.x instance using [Knot.x Stack](https://github.com/Knotx/knotx-stack)
- How to transform static HTML into dynamic content and configure Knot.x to use simple REST services to get data
- How to use data from such services to dynamically populate HTML

## Setup basic Knot.x instance

**Prerequisites**
You will need following things to use Knot.x stack:
- JDK 8
- Linux or OSX bash console (for Windows users we recommend using e.g. Ubuntu with [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)).

Download [Knot.x distribution](http://knotx.io/download) and unzip it to any repository.

For the purpose of this tutorial let's call the structure of unzipped stack `KNOTX_HOME`.
`KNOTX_HOME` which is Knot.x instance with configuration and dependencies has following structure:

```
├── bin
│   └── knotx                     // shell script used to resolve and run knotx instance
├── conf                          // contains application and logger configuration files
│   ├── application.conf          // defines all modules that Knot.x instance is running, provides configuration for Knot.x Core and global variables for other config files
│   ├── bootstrap.json            // config retriever options, defines application configuration stores (e.g. points to `application.conf` - the main configuration)
│   ├── default-cluster.xml       // basic configuration of Knot.x instance cluster
│   ├── includes                  // additional modules configuration which are included in `application.conf`
│   │   ├── actionKnot.conf
│   │   ├── hbsKnot.conf
│   │   ├── httpRepo.conf
│   │   ├── server.conf
│   │   ├── serviceAdapter.conf
│   │   └── serviceKnot.conf
│   └── logback.xml          // logger configuration
├── knotx-stack.json         // stack descriptor, defines instance libraries and dependencies
├── lib                      // contains instance libraries and dependencies, instance classpath
│   ├── list of project dependency libraries
│   ├── ...
```

Now, run
```cmd
bin/knotx run-knotx
```
to start Knot.x instance. You should see that instance is running and all its modules are starting. Following entries should appear in the `logs/knotx.log` file:
```
2018-04-17 09:48:39.849 [vert.x-eventloop-thread-0] INFO  i.k.launcher.KnotxStarterVerticle - Knot.x STARTED
      Deployed httpRepo=java:io.knotx.repository.http.HttpRepositoryConnectorVerticle [233dced4-658a-422b-870f-51f12a7ced21]
      Deployed assembler=java:io.knotx.assembler.FragmentAssemblerVerticle [9a075059-4b73-4f50-9890-d38282e2ace4]
      Deployed serviceKnot=java:io.knotx.knot.service.ServiceKnotVerticle [0c5ac5ea-a196-4678-8f11-e6af84f23e7c]
      Deployed splitter=java:io.knotx.splitter.FragmentSplitterVerticle [da1384fb-641a-4835-a313-03ecc1c42458]
      Deployed hbsKnot=java:io.knotx.knot.templating.HandlebarsKnotVerticle [41875d6a-699a-4099-969f-115292152801]
      Deployed serviceAdapter=java:io.knotx.adapter.service.http.HttpServiceAdapterVerticle [ba9429fb-ef52-4241-8c11-94977b0a30c9]
      Deployed server=java:io.knotx.server.KnotxServerVerticle [1d044822-8c95-4ae4-b2f8-6886412400eb]
```

Congratulation! That's it. You have your own basic Knot.x instance running.

## Hello Service configuration
Lets now configure Knot.x to do the magic for us.
We need to do following things:
- provide the page template, for the tutorial purpose we will use `fileSystemRepo`,
- provide the datasource, we will use the Google Books API.

> All configuration options and default values, such as address fields, for each Knot.x module are
described directly in the configuration files of those modules in `conf`.


### Templates repository configuration
By default `fileSystemRepo` is not enabled in Knot.x Stack, because it purposes are purely academical.
It is not designed to be used as production ready solution (you should use `httpRepo` there).


Edit the `conf/application.conf` file and 
- add the following entry to `modules` 
```hocon
"fileSystemRepo=io.knotx.repository.fs.FilesystemRepositoryConnectorVerticle"
```
By doing that you say Knot.x instance to start `FilesystemRepositoryConnector` with name `fileSystemRepo`. It will be later referenced by this name in configurations.

- uncomment `fileSystemRepo` in `global.address` section to define the Event Bus address of the Filesystem Repository.
```hocon
fileSystemRepo = knotx.core.repository.filesystem
```


- Save the changes in `conf/application.conf`. 
You may see that Knot.x instance reloaded modules and `fileSystemRepo` is now one of available modules. No restart required!

```
      Deployed httpRepo=java:io.knotx.repository.http.HttpRepositoryConnectorVerticle [c81f07ae-9345-482a-bd7f-af3e261876e0]
      Deployed assembler=java:io.knotx.assembler.FragmentAssemblerVerticle [d8010ea9-6b65-482b-a37c-2139bf154413]
      Deployed serviceKnot=java:io.knotx.knot.service.ServiceKnotVerticle [db7b7503-71e0-40e0-adde-9012c885d581]
      Deployed splitter=java:io.knotx.splitter.FragmentSplitterVerticle [ed249e56-92c3-486d-827a-ad506a7e0ac3]
      Deployed hbsKnot=java:io.knotx.knot.templating.HandlebarsKnotVerticle [b19ea9d2-59ed-4926-9365-3579af42895b]
      Deployed fileSystemRepo=java:io.knotx.repository.fs.FilesystemRepositoryConnectorVerticle [0879f874-1276-44b9-b746-585ab19f7d25]
      Deployed serviceAdapter=java:io.knotx.adapter.service.http.HttpServiceAdapterVerticle [9caebb6a-18ed-474f-9182-56efdd180771]
      Deployed server=java:io.knotx.server.KnotxServerVerticle [0c5f5136-c925-4f93-88b3-d24233a54988]
```

Now, let's configure `fileSystemRepo` to read files from the local filesystem.

Create `content` directory in `KNOTX_HOME` and put there following page template with Knot.x snippet (`<script data-knotx-knots="services,handlebars">...`):

*books.html*
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Knot.x</title>
  <link href="https://bootswatch.com/4/superhero/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-sm-12">
      <div class="panel panel-default">
        <div class="panel-heading">Books list</div>
        <div class="panel-body">
          This page lists Java related books provided by <a
            href="https://www.googleapis.com/books/v1/volumes?q=java">Googleapis book service</a>.
        </div>
      </div>
    </div>
  </div>
  <div class="row">
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

    </div>
</div>
</body>
</html>
```

Create `conf/includes/fileSystemRepo.conf` file with the following: 
```hocon
# Event bus address on which the File System Repository connector listens on. Default is 'knotx.core.repository.filesystem'
# Here below, we use a global constant defined in `conf/application.conf`
address = ${global.address.fileSystemRepo}
# Path to the directory on the local filesystem which will be the root for requested templates
catalogue = "./content/"
```
This way we define the `content` directory that will to be our file repository.


Next we need to reference it at the end of `conf/application.conf` file by adding the following:

```hocon
config.fileSystemRepo {
  options.config {
    include required("includes/fileSystemRepo.conf")
  }
}
```



Replace `httpRepo` with  `fileSystemRepo` in `conf/server.conf` in  `defaultFlow` section.

```hocon
...
# Configuration of a default flow - aka Templating mode
defaultFlow {
  # List of the Knot.x templates repositories supported by the Server
  repositories = [
    {
      path = ".*"
      address = ${global.address.fileSystemRepo}
    }
  ]
...
```

### Connecting the datasource
As you probably noticed in the template snippet, `bookslist` datasource is defined (`data-knotx-service="bookslist"`).
Let's now define it in the configuration.

To do so, open `conf/includes/dataBridge.conf` and add `bookslist` service:
```hocon
# Event bus settings
address = ${global.bridge.address}
# List of mappings between service aliases and datasources.
# You can define here as many service definitions as required for your project.
dataDefinitions = [
  # Definition of the single datasource to be used in the HTML snippets.
  # You can define an array of such services here.
  {
    # Name of the service that will be used in HTML snippets
    name = bookslist
    # Arbitrary parameters to be send to service adapter. In this case we send the query that is part of request path to google books API
    params {
      path= "/books/v1/volumes?q=java"
    }
    # Event bus address of the service adapter that is responsible for handling physicall communication with a data source
    adapter = ${global.bridge.dataSource.http.address}
  }
]
```
Now, as we have `bookslist` datasource, let's edit `conf/includes/dataSourceHttp.conf` file and configure Adapter available under `knotx.adapter.service.http`.


Set up service entry and enable SSL by setting ssl = true in the clientOptions configuration.

```hocon
# Event bus address of the Basic HTTP Datasource
address = ${global.bridge.dataSource.http.address}

clientOptions {
  maxPoolSize = 1000
  idleTimeout = 120 # seconds
  # If your datasources are using SSL you'd need to configure here low level details on how the
  # SSL connection is to be maintaned. Currently, if configured all defined in 'datasources' section
  # will use SSL
  ssl = true
}

# List of datasource services that are supported by this datasource adapter.
# You can define here as many service definitions as required for your project.
services = [
  {
    # A regexp.
    # Any request to the service made by the adapter, is being made to the service with a given
    # physical conenction details, only if the given path matching this path regexp
    path = "/books.*"
    # A domain or IP of actual HTTP service the adapter will talk to
    domain =  "www.googleapis.com"
    # HTTP port of the service, since this is SSL connection, port wourld be 443
    port = 443
    # List of request headers that will be send to the given service endpoint.
    # Each header can be use wildcards '*' to generalize list, we pass all headers here.
    # For the purpose of this tutorial, we deny all request headers.
    allowedRequestHeaders = [ ]
    # Additional request query parameters to be send in each request. We don't need here any.
    queryParams {}
    # Additional headers to be send in each request to the service. We don't need here any.
    additionalHeaders {}
  }
]

# Statically defined HTTP request header sent in every request to any datasource
customRequestHeader {
  name = X-User-Agent
  value = Knot.x
}
```

Save configuration file, Knot.x will reload its modules once again.

The last thing left, open [http://localhost:8092/books.html](http://localhost:8092/books.html) - Voilà!
