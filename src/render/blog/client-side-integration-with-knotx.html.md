---
title: Client-side integration approach with Knot.x
description: "There are two main concepts of integrating external services into your system: client-side and backend. Both approaches have strong sides which used in smart way will benefit your solution. However, they both have weak sides which might bring you many unwanted worries. Knot.x supports both approaches, bringing out their pros and limiting their cons. In this tutorial we will show you how to use Knot.x Gateway to create a consistent Web API for your client-side integration."
author: skejven
keywords: tutorial
order: 6
date: 2017-06-30
---
## Overview
Hello _Knoters_ !

It's been some time since the last technical tutorial, so let's just get straight to the point.

This tutorial explains how to use [Knot.x Gateway](https://github.com/Cognifide/knotx/wiki/GatewayMode) to create a consistent
Web API for your client-side integration. It was originally presented as part of Devoxx PL 2017 talk.

![Gateway API](/img/blog/client-side-integration-with-knotx/knotx-gateway-api.png)

What you are going to learn:

- How to implement a simple Gateway module / microservice.
- How to configure Knot.x as your Web API endpoint.

If you want to skip the configuration part and simply run the demo, please checkout
[github/knotx-tutorials/devox2017](https://github.com/Knotx/knotx-tutorials/tree/master/conferences/devoxx2017)
and follow the instructions in `README.md` to compile and run the complete code.

## Case
This time it will be a really simple case. We have to render a graph with markets forecast for the oil prices.
Since we already have a JS library that will create a graph for us, we just need to deliver the data and the result will look like this:

![Forecast graph](/img/blog/client-side-integration-with-knotx/graph.png)

Let's start with creating a new maven module and let's call it `market-api`.

Create a `pom.xml` file with dependencies on `knotx-core` and `knotx-gateway`.
Let's call the module `market-api`:

```xml
  <groupId>io.knotx.examples</groupId>
  <artifactId>market-api</artifactId>
  <version>1.0</version>
```

The `<dependencies>` section of your project's `pom.xml` should look like this:

```xml
<dependencies>
  <dependency>
    <groupId>io.knotx</groupId>
    <artifactId>knotx-gateway</artifactId>
    <version>1.1.0</version>
  </dependency>
  <dependency>
    <groupId>io.knotx</groupId>
    <artifactId>knotx-core</artifactId>
    <version>1.1.0</version>
  </dependency>
</dependencies>
```

You may simply download a ready [`pom.xml`](https://github.com/Knotx/knotx-tutorials/tree/master/conferences/devoxx2017/examples/market-api/pom.xml)
file from the tutorial codebase.

## Gateway Request Processor

Now, let's create an `AbstractVerticle` which will register our gateway module on the Event Bus under configured address.

```java
package io.knotx.example.gateway;

import io.knotx.gateway.configuration.KnotxGatewayKnotConfiguration;
import io.knotx.proxy.KnotProxy;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Context;
import io.vertx.core.Vertx;
import io.vertx.core.eventbus.MessageConsumer;
import io.vertx.core.json.JsonObject;
import io.vertx.core.logging.Logger;
import io.vertx.core.logging.LoggerFactory;
import io.vertx.serviceproxy.ProxyHelper;
import io.knotx.example.gateway.impl.RequestProcessorKnotProxyImpl;

public class RequestProcessorKnotVerticle extends AbstractVerticle {

  private static final Logger LOGGER = LoggerFactory.getLogger(RequestProcessorKnotVerticle.class);

  private KnotxGatewayKnotConfiguration configuration;

  private MessageConsumer<JsonObject> consumer;

  @Override
  public void init(Vertx vertx, Context context) {
    super.init(vertx, context);
    this.configuration = new KnotxGatewayKnotConfiguration(config());
  }

  @Override
  public void start() throws Exception {
    LOGGER.info("Starting <{}>", this.getClass().getSimpleName());
    consumer = ProxyHelper
        .registerService(KnotProxy.class, vertx,
            new RequestProcessorKnotProxyImpl(),
            configuration.getAddress());

  }

  @Override
  public void stop() throws Exception {
    ProxyHelper.unregisterService(consumer);
  }
}

```

The next step is to create `RequestProcessorKnotProxyImpl` which is an `AbstractKnotProxy`.
This is the place where a response will be created:

```java
package io.knotx.example.gateway.impl;

import io.knotx.dataobjects.ClientResponse;
import io.knotx.dataobjects.KnotContext;
import io.knotx.knot.AbstractKnotProxy;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.http.HttpHeaders;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import java.util.NoSuchElementException;
import java.util.Set;
import rx.Single;

public class RequestProcessorKnotProxyImpl extends AbstractKnotProxy {

  @Override
  protected Single<KnotContext> processRequest(KnotContext knotContext) {
    return Single.just(createSuccessResponse(knotContext));
  }

  @Override
  protected boolean shouldProcess(Set<String> knots) {
    return true;
  }

  @Override
  protected KnotContext processError(KnotContext knotContext, Throwable error) {
    HttpResponseStatus statusCode;
    if (error instanceof NoSuchElementException) {
      statusCode = HttpResponseStatus.NOT_FOUND;
    } else {
      statusCode = HttpResponseStatus.INTERNAL_SERVER_ERROR;
    }
    knotContext.getClientResponse().setStatusCode(statusCode.code());
    return knotContext;
  }

  private KnotContext createSuccessResponse(KnotContext knotContext) {

    ClientResponse clientResponse = new ClientResponse();

    io.vertx.rxjava.core.MultiMap headers = clientResponse.getHeaders();
    final String response = generateResponse(knotContext);
    headers.add(HttpHeaders.CONTENT_LENGTH.toString().toLowerCase(),
        Integer.toString(response.length()))
        .add("Content-Type", "application/json");

    clientResponse.setBody(Buffer.buffer(response)).setHeaders(headers);
    clientResponse.setStatusCode(HttpResponseStatus.OK.code());

    return new KnotContext()
        .setClientRequest(knotContext.getClientRequest())
        .setClientResponse(clientResponse);
  }

  private String generateResponse(KnotContext knotContext) {
    JsonObject response = new JsonObject();
        response.put("name", "example");
        response.put("rates",
           new JsonArray("[[1498232814506,50.968072700299615],[1498232815506,49.73653935458357],[1498232816506,52.066547246591384],"
               + "[1498232817506,52.753176265338354],[1498232818506,54.287003496637524],[1498232819506,59.22586695165852],"
               + "[1498232820506,57.54826302123493],[1498232821506,62.03889260639349],[1498232822506,65.86002197809175],"
               + "[1498232823506,65.8111043728656],[1498232824506,65.76628610064904],[1498232825506,66.82933024734697],"
               + "[1498232826506,67.434139241855],[1498232827506,68.04628203063808],[1498232828506,72.61484706496175],"
               + "[1498232829506,78.02558934566414],[1498232830506,76.99705472126708],[1498232831506,80.51276063071195],"
               + "[1498232832506,76.46702027132517],[1498232833506,79.79124722536811],[1498232834506,84.8658910337025],"
               + "[1498232835506,89.01769877015262],[1498232836506,85.50230403942585],[1498232837506,88.09068504360295],"
               + "[1498232838506,89.90642194355952],[1498232839506,85.15114192802366],[1498232840506,85.01778836267285],"
               + "[1498232841506,83.2929267133251],[1498232842506,87.10970664505882],[1498232843506,77.3429772225821],"
               + "[1498232844506,74.9584782131682],[1498232845506,75.19028404805175],[1498232846506,76.13972926384264],"
               + "[1498232847506,75.89953615652841],[1498232848506,75.90148493621763],[1498232849506,71.06101041063238]]")
        );
        return response.toString();
  }

}

```

Here in the `processRequest` method, the response is created. It is just the mocked JSON with the `name` and some `rates` in the form of an JsonArray.
If you want it make more realistic, you can use a `MarketSimulation` class that I've shared [here](https://github.com/Knotx/knotx-tutorials/blob/master/conferences/devoxx2017/examples/market-api/src/main/java/io/knotx/example/gateway/impl/MarketSimulation.java).

The last thing - we create a default configuration for the module.
Create `example.io.knotx.RequestProcessorKnot.json` configuration file under `market-api\src\main\resources`.
Define the `main` verticle (the one that will setup the module) and the address of the Request Processor on the Event Bus:

```json
{
  "main": "io.knotx.example.gateway.RequestProcessorKnotVerticle",
  "options": {
    "config": {
      "address": "knotx.gateway.requestprocessor"
    }
  }
}

```

And that's it - let's build the module and set up Knot.x instance.

## Running Web API with Knot.x

Create a folder where we will start _Knot.x_ and our Gateway module. Let's name it `demo`. It should contain the following files:

```
├── knotx-standalone-1.1.0.json  (download from Maven Central)
├── knotx-standalone-1.1.0.logback.xml (download from Maven Central)
├── app
│   ├── knotx-standalone-1.1.0.fat.jar (download from Maven Central)
│   ├── market-api-1.0.jar (copy from the market-api/target)
├── content (download from tutorial github)
│   ├── example
│       ├── data        (contains js that request Web API with jquery)
│       ├── dist        (contains page assets)
│       ├── pages       (contains the html page - this will be Knot.x repoistory dir)
│       ├── vendor      (contains some vendors libraries that are used to render a page)
```

You may download _Knot.x_ files from the Maven Central Repository and tutorial github:
1. [Knot.x standalone fat jar](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.1.0/knotx-standalone-1.1.0.fat.jar)
2. [JSON configuration file](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.1.0/knotx-standalone-1.1.0.json)
3. [Log configuration file](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.1.0/knotx-standalone-1.1.0.logback.xml)

The best way to download `content` is to checkout [`knotx-tutorials`](https://github.com/Knotx/knotx-tutorials)
or [download repository as ZIP](https://github.com/Knotx/knotx-tutorials/archive/master.zip).

### Configuration

Open `knotx-standalone-1.1.0.json` in your favourite IDE and let's configure Knot.x instance.
First, let's define all modules that will be:

```
{
  "modules": [
    "knotx:io.knotx.KnotxServer",
    "knotx:io.knotx.FilesystemRepositoryConnector",
    "knotx:io.knotx.FragmentSplitter",
    "knotx:io.knotx.FragmentAssembler",
    "knotx:io.knotx.ServiceKnot",
    "knotx:io.knotx.HandlebarsKnot",
    "knotx:io.knotx.HttpServiceAdapter",
    "knotx:io.knotx.GatewayKnot",
    "knotx:example.io.knotx.RequestProcessorKnot",
    "knotx:io.knotx.ResponseProviderKnot"
  ]
}
```

As you can see, one of modules is `knotx:example.io.knotx.RequestProcessorKnot` that we created in the `market-api`. By this naming convention,
Knot.x will search for `example.io.knotx.RequestProcessorKnot.json` file in the classpath and start defined there Verticle.

Now, let's override default `knotx:io.knotx.KnotxServer` settings where besides the `defaultFlow` we will define a `customFlow`. You can find
more details how to override the default configuration [here](https://github.com/Cognifide/knotx/wiki/KnotxDeployment).

#### Note
You will see multiple entries in `defaultFlow.repositories`. This is just for the demo purposes.
In the real world (production) requests for css/js/image and other page assets shouldn't be routed through Knot.x but
handled e.g. by Apache Server that is in front of Knot.x instance and takes care of all static files.

```json
    "knotx:io.knotx.KnotxServer": {
      "options": {
        "config": {
          "defaultFlow": {
            "repositories": [
              {
                "path": "/example/data/.*",
                "address": "knotx.core.repository.filesystem",
                "doProcessing": false
              },
              {
                "path": "/example/dist/.*",
                "address": "knotx.core.repository.filesystem",
                "doProcessing": false
              },
              {
                "path": "/example/vendor/.*",
                "address": "knotx.core.repository.filesystem",
                "doProcessing": false
              },
              {
                "path": "/example/pages/.*",
                "address": "knotx.core.repository.filesystem"
              }
            ],
            "splitter": {
              "address": "knotx.core.splitter"
            },
            "routing": {
              "GET": [
                {
                  "path": "/example/.*",
                  "address": "knotx.knot.service",
                  "onTransition": {
                    "next": {
                      "address": "knotx.knot.handlebars"
                    }
                  }
                }
              ]
            },
            "assembler": {
              "address": "knotx.core.assembler"
            }
          },
          "customFlow": {
            "routing": {
              "GET": [
                {
                  "path": "/prices/.*",
                  "address": "knotx.gateway.gatewayknot",
                  "onTransition": {
                    "next": {
                      "address": "knotx.gateway.requestprocessor"
                    }
                  }
                }
              ]
            },
            "responseProvider": {
              "address": "knotx.gateway.responseprovider"
            }
          }
        }
      }
    }
```

So what happens inside the `customFlow`? Thanks to it we can define an additional routing, that Knot.x will handle.
In this case, we define, that `GET` requests under `/prices/.*` path are processed by the Gateway Knot.
And then (on transition) it will be routed to our RequestProcessorKnotProxyImpl.

Finally our request will be processed by the `responseProvider` which (in its simple default implementation) just forwards the response to the client.

To run the Knot.x example we still need to configure the repository and service knot and adapter
(for backend integration that is running aside client-side in this example):

```json
    "knotx:io.knotx.FilesystemRepositoryConnector": {
      "options": {
        "config": {
          "address": "knotx.core.repository.filesystem",
          "catalogue": "./content/"
        }
      }
    }
```

## Running the demo

And now the last part. Let's run the example by executing following command in `demo`:
```
$ java -Dlogback.configurationFile=knotx-standalone-1.1.0.logback.xml -cp "app/*" io.knotx.launcher.LogbackLauncher -conf knotx-standalone-1.1.0.json
```
to start Knot.x instance with `market-api` module.

Now you may enter the [page](http://localhost:8092/example/pages/gateway-demo.html) and see the rendered diagram.

If you want to find more details about this page, please see [`Devoxx PL 2017 Knot.x demo script`](https://github.com/Knotx/knotx-tutorials/tree/master/conferences/devoxx2017).
