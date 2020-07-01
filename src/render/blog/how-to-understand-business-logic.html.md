---
title: How to understand business logic
description: In this post, we will tell you what does business logic mean for us and transform user stories to domain objects and then model the solution. It starts the series discussing "Business Logic Evolution".
author: tomaszmichalak
keywords: business-logic,domain-driven-design,user-stories
order: 1
date: 2020-06-05
---
![written equations on brown wooden board](/img/blog/how-to-understand-business-logic/business-logic-hero-banner.jpg)

Wikipedia defines business logic as follows:

> In computer software, business logic or domain logic is the part of the program that encodes the real-world business
> rules that determine how data can be created, stored, and changed.

But how is that definition connected with the code? Today, we will tell you what business logic means to us, software
engineers, and transform user stories to domain objects and then model the solution.

## Story

We begin with a brief story, the user story. Once upon a time...

> _a user gets products_.

This sentence captures a requirement of a software feature from an end-user perspective. It describes what the user
wants. The subject (“user”) is a model (class) that has no behaviour (methods) defined, and contains data (properties).
In the Domain-Driven Design (DDD) it is called a domain object. Our story specifies two domain objects: a user and a
product. The verb (“gets”) defines an action/state/relation between our domain objects. What's interesting is that this
single word hides most of the complexity of to the solution we are building. One more fact, user stories focus on
results, leaving out the technical details like “how” to get products.

## Business logic

Business logic is a part of the solution (application) that executes user stories, using domain objects as its inputs
and outputs. While domain objects define the “who” and the “what”, business logic addresses the "how". This simple
diagram summarizes our understanding of business logic:

![Business logic input and output](/img/blog/how-to-understand-business-logic/business-logic-input-output.png)

Looking at the diagram above, we quickly notice the similarity between business logic and a computer program - let’s
call it a function for simplicity. Every function has an input and an output, which constitute a function's contract.
And the contract for the function that represents our example user story would be:

- **Domain objects: `User`, `Product`**
- **Input:** `User`
- **Output:** `Products(User)`

The output is a list of products that are in the User’s context.

Having said that, we can divide business logic of our example into two steps:

- the first step gets details about the user
- the second step uses user details and gets products

![Business logic decomposition](/img/blog/how-to-understand-business-logic/business-logic-decomposition.png)

It is easy to see that the result of the previous step becomes the input of the next.

## Decisions

Let's make our example user story more specific:

> _Standard user gets standard products._</br> _Premium user gets premium products._

Adjectives define domain object properties, the attributes. Now our functions look like this:

- **Output 1:** `Product<Standard>(User<Standard>)`
- **Output 2:** `Product<Premium>(User<Premium>)`

Attributes define business decisions, which shape conditions for the next steps. Each step is influenced by decisions
from previous steps.

So our “steps” diagram looks like:

![Business logic variants](/img/blog/how-to-understand-business-logic/business-logic-variants.png)

Note: For simplicity we start the diagram with “Context”. That can be an HTTP request, but also any other trigger. We
will not focus on details of it in this article.

The “get user” steps for both scenarios accept the same input (`Context`) but define two different outputs
(`User<Standard>` and `User<Premium>`). Those outputs are business decisions. Steps with the same input can be easily
merged, as shown on the diagram below:

![Business logic decisions](/img/blog/how-to-understand-business-logic/business-logic-decisions.png)

As you can see, steps can have a single input and multiple outputs. The input specifies previous business decisions and
the outputs new ones.

## Big picture

The presented user stories were trivial. Very often, they are the result of breaking down more complex domain problems
into small manageable items. So one story defines input for another, etc. Combining them together we get a graph of
steps.

![Big picture: business logic](/img/blog/how-to-understand-business-logic/business-logic-big-picture.png)

We can say business decisions produce paths to new steps encapsulating new business logic. Finally, we get an acyclic
directed graph of steps (it's actually a tree), where leaves are the final outputs. Such representation can help to
understand the complexity and the impact of the changing circumstances faster so it's desired when building larger
systems. As an example of how the graph representation of business logic can be done in practice, you can take a look at
our open source project called [Knot.x](https://knotx.io/) (the actual implementation is done in the
[Knot.x Fragments](https://github.com/Knotx/knotx-fragments) module).

## Summary

A user story is a bridge between problem and solution spaces. It focuses on a domain, specifying domain objects and
relations between them. Business logic defines steps that fill the gap between domain objects. It is a part of the
solution, managed by software engineers.

![Problem space vs solution space](/img/blog/how-to-understand-business-logic/problem-solution-space.png)

Continue reading to the second post in this series: [What is the business logic evolution](/blog/what-is-the-business-logic-evolution/).

---

<small>Hero image by [Roman Mager](https://unsplash.com/@roman_lazygeek?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on Unsplash.</small>
