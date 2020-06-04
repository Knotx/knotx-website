---
title: What does business logic mean for us
description: We will find an answer what does the business logic mean for us. We would transform user stories to domain objects and then model the solution.
author: tomaszmichalak
keywords: business,requirements,user-stories,business-logic,domain-object,domain-space,solution-space
order: 1
date: 2020-06-04
---

This is the first article in the series dedicated to the subject of business logic.

## Story
We begin with a brief story, the user story.

> Once upon a time... a user gets products.

This sentence captures a requirement of a software feature from an end-user perspective. It describes
what the user wants. The subject (“user”) is a model (class) that has no behaviour (methods) defined,
and contains data (properties). In the Domain-Driven Design (DDD) it is called a domain object. Our
story specifies two domain objects: a user and a product.
The verb (“gets”) defines an action/state/relation between our domain objects. What is interesting even
though it's a single word hiding most of the complexity in the solution we are building. One more fact,
user stories focus on results, leaving out the technical details like “how” to get products.

## Business logic
Detailing “how” we actually call the business logic. Domain objects define “who” and “what”. So business
logic is a part of the solution (application) that executes user stories, using domain objects as its
inputs and outputs.

![Business logic input and output](/img/blog/business-logic-definition/business-logic-input-output.png)

Looking at the diagram above, we quickly notice the similarity between business logic and a computer
program - let’s call it a function for simplicity. Every function takes an input that is expected to
be in defined form and returns the output - also in the expected format. In simple words, we can assume
that input and output legislate a function's contract. And the contract for the function that represents
our example user story would be:

```shell script
Domain objects: User, Product
Input: User
Output: Products(User)
```

The output is a list of products that are in the User’s context.

So we can proceed now to fulfil our business logic. Having the output, we can divide our into two steps:
- the first step gets details about the user
- the second step uses user details and gets products

![Business logic decomposition](/img/blog/business-logic-definition/business-logic-decomposition.png)

It is easy to see that the result of the previous step becomes the input of the next.

## Decisions
Let's make our example user story more specific:

> Standard user gets standard products.
> Premium user gets premium products.

Adjectives define domain object properties, the attributes. Now our functions look like:

```shell script
Product<Standard> (User<Standard>)
Product<Premium> (User<Premium>)
```


Attributes define business decisions. Those decisions define a context for the next steps. So each
subsequent step is in the context of previous decisions.

So our “steps” diagram looks like:

![alt_text](/img/blog/business-logic-definition/business-logic-variants.png)

The “get user” steps for both scenarios accept the same input (`Context`) and define two different
outputs (`User<Standard>` and `User<Premium>`). Those outputs are business decisions. Steps with the
same input can be easily merged.

![alt_text](/img/blog/business-logic-definition/business-logic-decisions.png)

As you can see, steps can have a single input and multiple outputs. Input specifies previous business
decisions, and outputs new.

## Big picture
The presented user stories were trivial. Very often, they are the result of breaking down more complex
domain problems into small manageable items. So one story defines input for another, etc. Combining
them together we get a graph of steps.

![alt_text](/img/blog/business-logic-definition/business-logic-big-picture.png)

So business decisions produce branches to new steps/logics. Finally, we get an acyclic directed graph
of steps (it's actually a tree), where leaves are the final outputs.

## Summary
A user story, written by business, is a bridge between problem and solution spaces. It focuses on a
domain, specifying domain objects and relations between them. Business logic defines steps that fill
the gap between domain objects. It is a part of the solution, managed by software engineers.

![alt_text](/img/blog/business-logic-definition/problem-solution-space.png)
