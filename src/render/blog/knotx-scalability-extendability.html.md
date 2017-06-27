---
title: Knot.x scalability & extendability
description: "This tutorial explains basic concepts of Knot.x scalability and extendability."
author: tomaszmichalak
keywords: tutorial
order: 5
date: 2017-05-23
---

## Overview

In this tutorial, we’re going to show how Knot.x can be easily scaled and expanded. We explain
how to start Knot.x in cluster mode and allow different Knot.x instances to communicate with each
other using an event bus.

This article uses code examples and configurations presented at GeeCON 2017.

What you’re going to learn:

- How to scale Knot.x platform using cluster mode
- How to expand Knot.x features by running new modules on dedicated Knot.x instance

The full GeeCON 2017 demo script is available [here](https://github.com/Knotx/knotx-tutorials/conferences/geecon2017).

## Prerequisites

Clone a tutorials github repository and open a `conferences/geecon2017` directory:
```
git clone https://github.com/Knotx/knotx-tutorials.git
cd knotx-tutorials/conferences/geecon2017
```

Next download [Knot.x standalone fat jar](https://oss.sonatype.org/content/groups/public/io/knotx/knotx-standalone/1.0.1/knotx-standalone-1.0.1.fat.jar)
 and place it in the `app` folder under both `instance-1` and `instance-2` directories.

## Event Bus

Before we start our Knot.x instances we want to give you some details about Knot.x architecture
to help you with understanding what will happen in a few minutes.

So basically in terms of an architecture Knot.x is a bunch of isolated modules. Those modules have defined
contracts so they are easy to test, upgrade or exchange.

![Event Bus](/img/blog/geecon-2017/event-bus-knotx.png)

Those modules communicate via Event Bus. It is a lightweight messaging system delivered by Vert.x
allowing different modules, or <strong>different application instances</strong> to communicate in a loosely
coupled way.


## Scalability

Let's now explain the case we use in our example.

![Knot.x scalability](/img/blog/geecon-2017/geecon-demo-scalability.png)

Knot.x `instance-1` contains Knot.x Core modules and one additional `Search` module (for GeeCON demo
purposes we used [Service Knot](https://github.com/Cognifide/knotx/wiki/ServiceKnot) for Search).
Our Search module connects to Google Books API and provides books details based on a query.
The step by step module configuration is described in [Hello Rest Service](http://knotx.io/blog/hello-rest-service/)
tutorial.

Knot.x `instance-2` contains only the `Search` module. It is exactly the same module like the `instance-1`.

We use `instance-2` to scale the Search module.

So let's run `instance-1` and `instance-2` in a *cluster* mode:

```
$ cd instance-1
$ java -Dvertx.disableDnsResolver=true -Dlogback.configurationFile=knotx-standalone-1.0.1.logback.xml -cp "app/*" io.knotx.launcher.LogbackLauncher -conf knotx-standalone-1.0.1.json -cluster
```

```
$ cd instance-2
$ java -Dvertx.disableDnsResolver=true -Dlogback.configurationFile=knotx-standalone-1.0.1.logback.xml -cp "app/*" io.knotx.launcher.LogbackLauncher -conf knotx-standalone-1.0.1.json -cluster
```

You may check the second console log and see that cluster is working:
 ```
                 Deployed e25c5446-0a19-4b76-87c3-cc1cec07e869 [knotx:io.knotx.ServiceKnot]
                 Deployed e900595f-2522-4279-82c8-a49b304c1895 [knotx:io.knotx.HttpServiceAdapter]
 ...
 Members [2] {
         Member [192.168.56.1]:5701
         Member [192.168.56.1]:5702 this
 }
 ```
  
Now you can open a [Books Page](http://localhost:8092/service/books.html?q=java) in your
favorite browser to see the console. Every time you refresh the page, Vert.x dispatches the search
request between `instance-1` and `instance-2`. So Vert.x gives us load balancing for free.



## Extendability

Knot.x provides well-defined extension points like [Knots](https://github.com/Cognifide/knotx/wiki/Knot)
and [Adapters](https://github.com/Cognifide/knotx/wiki/Adapter). They allow to easily extend Knot.x
Core features with project specific requirements.

In this example we connect to a database to fetch some information about books authors. But our database
is not available via HTTP so we need to connect with it directly. The image blow presents what we want
to achieve.

![Knot.x extendability](/img/blog/geecon-2017/geecon-demo-extendability.png)

Before the next steps checkout and build [Adapt Service Without Web API](https://github.com/Knotx/knotx-tutorials/tree/master/adapt-service-without-webapi)
using Maven. Place the `custom-service-adapter-1.0.1-fat.jar` it in the `instance-3/app` folder.
Then prepare the DB according to this [tutorial](http://o7planning.org/en/10287/installing-and-configuring-hsqldb-database).
To create tables with data, use the script provided in the `instance-3/db` folder of this tutorial.

Now run `instance-3` with `BooksDbAdapter` in cluster mode (assuming `instance-1` and `instance-2` are still running):

```
$ cd instance-3
$ java -Dvertx.disableDnsResolver=true -Dlogback.configurationFile=knotx-standalone-1.0.1.logback.xml -cp "app/*" io.knotx.launcher.LogbackLauncher -conf knotx-standalone-1.0.1.json -cluster
```

Open [DB Books Page](http://localhost:8092/db/books.html) and see details about authors.

Finally we used the same cluster mechanism as in the scalability example to dynamically deploy the
database datasource.

