---
title: Configurable integrations
description: Declarative integration experience.
author: tomaszmichalak
keywords: integrations,configurable integrations,declarative integrations
order: 2
date: 2019-08-22
---

![alt_text](/img/blog/configurable-integrations/building-blocks.jpg)

# Configurable integrations

## In the past

In the past, web platforms were quite simple: there was a web server that hosted our application and 
a database to store the data. A database kept information about products, customers, orders but also 
articles, homepage content, etc. It was the time when monoliths were very popular. 

But simplicity comes at a price - monoliths are deployed on one server and combine various 
responsibilities. 

As [Ben Morris](https://www.ben-morris.com/whats-so-bad-about-monoliths-anyway/) observes, 
> ... it doesn’t have to wind up as a big ball of mud that is impossible to scale and maintain. 

In many cases, it can be more efficient to choose monoliths than more granular architectures.

However, decomposing functionalities into independent services was the next step in the software 
evolution. Service-oriented architecture (SOA) and microservices structure an application as a 
collection of loosely coupled services. Distributed systems simplify some aspects like scalability, 
resilience and agility but also introduce new challenges: integrations.

## Today

Today, more and more vendors and organizations move to the cloud, publish APIs that enable developers 
to integrate data and functions in the way microservices do. Whether transitioning to a cloud 
infrastructure or utilizing cloud services it is becoming more and more obvious that APIs are going 
to be a first-class citizen in our life. 

Many features such as customer identity, payments, recommendations, search are now services that we 
can "easily" integrate via RESTful APIs. Even Content Management Systems (CMS) and e-commerce 
platforms, previously integrating many features, have lost their "heads" to APIs.

## Distributed challenges

Services are physically distributed within some geographical areas and communicate over the network. 
Systems whose components (services) are located in different datacenters and communicate by passing 
messages to one another are called distributed. Many developers today rely on APIs, neglecting the 
limitations of network communication. An important characteristic of [REST is that it does not hide 
network problems](https://www.javaworld.com/article/2824163/stability-patterns-applied-in-a-restful-architecture.html). 
Integration logic should care about service connection problems, timeouts resulting from service peak 
loads, temporary unavailability of service and many others.

## Integration spaghetti

Let's try to decompose simple business logic into some business-related parts and integration points. 
In a typical integration implementation, we call some API and after the response comes back, business 
logic (decisions or calculations) is fired. In the more complex scenarios, we could call another API 
that requires the data we just pulled and the process goes on and on.

APIs and business logic behind the integration change over  time making spaghetti code out of 
carelessly developed integration. What is more, we often realize that services we integrate with are 
not 100% available after we implemented business logic...

So maybe it is worth splitting integration logic into small actions that separate business operations 
from communication code.

## Declarative integrations

![alt_text](/img/blog/configurable-integrations/actions-graph.png)

Building integrations usually starts with a happy-case scenario. Business logic decomposition ends 
with a collection of lightweight independent actions. The action can be for example:
- an API request,
- non-web API requests such as NoSQL queries,
- custom business logic.

The action may define one or more responses (like business logic can make different decisions based 
on the input).

Composing actions as graph nodes and their responses as transitions provides a manageable way of 
defining even complex scenarios. With a configurable graph of actions, incremental changes in 
business logic are simple and secure.

## Partial failures & fallbacks

Integration logic consists of decision actions, usually connected with requirements and data actions. 
Implementing a happy-case scenario, we focus on business decisions. Most of them are well-known from 
the beginning so configuring them in a graph is not a big issue.

However, the situation is a bit different for data actions. They handle data fetching from external 
data sources. Those actions are about decisions too, but not visible from the beginning and usually 
not covered in requirements. 

Modern applications “hide” failures giving users a different experience when some data is not 
available. Thus, [a failure in a service dependency should not break the user’s experience](https://medium.com/netflix-techblog/making-the-netflix-api-more-resilient-a8ec62159c2d).

On the other hand, users don't know what they expect, but they demand it NOW.

Defining time restrictions for data sources has to be possible at any time, allowing the business to 
specify fallbacks.

![alt_text](/img/blog/configurable-integrations/time-restrictions.png)

## Stability patterns

Let’s focus now on cross-cutting problems such as preventing cascade failures in distributed systems 
or caching responses. 

The circuit breaker pattern implementation is a natural answer to the former. It stops calling an 
unresponsive service if the error rate for that service exceeds a configured threshold and responds 
with a failure or fallback response immediately. Fallback logic can read data from a cache or get 
some default value.

It sounds complicated, but the truth is that stability patterns help us to manage the complexity of 
integrations, making them "a bit less distributed".

So what if we would be able to specify some behaviour for our actions not changing their logic? 
Adding a circuit breaker or cache functionalities should be a matter of configuration, not code 
changes.

![alt_text](/img/blog/configurable-integrations/stability-patterns.png)

## Configurable Integrations

Knot.x encourages building integrations in the form of low responsibility puzzles (we call them 
Actions) and combine them in the form of a directed graph. This approach gives both, developers and 
business teams a common language to work together over the complexity of integrations.

The graph is also a consistent documentation of business logic and provides all details about 
integrated data sources, time restrictions and used stability patterns. Once implemented, actions 
can be reused in many business scenarios.

And basically, the approach to adapt complex integrations to a graph of small Actions becomes 
Configurable Integrations. Tools and patterns that are shipped with the Knot.x philosophy enable 
developers to build even complex integrations in a declarative way. That convention allows 
development teams to follow the clean architecture. Developers can focus on business logic of 
integrations at the very beginning. When decisions on time restrictions or failure handling are 
made at the later phase of the project, Knot.x enables to impose them without changing business logic.


