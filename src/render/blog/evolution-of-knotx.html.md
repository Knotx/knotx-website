---
title: Evolution of Knot.x: from tool to framework
description: While Knot.x philosophy has not changed from the beginning, we definitely witness the journey from being a reactive template engine processor to being an API integration framework. Read about the evolution of Knot.x in this short article.
author: skejven
keywords: blog
order: 1
date: 2019-08-19
---

# Evolution of Knot.x

Over 2 years ago, when we kicked off Knot.x officially, the major problems that we struggled with were integrations with 3rd party and customer’s APIs. Convincing CMS, CRM, search engine and e-commerce to talk with each other and integrating them into a single, coherent platform was the main challenge of our daily work. And Knot.x came with a very simple yet powerful solution: instead of hacking each of those platforms to communicate with others, move the integration logic into a dedicated architecture layer.

Back then, Knot.x was the answer to the repeatedly increasing number of services that should be combined into the "unified customer experience". 

It enabled us to deliver multiple commercial projects for global brands from the pharmacy, banking and consulting agencies industries. Knot.x helped solve complex architectural problems like dynamic product pages with CDN support, combining legacy and new platforms into a single system or providing a microservice Web API platform.

It was a super-fast, scalable and fault-tolerant solution that supported implementing complex and challenging (global, performance demanding, connection dozens of customers and 3rd party APIs) projects. And it still is... But now, Knot.x is much more.


# API backend

It's 2019 and there is a whole different world today. _Headless_, _serverless_, _SPA_ are the top buzzwords we hear when talking about commercial solutions. The microservice is so passé now. And so is the reactive template engine that combines multiple data sources with static layout on the backend and serving it as a dynamic page to the end-user. Don't get me wrong, that’s still a useful approach for Multi-page applications (_MPA_), but it’s just not enough for modern architectures.

New technologies displace the old ones, new buzzwords replace those that ruled last year. But if you stop for a moment, you will notice there are problems and solutions that are constant no matter the technology or buzzword you use. For example, web communication is far from perfect and that’s nothing new. And since that, there have been integration stability patterns that have helped developers mitigate timeouts, connection errors, and other unexpected failures.

The hype about the headless content is getting more and more attention. There are numerous articles on why your business should or should not adopt a Headless CMS and I won’t touch comparisons in this article. Nevertheless, since the content is headless, there is a need to build a presentation layer. The trend to build it on the client-side tends to be a very natural decision. And this is where Single Page Application (or _SPA_) and _JAMStack_ phrases appear. Since we have a nice API that serves the content (the underlying assumption behind the Headless CMS), UI composition techniques can work just well with it. But what when there is something more than just content… Let’s say there is some integration with eCommerce required. If it does not have a Web API optimized to the public web, there is a problem. More troubles appear when some kind of security is required for the front-end application.

And here Knot.x kicks in. Thanks to its reactive nature, high performance (with Vert.x and Netty under the hood), and non-blocking resource management, Knot.x is a perfect candidate to conduct and organize requests and produce simplified experience for the user in the form of API Gateway, Backend For Frontend (_BFF_) and any other backend API or security layer. Knot.x can turn many requests into just one, to reduce the number of round trips between the client and application. When setting up Knot.x in front of multiple data sources (e-commerce API, microservices, database) it becomes the entry point for every HTTP request processed by the application backend. Client-side implementation is simplified, backend services can keep their responsibilities small and simple - that’s a win-win situation.

Moreover, Knot.x enables projects to follow the Clean Architecture principle. This means you can postpone important decisions, like the presentation layer choice (e.g. SPA vs MPA) to a more mature (when you can make an informed decision) project phase. The integration logic you create with Knot.x can be reused with both approaches. Also, the project can start with happy-case integration scenarios and wrap business logic with stability patterns (like Circuit Breaker, Errors fallback or Retry) later without changing a single line of code. Finally, Knot.x encourages building integrations in the form of low responsibility puzzles (we call them Actions) and combine the integration logic into a graph. That helps to understand even complex scenarios and design them first on the whiteboard with business. We call that approach a Configurable Integration.


# Summary

Since the first versions of Knot.x, where the main feature was combining layout and content from the traditional CMS with dynamic data, Knot.x has evolved towards an integration framework.

It still keeps its server-side rendering (combining static layout with dynamic content) features that have proven to be a successful approach in numerous commercial implementations. But now, with the Design First approach (no matter REST or GraphQL) at the root, Configurable Integrations and Stability Patterns (like Circuit Breaker and Bulkhead) build-in, Knot.x has become the robust framework for building backend APIs like:


*   API Gateway,
*   Backend For Frontend,
*   Web API,
*   SPA Security Layer.
