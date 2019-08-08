---
title: Getting Started with Docker
author: marcinkp
keywords: tutorial
date: 2019-08-07
layout: tutorial
knotxVersions:
  - edge
---
## Overview

In this tutorial, we will setup a simple project based on the [Knot.x Starter Kit](https://github.com/Knotx/knotx-starter-kit) template.
You will customize the Knot.x distribution with your own modules and configuration entries. Then you will build your custom Docker image.

What you’re going to learn:

- How to setup a Knot.x project with customization based on the [Knot.x Starter Kit](https://github.com/Knotx/knotx-starter-kit) template
- How to transform a static HTML into the dynamic content and configure Knot.x to use REST services to get data
- How to use the data from such services to dynamically populate HTML
- How to implement custom [Action](https://github.com/Knotx/knotx-fragments/tree/master/handler/api)

## Setup basic Knot.x project

**Prerequisites**
You will need the following things to use Knot.x:
- JDK 8
- Linux or OSX bash console (for Windows users we recommend using e.g. Ubuntu with [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)).
- Docker 

Download [Latest Knot.x Starter Kit release](https://github.com/Knotx/knotx-starter-kit/releases) and unzip it.

Project has the following structure:
```
├── docker
|   ├── Dockerfile                // Docker file with image definition.
├── functional                    // Keep here your functional tests. Example implementation included
├── gradle                        // Gradle wrapper and common gradle scripts
├── knotx                         // Knotx configuration which will be copied to docker image
├── modules                       // Sub-modules of your project
│   ├── ...                       // example modules implementation
```


## Configuration

### openapi.yml
Open `knotx/conf/openapi.yml` and add following path definition:

```
  /content/*:
    get:
      operationId: content-get
      responses:
        default:
          description: Remote repository template processing
``` 

By doing this you define the operation which should be executed for path `/content/*`.

### operations.conf

Now, you need to define operation `content-get`. Open `knotx/conf/routes/operations.con`
Add in `routingOperations` array following definition:

```
  {
    operationId = content-get
    handlers = ${config.server.handlers.common.request} [
      {
        name = httpRepoConnectorHandler
        config = {include required(classpath("routes/handlers/httpRepoConnectorHandler.conf"))}
      },
      {
        name = htmlFragmentsSupplier
      },
      {
        name = fragmentsHandler
        config = {include required(classpath("routes/handlers/fragmentsHandler.conf"))}
      },
      {
        name = fragmentsAssembler
      }
    ] ${config.server.handlers.common.response}
  }
```

You have defined operation using [httpRepoConnectorHandler](https://github.com/Knotx/knotx-repository-connector/tree/master/http) to
fetch documents from external repository via HTTP protocol.

Then the document is split into fragments. Fragments are processed by [fragmentsHandler](https://github.com/Knotx/knotx-fragments/tree/master/handler)

Now you can define how fragments will be processed.

### fragmentsHandler.conf

Create a new file `knotx/conf/routes/handlers/fragmentsHandler.conf` and edit it:

```
tasks {
  payment-check {
    action = user
    onTransitions {
      _success {
        actions = [
          {
            action = creditCard
          }
          {
            action = paypal
          }
          {
            action = payU
          }
        ]
        onTransitions {
          _success {
            action = payments
            onTransitions {
              _success {
                action = template-engine-handlebars
              }
            }
          }
        }
      }
    }
  }
}

actions {
  payments {
    factory = payments
  }
  user {
    factory = http
    config {
      endpointOptions {
        path = /user
        domain = webapi
        port = 8080
        allowedRequestHeaders = ["Content-Type"]
      }
    }
  }
  creditCard {
    factory = http
    config {
      endpointOptions {
        path = /creditcard/allowed
        domain = webapi
        port = 8080
        allowedRequestHeaders = ["Content-Type"]
      }
    }
  }
  paypal {
    factory = http
    config {
      endpointOptions {
        path = /paypal/verify
        domain = webapi
        port = 8080
        allowedRequestHeaders = ["Content-Type"]
      }
    }
  }
  payU {
    factory = http
    config {
      endpointOptions {
        path = /payu/active
        domain = webapi
        port = 8080
        allowedRequestHeaders = ["Content-Type"]
      }
    }
  }
  template-engine-handlebars {
    factory = knot
    config {
      address = knotx.knot.te.handlebars
      deliveryOptions {
        sendTimeout = 3000
      }
    }
  }
}
```

You have defined one task `payment-check`. You will refer to this task in [HTML Template](#htmlTemplate).

Task perform action `user` and then in parallel `creditCard`, `paypal` and `payU`. All this actions use [`http`](https://github.com/Knotx/knotx-data-bridge/tree/master/http) implementation.
Once all data from external services are fetched, action `payments` is executed. This action is a custom action that now we will implement.

As mentioned before we use [httpRepoConnectorHandler](https://github.com/Knotx/knotx-repository-connector/tree/master/http) to fetch documents. Modification
is required for the default handler configuration. 

Create a new file `knotx/conf/routes/handlers/httpRepoConnectorHandler.conf` and edit it:

```hocon
clientOptions {
  maxPoolSize = 1000
  idleTimeout = 120 # seconds
  tryUseCompression = true
}

clientDestination {
  scheme = http
  domain = repository
  port = 80
}

allowedRequestHeaders = [
  "Accept.*"
  Authorization
  Connection
  Cookie
  Date
  "Edge.*"
  "If.*"
  Origin
  Pragma
  Proxy-Authorization
  "Surrogate.*"
  User-Agent
  Via
  "X-.*"template-processing
]

customHttpHeader = {
  name = X-User-Agent
  value = Knot.x
}

```

We change here the `domain` name from `localhost` to `repository`. Please check the [swarm](#swarm) definition.

## Implementation

Now, you are ready to implement custom [Action](https://github.com/Knotx/knotx-fragments/tree/master/handler/api#action). 
The purpose of Action is to transform collected `json` data from external services into one `json` which can be used to fill [HTML Template](#htmlTemplate)  

Create the directory for new module `modules/payments`. 
Edit the `settings.gradle.kts` and add two lines:

```
include("payments")

project(":payments").projectDir = file("modules/payments")

```
Add the following files:

*build.gradle.kts*
```kotlin
plugins {
    `java-library`
}

dependencies {
    implementation(group = "org.apache.commons", name = "commons-lang3")

    "io.knotx:knotx".let { v ->
        implementation(platform("$v-dependencies:${project.property("knotx.version")}"))
        implementation("$v-server-http-api:${project.property("knotx.version")}")
        implementation("$v-fragments-handler-api:${project.property("knotx.version")}")
    }
    "io.vertx:vertx".let { v ->
        implementation("$v-web")
        implementation("$v-web-client")
        implementation("$v-rx-java2")
        implementation("$v-circuit-breaker")
    }
}
```

*src/main/resources/META-INF/services/io.knotx.fragments.handler.api.ActionFactory*
```
io.knotx.example.payment.action.PaymentsActionFactory
```

*src/main/java/io/knotx/example/payment/action/PaymentsActionFactory.java*
```java
package io.knotx.example.payment.action;

import static io.knotx.example.payment.utils.ProvidersProvider.calculateProviders;

import org.apache.commons.lang3.StringUtils;

import io.knotx.fragments.handler.api.Action;
import io.knotx.fragments.handler.api.ActionFactory;
import io.knotx.fragments.handler.api.domain.FragmentResult;
import io.reactivex.Single;
import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;

public class PaymentsActionFactory implements ActionFactory {

  @Override
  public String getName() {
    return "payments";
  }

  @Override
  public Action create(String alias, JsonObject config, Vertx vertx, Action doAction) {
    return (fragmentContext, resultHandler) ->
        Single.just(fragmentContext.getFragment())
            .map(fragment -> {
              JsonObject payload = fragment.getPayload();
              JsonObject user = payload.getJsonObject("user");
              JsonObject payments = processProviders(payload);
              fragment.clearPayload();
              fragment.mergeInPayload(new JsonObject().put(getAlias(alias), payments)
                  .put("user", user));
              return new FragmentResult(fragment, FragmentResult.SUCCESS_TRANSITION);
            })
            .subscribe(onSuccess -> {
              Future<FragmentResult> resultFuture = Future.succeededFuture(onSuccess);
              resultFuture.setHandler(resultHandler);
            }, onError -> {
              Future<FragmentResult> resultFuture = Future.failedFuture(onError);
              resultFuture.setHandler(resultHandler);
            });
  }

  private JsonObject processProviders(JsonObject payload) {
    return new JsonObject()
        .put("timestamp", System.currentTimeMillis())
        .put("providers", calculateProviders(payload));
  }

  private String getAlias(String alias) {
    return StringUtils.defaultString(alias, "payments");
  }
}
```

*src/main/java/io/knotx/example/payment/utils/ProvidersProvider.java*
```java
package io.knotx.example.payment.utils;

import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;

public final class ProvidersProvider {

  private ProvidersProvider() {
    //util
  }

  public static JsonArray calculateProviders(JsonObject creditCard,
      JsonObject paypal, JsonObject payU) {
    JsonArray providers = new JsonArray();
    if (creditCard != null && creditCard.containsKey("allowed") && creditCard
        .getBoolean("allowed")) {
      providers.add(getProviderData(creditCard, "label", "url"));
    }
    if (paypal != null && paypal.containsKey("verified") && paypal.getBoolean("verified")) {
      providers.add(getProviderData(paypal, "label", "paymentUrl"));
    }
    if (payU != null && "OK".equals(payU.getString("status"))) {
      providers.add(getProviderData(payU, "name", "link"));
    }
    return providers;
  }

  public static JsonArray calculateProviders(JsonObject payload) {
    return calculateProviders(getResult(payload, "creditCard"), getResult(payload, "paypal"),
        getResult(payload, "payU"));
  }


  private static JsonObject getProviderData(JsonObject data, String label, String paymentUrl) {
    return new JsonObject()
        .put("label", data.getString(label))
        .put("paymentUrl", data.getString(paymentUrl));
  }

  private static JsonObject getResult(JsonObject payload, String provider) {
    if (payload.containsKey(provider)) {
      return payload.getJsonObject(provider)
          .getJsonObject("_result");
    } else {
      return null;
    }
  }

}
```

<a id="htmlTemplate"></a>
## HTML Template

Create `services/content/public_html/content` directory and put there following page template with Knot.x snippet (`<knotx:snippet data-knotx-task="payment-check">...`):
As you see in this snippet we refer the task `payment-check` we defined before.

*payment.html*
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Knot.x Docker Example</title>
  <link rel="stylesheet"
        href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
        crossorigin="anonymous">
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-md-12">
      <div class="jumbotron">
        <h2>
          Knot.x Docker Example
        </h2>
        <p>
          This template is served from the <strong>HTTP</strong> repository.
        </p>
        <img src="/assets/knotx-logo.png" alt="Hello Knot.x">
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-md-12">
      <div class="jumbotron">
        <h2>
          Datasource message
        </h2>
        <knotx:snippet data-knotx-task="payment-check">
          <h4>Hello {{user._result.name.first}} {{user._result.name.last}}!</h4>
          <p>Your score is <b>{{user._result.score}}</b> and you can use following payment methods:</p>
          <ul>
            {{#each payments.providers}}
            <li><a href="{{this.paymentUrl}}">{{this.label}}</a></li>
            {{/each}}
          </ul>
        </knotx:snippet>
      </div>
    </div>
  </div>
</div>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
</body>
</html>

```

## External services

We need to define the responses for external services. Our definition calls 4 services. Let's define them.   
Create `services/webapi/__files` directory  and put there 4 files:

*creditcard.json*
```json
{
  "allowed": true,
  "url": "https://cc-example.com/pay/19g8esry9se8rgyse90r8ug4",
  "label": "Credit Card"
}
```

*paypal.json*
```json
{
  "verified": true,
  "paymentUrl": "https://paypal-example.com/payment?id=1983247919hv9sa398f",
  "label": "PayPal premium"
}
```

*payu.json*
```json
{
  "status": "OK",
  "link": "https://payu-example.com/tr?id=afj08aw398gha0we9ge",
  "name": "PayU"
}
```

*user.json*
```json
{
  "_id": "5cee7d620a281607d18cf8d5",
  "score": 123.321,
  "age": 22,
  "eyeColor": "blue",
  "name": {
    "first": "Claudine",
    "last": "Sellers"
  },
  "company": "GAZAK",
  "email": "claudine.sellers@gazak.co.uk",
  "phone": "+1 (844) 442-3950",
  "address": "670 Rutland Road, Brethren, Montana, 9555",
  "about": "Fugiat qui in eiusmod nostrud cupidatat do sit dolor. Duis in minim nulla exercitation ea commodo cillum excepteur amet. Esse non in labore enim eu excepteur do in eiusmod ipsum mollit commodo mollit adipisicing.",
  "registered": "Sunday, February 2, 2014 2:48 AM",
  "latitude": "-33.507469",
  "longitude": "-115.52703",
  "tags": [
    "velit",
    "aliquip",
    "ullamco",
    "sunt",
    "non"
  ],
  "favoriteFruit": "apple"
}
```

We will use [WireMock](http://wiremock.org/) for mock services and we need to define the mappings.

Create the `services/webapi/mappings` directory and put there those four files:

*creditcard.json*
```json
{
  "request": {
    "method": "GET",
    "url": "/creditcard/allowed"
  },
  "response": {
    "status": 200,
    "fixedDelayMilliseconds": 100,
    "bodyFileName": "creditcard.json"
  }
}

```

*paypal.json*
```json
{
  "request": {
    "method": "GET",
    "url": "/paypal/verify"
  },
  "response": {
    "status": 200,
    "fixedDelayMilliseconds": 3000,
    "bodyFileName": "paypal.json"
  }
}

```

*payu.json*
```json
{
  "request": {
    "method": "GET",
    "url": "/payu/active"
  },
  "response": {
    "status": 200,
    "fixedDelayMilliseconds": 200,
    "bodyFileName": "payu.json"
  }
}

```

*user.json*
```json
{
  "request": {
    "method": "GET",
    "url": "/user"
  },
  "response": {
    "status": 200,
    "bodyFileName": "user.json"
  }
}
```
 
 
## Docker

### Configuration
[Knot.x Starter Kit](https://github.com/Knotx/knotx-starter-kit) project builds docker image. Edit `gradle.properties` and change property `docker.image.name`:

```
docker.image.name=knotx-example/template-processing
```

You will refer to image name in the swarm file.

<a id="swarm"></a>
### Swarm
Let's define the swarm file where we will setup following services:
 - `repository` - Content Repository which will serve the html templates
 - `webapi` - external Web APIs for: `user`, `creditcard`, `payu` and `paypal` (which we've just created above)
 - `knotx` - Knot.x image with our customization we build during this tutorial
 
Create the `template-processing.yml` file:
 
```yaml
version: '3.7'

networks:
  knotnet:

services:
  repository:
    image: httpd:2.4
    volumes:
      - "./services/content/public_html:/usr/local/apache2/htdocs"
    ports:
      - "4503:80"
    networks:
      - knotnet

  webapi:
    image: rodolpheche/wiremock
    volumes:
      - "./services/webapi:/home/wiremock"
    ports:
      - "3000:8080"
    networks:
      - knotnet

  knotx:
    image: knotx-example/template-processing:latest
    command: ["knotx", "run-knotx"]
    ports:
      - "8092:8092"
      - "18092:18092"
    networks:
      - knotnet

```


## Run

Now we are ready to run. First, build your docker image
```
$ gradlew clean build
```

Run Knot.x instance and example data services (Web API and Content Repository) in a single-node Docker Swarm:
```
docker stack deploy -c ./template-processing.yml template-processing
```

### Final page

http://localhost:8092/content/payment.html

You can find full project implementation [here](https://github.com/Knotx/knotx-example-project/tree/master/template-processing)
