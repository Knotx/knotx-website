---
title: Configurable integrations
description: Integration framework allowing to easily handle failures in distributed systems and new business requirements.
author: tomaszmichalak
keywords: software-architecture,distributed-systems,integrations,configurable-integrations
order: 2
date: 2019-08-22
---

![alt_text](/img/blog/configurable-integrations/hero-image.jpg)

> In the API-driven world, where failures are NOT unexpected, handling errors and adapting to new business requirements
    have become a challenging and continuous work. Is the new Knot.x feature going to make this process more manageable
    and ready for further evolution? Check out this post to explore some basic concepts of Configurable Integrations.

In the past, web platforms were quite simple: there was a web server hosting our application and a database storing the
data. A database kept information about products, customers, orders but also articles, homepage content, etc. An
application utilised that information and produced an HTML markup combining static content with customer-related data
(like a shopping cart). Over time, however, the number of our users and new features has grown exponentially. The
initial simplicity comes at a price - scaling of monoliths was challenging as well as maintaining various
responsibilities in the single application.

Decomposing functionalities into independent services was the next step in the software evolution. Service-oriented
architecture (SOA) and microservices structure an application as a collection of loosely coupled services. Such systems
simplify some aspects like scalability, resilience and agility but also introduce new challenges: integrations.

_Note: In many cases, it can be more efficient to choose monoliths than more granular architectures. As Ben Morris
observes,
[it doesn’t have to wind up as a big ball of mud that is impossible to scale and maintain.](https://www.ben-morris.com/whats-so-bad-about-monoliths-anyway/)_

Now, many organizations move their businesses to the cloud. There are obvious benefits such as reduced infrastructure
overhead, ability to scale resources on the fly to meet the increasing demand and much more. Whether transitioning to a
cloud infrastructure or utilizing cloud services, it is becoming more and more evident that APIs are going to be a
first-class citizen in the modern architectures. Public APIs enable developers to integrate data and functions in the
way microservices do. APIs, nowadays, usually implement REST standard that specifies a set of constraints to be utilised
for building Web services. It supports delivering well-defined, easy to understand and manage APIs. Features such as
customer identity, payments, recommendations, search are exposed as cloud services that we can "easily" consume via
RESTful APIs. Even Content Management Systems (CMS) and e-Commerce platforms, previously integrating many features, have
lost their "heads" to APIs.

## Distributed challenges

Services are physically distributed within some geographical areas and communicate over the network. Systems whose
components (services) are located in different datacenters and communicate by passing messages one to another are called
distributed. Many developers today rely on APIs, neglecting the limitations of network communication. An important
characteristic of REST is that it does not hide network problems. Integration logic should care about service connection
problems, timeouts resulting from service peak loads, temporary unavailability of service and many others.

## Integration spaghetti

In a typical integration flow, we call some API and after the response comes back, business logic (decision or
calculation) is executed. In the more complex scenarios, we could call another API that requires the data we just pulled
and the process goes on and on. But what if API, we integrate with, is not available or we get a timeout? Can we retry
API invocation or we should somehow check the state first? Similar questions appear when API has changed unexpectedly...
Unless we have planned our integration logic for constant evolution, we will end up with spaghetti code. So let's try to
define some "framework" that would be reusable, adapt to various cases and contain integration patterns built-in.

## Divide and conquer

Let's try to decompose simple business logic into lightweight independent parts, call them **actions**. This procedure
decouples business operations from the communication activities. The action can be for example:

- an API request,
- non-web API requests such as NoSQL queries,
- custom business logic. 

The action definition is general, it accepts one input and replies with one or more responses
(like business logic can make different decisions based on the input). Action responses are text values that specify
the action contract. So action is simple function with well-defined responses (text values) representing business
decisions. It makes the business logic decomposition granularity easy to tailor to customer needs.

_Sounds abstract? Let's define a simple case scenario. We get a user profile data as an input. Then we calculate a user
score, assign him/her to standard or premium group and invoke a dedicated RESTful API to fetch recommended products.
This logic can be decomposed into:_

- _the first action that does score calculation, determines user group and responds with a "standard" and "premium"
  value,_
- _the second action that calls standard API and fetches standard products_
- _the third action that calls premium API and fetches premium products_

_The first action represents business operations, the second and third communication activities. Both second and third
action communicate with RESTful API so there is one implementation with parameterized URL, timeout etc._

_It is time to connect all decomposed actions to settle the final business logic. Remembering that actions have one
input and many responses, the business logic composition drives us into a graph solution, the graph of actions. Actions
are nodes, responses are transitions._

![Actions graph](/img/blog/configurable-integrations/knotx-ci-graph.jpg)

Composing actions as graph nodes and their responses as transitions provides a manageable way of defining even complex
scenarios. With a configurable graph of actions, incremental changes in business logic are simple and secure.
Introducing new business scenarios, such as "gold" users group, is a matter of configuration.

## Selective scalability

Going back to the example for a moment, let’s assume that the user score calculations are heavy. Other actions, like
premium API invocation, are lightweight and do not consume much CPU resources. What if we could scale the user score
algorithm on-demand, by configuring more instances of the action, without affecting others? Consider that we place a
load balancer in front of every action. It manages incoming events and routes them to action instances configured on the
same or different host. So both horizontal and vertical scalability is available without any development effort.
Reactive systems rely on asynchronous message-passing providing selective elasticity.

![Actions scalability](/img/blog/configurable-integrations/knotx-ci-scalability.jpg)

## Partial failures & fallbacks

External data sources, such as RESTful APIs, define possible responses and expected errors (such as internal server
error, bad request etc). However, there are unexpected situations such as timeouts or unpredicted API contract changes.
Modern applications “hide” failures giving users a different experience when some data is not available. Thus,
[a failure in a service dependency should not break the user’s experience.](https://medium.com/netflix-techblog/making-the-netflix-api-more-resilient-a8ec62159c2d)

![Processing with partial failures](/img/blog/configurable-integrations/knotx-ci-partial-failures.jpg)

With the graph of actions, handling all unexpected errors is a matter of configuration. For every service that is
usually fast but may suddenly start fluctuating, a _timeout transition_ leading to a fallback action can be provided.
Defining time restrictions for data sources has to be possible at any time.

## Stability patterns

Let’s focus now on cross-cutting problems such as preventing cascade failures in distributed systems. The circuit
breaker pattern implementation is a natural answer to this problem. It stops calling an unresponsive service if the
error rate for that service exceeds a configured threshold and responds with a failure or fallback response immediately.
Fallback logic can read data from a cache or get some default value. It sounds complicated, but the truth is that
stability patterns help us to manage the complexity of integrations, making them "a bit less distributed". So, what if
we could specify some extra behaviour for our actions without changing their logic? Adding a circuit breaker or even
cache functionalities should be a matter of configuration, not code changes.

![Response time restrictions](/img/blog/configurable-integrations/knotx-ci-behaviours.jpg)

## Limited response time

Imperfect user experience becomes standard, users accept that some features are limited. Response rate remains a
principal factor for responsive applications. Long response times cause financial losses and decrease the number of
customers, hence defining time restrictions for all actions is critical and has to be possible at any time, allowing
system owners to define different experiences.

![Response time restrictions](/img/blog/configurable-integrations/knotx-ci-time-restrictions.jpg)

## Knot.x Configurable Integrations

Knot.x encourages building integrations in the form of low responsibility puzzles (we call them
[Actions](https://github.com/Knotx/knotx-fragments/tree/master/handler/api#action)) and combining them in the form of a
directed graph. This approach gives both, developers and business teams a common language to work together over the
complexity of integrations. The graph is also a consistent documentation of business logic and provides all details
about integrated data sources, time restrictions and used stability patterns. Once implemented, actions can be reused in
many business scenarios.

And basically, the approach to adapt complex integrations to a graph of small Actions becomes
[Configurable Integrations](https://github.com/Knotx/knotx-fragments). Tools and patterns that are shipped with the
Knot.x philosophy enable developers to build even complex integrations in a declarative way. That convention allows
development teams to follow the clean architecture. Developers can focus on the business logic of integrations at the
very beginning. When decisions regarding time restrictions or failure handling are made later in the project, Knot.x
allows developers to manage them without changing their business logic.
