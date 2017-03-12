---
title: Custom Adapter Service
description: "Custom Adapter Service Tutorial is the next step to know Knot.x. Today we will deal with the data that comes directly from the database (so no WebAPI layer this time). Just with one simple Service Adapter we will fetch the data and then let Knot.x inject it into an HTML template."
author: skejven
date: 2017-03-14
---
## Overview

Hello Knot.x users!

In this post we will show you how easily you can inject the data from a database directly to HTML page.
When developing advanced web system we are often asked to integrate some external services and use
the data from it to render some page information. It is not a rare case when the data source we integrate
with has no WebAPI or even can't have it because of security reasons. This is the case we will study
in this article.

What you're going to learn:
- How to implement a simple [Service Adapter](https://github.com/Cognifide/knotx/wiki/ServiceAdapter) 
and start using it with Knot.x.
- How to use [Vert.x](http://vertx.io/docs/vertx-jdbc-client/java/) to easily access your database 
in very performant way.

If you want to skip the configuration part and simply run the demo, please checkout 
[github/custom-service-adapter](https://github.com/Knotx/knotx-tutorials/tree/master/custom-service-adapter)
and follow the `README.md` instructions to see the final result.

# Solution Architecture

So, we have a data source with no WebAPI to integrate with via frontend.
We have two options now:

1. We can either implement the WebAPI layer to access the database 
and then integrate with it using e.g. AJAX or [HTTP adapter](http://knotx.io/blog/hello-rest-service/).
 
 or...
 
2. We may implement Knot.x [Service Adapter](https://github.com/Cognifide/knotx/wiki/ServiceAdapter).

Option (1) may be quite expensive to implement or even not possible due to security reasons.
We will focus on option (2) in this article.

The architecture of this tutorial's system will look like this:

![Solution architecture](/img/blog/custom-service-adapter/solution-architecture.png)

# Data and page

In this example we create a page that lists all books and authors from the database.
Page markup would look like this:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Knot.x</title>
  <link href="https://bootswatch.com/superhero/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-sm-12">
      <div class="panel panel-default">
        <div class="panel-heading">Books list</div>
        <div class="panel-body">
          This section lists books from the database.
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <!-- list all books here -->
  </div>

  <div class="row">
    <div class="col-sm-12">
      <div class="panel panel-default">
        <div class="panel-heading">Authors list</div>
        <div class="panel-body">
          This section lists authors from the database.
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <!-- list all authors here -->
  </div>
</div>
</body>
</html>

```

# Setup the project

We will show you how to configure custom adapter project using Maven - feel free to use any other favourite
project build tool. To build and run this tutorial code you need Java 8 and Maven.

Create `pom.xml` file with dependencies to `knotx-core` and `knotx-adapter-common`. Additional dependencies 
we will use are [`vertx-jdbc-client`](http://vertx.io/docs/vertx-jdbc-client/java/) and 
`hsqldb` driver. `<dependencies>` section of your project's `pom.xml` should look like this:

```xml
  <dependencies>
    <dependency>
      <groupId>io.knotx</groupId>
      <artifactId>knotx-core</artifactId>
      <version>1.0.0</version>
    </dependency>
    <dependency>
      <groupId>io.knotx</groupId>
      <artifactId>knotx-adapter-common</artifactId>
      <version>1.0.0</version>
    </dependency>

    <dependency>
      <groupId>io.vertx</groupId>
      <artifactId>vertx-jdbc-client</artifactId>
      <version>3.3.3</version>
    </dependency>
    <dependency>
      <groupId>org.hsqldb</groupId>
      <artifactId>hsqldb</artifactId>
      <version>2.3.4</version>
    </dependency>
  </dependencies>
```

You may simply download ready [`pom.xml`](https://github.com/Knotx/knotx-tutorials/tree/master/custom-service-adapter/pom.xml)
file from tutorial codebase.

# Implementing Adapter

In order to integrate with Knot.x we need to create a [Verticle](http://vertx.io/docs/apidocs/io/vertx/core/Verticle.html).
The easiest way to do it is to extend Vert.x [`AbstractVerticle`](http://vertx.io/docs/apidocs/io/vertx/rxjava/core/AbstractVerticle.html).

## Adapter's Heart - Verticle

Lets create a class `BooksDbAdapter` in `/src/main/java/io/knotx/tutorials/` that extends `AbstractVerticle`:

```java
package io.knotx.tutorials;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Context;
import io.vertx.core.Vertx;

public class BooksDbAdapter extends AbstractVerticle {

  @Override
  public void init(Vertx vertx, Context context) {
    super.init(vertx, context);
    // setup verticle with configuration
  }

  @Override
  public void start() throws Exception {
    // register adapter on the event bus
  }

  @Override
  public void stop() throws Exception {
    // unregister adapter when no longer needed
  }

}
```

## Configuration

Now we will create a simple configuration and its model. Configuration file defines a verticle that
will initialise the whole Service Adapter and enables to pass properties.

Create `io.knotx.example.BooksDbAdapter.json` in `/src/main/resources/`:

```json
{
  "main": "io.knotx.tutorials.BooksDbAdapter",
  "options": {
    "config": {
      "address": "knotx.adapter.service.custom",
      "clientOptions": {
         //we will put database connection options here later
      }
    }
  }
}
```

This configuration file is prepared to run this custom Service Adapter starting 
`io.knotx.tutorials.BooksDbAdapter` verticle and listening at `knotx.adapter.service.custom` address
on the event bus.

Now we implement configuration Java Model:

```java
package io.knotx.tutorials;

import io.vertx.core.json.JsonObject;

public class BooksDbAdapterConfiguration {

  private String address;

  private JsonObject clientOptions;

  public BooksDbAdapterConfiguration(JsonObject config) {
    address = config.getString("address");
    clientOptions = config.getJsonObject("clientOptions", new JsonObject());
  }

  public JsonObject getClientOptions() {
    return clientOptions;
  }

  public String getAddress() {
    return address;
  }
}
```

## Registering service proxy

Next step would be registering [`AdapterProxy`](https://github.com/Cognifide/knotx/wiki/Adapter#how-to-extend) 
that handles request. Simplest way here is to create `BooksDbAdapterProxyImpl` class 
that extends [`AbstractAdapterProxy`](https://github.com/Cognifide/knotx/blob/master/knotx-core/src/main/java/io/knotx/adapter/AbstractAdapterProxy.java):

```java
package io.knotx.tutorials.impl;

import io.knotx.adapter.AbstractAdapterProxy;
import io.knotx.dataobjects.AdapterRequest;
import io.vertx.rxjava.ext.jdbc.JDBCClient;
import rx.Observable;

public class BooksDbAdapterProxyImpl extends AbstractAdapterProxy {

  //we will need JDBC Client here to perform DB queries
  private final JDBCClient client;

  public BooksDbAdapterProxyImpl(JDBCClient client) {
    this.client = client;
  }

  @Override
  protected Observable<AdapterResponse> processRequest(AdapterRequest adapterRequest) {
    // all the Custom Adapter's work will be done here
  }

}
```

Now we should register this `AdapterProxy` in `start()` method of our `BooksDbAdapter` and setup
it with the following configuration:

```java
public class BooksDbAdapter extends AbstractVerticle {
  
  private MessageConsumer<JsonObject> consumer;
  private BooksDbAdapterConfiguration configuration;

  @Override
  public void init(Vertx vertx, Context context) {
    super.init(vertx, context);
    // using config() method from AbstractVerticle we simply pass our JSON file configuration to Java model
    configuration = new BooksDbAdapterConfiguration(config());
  }

  @Override
  public void start() throws Exception {
    //we create RX version of vertx instance to easier handle reactive programming
    final io.vertx.rxjava.core.Vertx rxVertx = new io.vertx.rxjava.core.Vertx(this.vertx);
    //create JDBC Clinet here and pass it to AdapterProxy - notice using clientOptions property here
    final JDBCClient client = JDBCClient.createShared(rxVertx, configuration.getClientOptions());

    //register the service proxy on the event bus
    consumer = ProxyHelper
        .registerService(AdapterProxy.class, this.vertx,
            new BooksDbAdapterProxyImpl(client),
            configuration.getAddress());
  }

  @Override
  public void stop() throws Exception {
    // unregister adapter when no longer needed
    ProxyHelper.unregisterService(consumer);
  }

}
```

## Fetching the data from DB

Now, when we have our adapter ready we can implement data querying logic in `BooksDbAdapterProxyImpl`:

```java
public class BooksDbAdapterProxyImpl extends AbstractAdapterProxy {
  
  @Override
  protected Observable<AdapterResponse> processRequest(AdapterRequest adapterRequest) {
    final String query = adapterRequest.getParams().getString("query");
    return client.getConnectionObservable()
        .flatMap(
            sqlConnection -> sqlConnection.queryObservable(query)
        )
        .map(this::toAdapterResponse);
  }

  private AdapterResponse toAdapterResponse(ResultSet rs) {
    final AdapterResponse adapterResponse = new AdapterResponse();
    final ClientResponse clientResponse = new ClientResponse();
    clientResponse.setBody(Buffer.buffer(new JsonArray(rs.getRows()).encode()));
    adapterResponse.setResponse(clientResponse);
    return adapterResponse;
  }
  
}
```

What we do here is:
- When there is a request in `processRequest`, the first thing we do is to get the `query` from the request object.
- Then we create an [`Observable`](http://reactivex.io/documentation/observable.html) from configured JDBC Client
 which gives us a `SQLConnection` object at which the next operation will be performed. 
- Next we perform [`flatMap`](http://reactivex.io/documentation/operators/flatmap.html) operation on `SQLConnection`
 and execute the query.
- The last thing to do is to [`map`](http://reactivex.io/documentation/operators/map.html) a `ResultSet` 
 obtained from the query execution to `AdapterResponse` which is `processRequest` method's return contract.
 To do this we simply put all query results as `ClientResponse` body.

# Integration

We have our custom adapter. Now it's time to integrate it with Knot.x and the database.

## Setup Knot.x

Create a folder where we will start Knot.x and Custom Adapter. It should contain the following parts:

```
├── knotx-standalone-1.0.0.json  (download from Maven Central)
├── knotx-standalone-1.0.0.logback.xml (download from Maven Central)
├── app
│   ├── knotx-standalone-1.0.0.fat.jar (download from Maven Central)
├── content
│   ├── local
│       ├── books.html (Contains markup of a page - see "Data and page" section)
```

You may download Knot.x files from Maven Central Repository
1. [Knot.x standalone fat jar](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.0.0/knotx-standalone-1.0.0.fat.jar)
2. [JSON configuration file](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.0.0/knotx-standalone-1.0.0.json)
3. [Log configuration file](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.0.0/knotx-standalone-1.0.0.logback.xml)

## Setup DB

For the demonstration purposes we're going to use HSQL database in this example.

Follow [this tutorial](http://o7planning.org/en/10287/installing-and-configuring-hsqldb-database)
in order to set up the database.
To create tables with data, use the script provided in [`db`](https://github.com/Knotx/knotx-tutorials/tree/master/custom-service-adapter/db) 
folder of this tutorial.

When you have your database configured, update `clientOptions` property in `io.knotx.example.BooksDbAdapter.json` file
to point the database. If you followed the tutorial and your database runs at port `9001`, configuration
file should look like this:

```json
{
  "main": "io.knotx.tutorials.BooksDbAdapter",
  "options": {
    "config": {
      "address": "knotx.adapter.service.custom",
      "clientOptions": {
        "url": "jdbc:hsqldb:hsql://localhost:9001/",
        "driver_class": "org.hsqldb.jdbcDriver"
      }
    }
  }
}
```

Build your custom adapter using maven command `mvn clean install`.
This should produce `custom-service-adapter-1.0.0-fat.jar` artifact in the `target` directory.

## Plug in Custom Adapter

All you need to do now is to simply copy `custom-service-adapter-1.0.0-fat.jar` artifact into `app` 
directory and update `knotx-standalone-1.0.0.json` configuration to add new `services`:

```json
{
  "modules": [
    "knotx:io.knotx.KnotxServer",
    "knotx:io.knotx.FilesystemRepositoryConnector",
    "knotx:io.knotx.FragmentSplitter",
    "knotx:io.knotx.FragmentAssembler",
    "knotx:io.knotx.ServiceKnot",
    "knotx:io.knotx.HandlebarsKnot",
    "knotx:io.knotx.example.BooksDbAdapter"
  ],
  "config": {
    "knotx:io.knotx.ServiceKnot": {
      "options": {
        "config": {
          "services": [
            {
              "name": "books-listing",
              "address": "knotx.adapter.service.custom",
              "params": {
                "query": "SELECT * FROM books"
              }
            },
            {
              "name": "authors-listing",
              "address": "knotx.adapter.service.custom",
              "params": {
                "query": "SELECT * FROM authors"
              }
            }
          ]
        }
      }
    }
  }
}
```

There are 2 services available thanks to configuration above:
- `books-listing` which will initiate service at `knotx.adapter.service.custom` (our Custom Adapter)
with additional `query` parameter: `SELECT * FROM books`. This query selects all records from the `books` table.
- `authors-listing` that initiates the same service but passes another query: `SELECT * FROM authors`
which selects all records from the `authors` table.

## Prepare template

The last thing left is template configuration. We want it to display the data from `books-listing` and
`authors-listing` services. This can be simply achieved by following snippets in `books.html` file:

```html
    <script data-knotx-knots="services,handlebars"
            data-knotx-service="books-listing"
            type="text/knotx-snippet">
            {{#each _result}}
              <div class="col-sm-4">
                <div class="card">
                  <div class="card-block">
                    <h2 class="card-title">{{this.TITLE}}</h2>
                    <h4 class="card-title">{{this.ISBN}}</h4>
                    <p class="card-text">
                      {{this.SYNOPSIS}}
                    </p>
                  </div>
                </div>
              </div>
            {{/each}}
    </script>
```
Which tells Knot.x to call `books-listing` service and enable the data under `_result` scope.
We iterate through `_result` since it is a list of all books fetched from the database.

```html
    <script data-knotx-knots="services,handlebars"
            data-knotx-service="authors-listing"
            type="text/knotx-snippet">
            {{#each _result}}
              <div class="col-sm-4">
                <div class="card">
                  <div class="card-block">
                    <h2 class="card-title">{{this.NAME}}</h2>
                    <h4 class="card-title">{{this.AGE}}</h4>
                  </div>
                </div>
              </div>
            {{/each}}
    </script>
```

That makes Knot.x call `authors-listing` service and put the data under `_result` scope.
We iterate through `_result` since it is a list of all authors fetched from the database.

Final markup of the template can be downloaded from our [github codebase](https://github.com/Knotx/knotx-tutorials/tree/master/custom-service-adapter/content/local/books.html).

# Run the example

Now we have all the parts ready and can run the demo.
Application directory should contain now the following artifacts:

```
├── knotx-standalone-1.0.0.json
├── knotx-standalone-1.0.0.logback.xml
├── app
│   ├── custom-service-adapter-1.0.0-fat.jar
│   ├── knotx-standalone-1.0.0.fat.jar
├── content
│   ├── local
│       ├── books.html
```

You can run the instance using command:

`java -Dlogback.configurationFile=knotx-standalone-1.0.0.logback.xml -cp "app/*" io.knotx.launcher.LogbackLauncher -conf knotx-standalone-1.0.0.json`

When you enter the page [http://localhost:8092/content/local/books.html](http://localhost:8092/content/local/books.html)
 you will see books and authors from the database listed.

Code of this whole tutorial is available in [Knot.x tutorials github](https://github.com/Knotx/knotx-tutorials/tree/master/custom-service-adapter/).
