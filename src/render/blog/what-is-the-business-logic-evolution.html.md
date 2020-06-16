---
title: What is the business logic evolution
description: In the second post of the "Business Logic Evolution" series we will focus on explainig what is the business logic evolution and give you examples of changes that may occur during the project development.
author: skejven
keywords: business-logic,domain-driven-design,user-stories
order: 1
date: 2020-06-15
---
![people walking on sidewalk during daytime](/img/blog/what-is-the-business-logic-evolution/hero-image.jpg)

In the previous article in the series we explained [what business logic is](/blog/how-to-understand-business-logic/). Now it’s time to talk about business logic evolution.

After the [Cambridge Dictionary](https://dictionary.cambridge.org/dictionary/english/evolution), evolution is:

> a gradual process of change and development

and

> the process by which the physical characteristics of types of creatures change over time, new types of creatures develop, and others disappear.

This definition translates very well into the Domain-Driven Design (DDD). As we mentioned in the previous article, a user story is the bridge between problem and solution spaces. Now, please try to remember the last project you were in and at least one of the following statements was true:

* all the user stories were written down from the beginning,
* no of the user stories written once has changed,
* all user stories were so precise that there were no doubts and they covered all the possible scenarios.

You can’t, right? That’s because user stories focus on business requirements and domain problems. The real world is much more complex than a simple sentence “As the user X I want to Y”. And this complexity is embraced by the solution space (the implementation), which leaves a very wide range for developers’ interpretation and future evolution.

On the other hand, our world is continuously changing and business responds to new circumstances introducing new and discarding old requirements.

To explain how the business logic can change over time, let’s again start with the examples from the previous article:

> Standard user gets standard products.</br>
> Premium user gets premium products.

The diagram below presents a simplified implementation with steps for getting the user, standard products and premium products.

![Basic user story example](/img/blog/what-is-the-business-logic-evolution/basic-example.png "Basic user story example")

It is time to see what kinds of changes we can expect. 

## New decisions

Adding a new user story to the existing ones is the primary evolution case. A new user story appears when:

* the original ones do not cover all business requirements, 
* there is a new condition business wants to follow. 

Let’s add one more case to our example:

> Standard user gets standard products.</br>
> Premium user gets premium products.</br>
> **Gold** user gets **gold** products.

That change happens all the time. But how does it influence our business logic? Let's illustrate the new steps at the diagram:

![New decision](/img/blog/what-is-the-business-logic-evolution/new-decision.png "New decision")

Are you surprised? When we add a new user story, it usually means no more or less than introducing a new decision to our solution. This operation is trivial in the graph representation - we create the new node that follows the user node.

## Detailing the output

Another elementary evolution case is detailing the existing user stories. It happens when the original assumptions are not valid or not all the business needs are covered.

In our example, we are going to detail the second user story, the premium one. As we understand that premium users have some shopping history, we can provide them with a better offer, the personalized one.

> Standard user gets standard products.</br>
> Premium user gets premium products.</br>
> **Premium products are personalized**.

Applying this change to the steps diagram, we can notice that business logic input and outputs have not changed. As you can see, it is a single node that performs some personalization logic. So this change has a very limited scope. 

![Detailing the output](/img/blog/what-is-the-business-logic-evolution/detailing-output.png "Detailing the output")

## Detailing the input

Previous examples impacted the logic outputs. But what if the change affects the input, not the output? When a new requirement concerning business logic input appears, it changes a set of existing user stories globally (each of the existing user stories is touched by the change).

Let's see the simple example:

> **Unlogged user follows standard user rules.**</br>
> Standard user gets standard products.</br>
> Premium user gets premium products.

The new user story appeared. At first glance, we seem to be introducing another user type, an unlogged user. It is similar to the first example, where we added a new decision (output). However, in this case, this change involves further modifications - we need to redesign the user model (our domain object). Changing the model, we have to rethink many aspects such as the user name, age etc.

But is this the right way to handle that change?

This new requirement does not tell that there is a new user type. A much better and flexible solution would be to include the change to our business logic. Since the unlogged users should follow the standard user requirements, we should adapt our input to interpret unlogged users correctly.

![Detailing the input](/img/blog/what-is-the-business-logic-evolution/detailing-input.png "Detailing the input")

Checking the steps diagram, we can easily say that the change impacts the input. However, this change does not break any of the implemented steps. We can apply changes to the context to simulate a standard user. As you can see, accidental changes in business logic inputs can be expensive, so we need to be careful when applying them.

## Handling errors

And now time for a little reflection. What if a requirement comes from the engineering team? How does error handling impact user stories and the solution? Try to remember a situation, when something unexpected happened in a well-designed algorithm (or at least you thought it was well-designed until that happened). And that moment when you think “why it wasn’t like that from the beginning”.

Actually, that's a really common scenario. That’s because when business defines requirements, there are no details on how it will be implemented by developers. That makes figuring out any corner case behaviours, especially those technical, almost impossible. On the other hand, when developers start the implementation, some technical details are discovered (e.g. data will be fetched from web service). Depending on those details, some changes in requirements should be suggested by the architects/engineering team. And here is the example:


> Standard user gets standard products.</br>
> Premium user gets premium products.</br>
> **When premium projects are not available, premium user gets products from cache.**

Notice the red color that is an alternative step for the error that occurred - that’s an additional decision:

![Handling errors](/img/blog/what-is-the-business-logic-evolution/handing-errors.png "Handling errors")

## Summary

In short words, business logic evolution can be defined as some unexpected or forgotten details that change user stories. In this post, we went through a series of most common examples of business logic evolution. We also explained that there might be several situations when business logic evolves like discovery of an error, new or unknown details, or just technical difficulties mitigation.

---

<small>Hero image by [Eugene Zhyvchik](https://unsplash.com/@eugenezhyvchik?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on Unsplash.</small>
