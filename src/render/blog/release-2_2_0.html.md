---
title: Knot.x 2.2 released!
description: We have just released a minor release Knot.x 2.2.0.
author: tomaszmichalak
keywords: release
order: 1
date: 2020-05-20
knotxVersions:
  - 2.2
---

# Knot.x 2.2
We are extremely pleased to announce that the Knot.x version 2.2.0 has been released.

## New Features

### Debuggable Fragments
With Knot.x, you can easily transform your business logic into a configurable graph structure.
The graph ([task](https://github.com/Knotx/knotx-fragments/tree/2.2.0/task/api#task)) defines
business operations (such as integration with an API) and decisions (if API
responds with `A` then...). Task belongs to a [fragment](https://github.com/Knotx/knotx-fragments/tree/2.2.0/api#fragment),
an abstraction that represents a client request (in some cases it can be an HTTP request, in other, a part of the page). Read more about configurable
integrations [here](https://knotx.io/blog/configurable-integrations/).

From now, you can easily debug your business logic directly in your browser. See the
[Fragments Execution Log](https://github.com/Knotx/knotx-fragments/tree/master/task/handler/log)
modules for more details.

### Chrome Extension
It is an awesome tool that extends the Chrome Developer Tools, providing intuitive business logic
debugging opportunities for developers, QAs and business analysts. It reads fragment(s) debug data
(provided by Fragments Execution Log modules) and visualizes it.

<p align="center">
  <img src="https://github.com/Knotx/knotx-fragments-chrome-extension/raw/master/assets/images/preview.gif" alt="Knot.x Fragments Chrome Extension"/>
</p>

You can read more about this new feature [here](https://knotx.io/tutorials/chrome-extension/2_2/)
or watch the [live coding](https://www.youtube.com/watch?v=EWoHqzYGv0w) session.

### Pebble Template Engine
Next to Handlebars, we add [Pebble templates](https://pebbletemplates.io/) support! From now, you can
use various templates within the single page. What is more, the same as Handlebars, the Pebble processing
is thoroughly scalable with the [Vert.x Event Bus](https://vertx.io/docs/vertx-core/java/#event_bus).

```pebble
<knotx:snippet data-knotx-task="payments-task">
  <div>
    <h2>Payment providers</h2>
    <ul>
      {% for this in root['fetchPayments']['_result'] %}
      <li>
        <p>Payment provider: {{this.name}}</p>
        <p>Payment URL: {{this.paymentUrl}}</p>
      </li>
      {% endfor %}
    </ul>
  </div>
</knotx:snippet>
```

You can read more about this new feature [here](https://github.com/Knotx/knotx-template-engine/tree/2.2.0/pebble)
and see the [example](https://github.com/Knotx/knotx-example-project/tree/master/chrome-extension).

### RestfulAPI support
API Communication logic is provided by configurable HTTP Action (note: you can easily provide your
custom implementation). HTTP Action configures endpoint details, HTTP request params and expected
response data. With Knot.x 2.2 you can fully configure your `POST`/`PUT`/`PATCH`/`DELETE`/`HEAD` API
requests in the same way as you did it for `GET` requests.

You can read more about this new feature [here](https://github.com/Knotx/knotx-fragments/tree/master/action/library#http-action).

### HOCON configs testing
HoconLoader loads the HOCON configuration files and converts them to JSON. With it, writing contract
tests is even simpler.

You can read more about this new feature [here](https://github.com/Knotx/knotx-junit5/tree/2.2.0#hoconloader).

## Upgrade notes
Please note that we upgraded the Knot.x Examples to Knot.x `2.2`. See this [PR](https://github.com/Knotx/knotx-example-project/pull/74/files)
for more details.

### API updates

#### Fragment API
[Fragment API](https://github.com/Knotx/knotx-fragments/tree/master/api) introduces the [Fragment Operation](https://github.com/Knotx/knotx-fragments/tree/2.2.0/api#fragment-operation)
and contains the [FragmentResult](https://github.com/Knotx/knotx-fragments/blob/master/api/docs/asciidoc/dataobjects.adoc#fragmentresult)
model. **This upgrade is required only if you implemented custom actions in your project.**
  - update package from `io.knotx.fragments.handler.api.domain.FragmentResult` to `io.knotx.fragments.api.FragmentResult`

#### Action API
[Action API](https://github.com/Knotx/knotx-fragments/tree/2.2.0/action/api) is extracted from
[Fragments Handler](https://github.com/Knotx/knotx-fragments/tree/2.2.0/task/handler). **This upgrade
is required only if you implemented custom actions in your project.**
  - replace dependency: `knotx-fragments-handler-api:2.1.0` -> `knotx-fragments-action-api:2.2.0`
  - update packages:
    - `io.knotx.fragments.handler.api.Action` -> `io.knotx.fragments.action.api.Action`
    - `io.knotx.fragments.handler.api.ActionFactory` -> `io.knotx.fragments.action.api.ActionFactory`
  - rename `io.knotx.fragments.handler.api.ActionFactory` file in `./src/main/resources/META-INF/services` to
  `io.knotx.fragments.action.api.ActionFactory`

### Starter Kit project

#### Upgrade Gradle plugins
- Upgrade Docker Gradle plugin defined in `./buildSrc/build.gradle.kts` from `com.bmuschko:gradle-docker-plugin:5.3.0`
to `com.bmuschko:gradle-docker-plugin:6.4.0`.
- In the new Knot.x, all Knot.x Gradle plugins are released with each new version of Knot.x. We
recommend to configure them in `./settings.gradle.kts`:
```kotlin
pluginManagement {
    val knotxVersion: String by settings
    plugins {
        id("io.knotx.distribution") version knotxVersion
        id("io.knotx.release-base") version knotxVersion
    }
}
```
See [knotx-starter-kit/settings.gradle.kts](https://github.com/Knotx/knotx-starter-kit/blob/2.2.0/settings.gradle.kts) for more details.

#### Rename Gradle properties
The `io.knotx.distribution` plugin uses `knotx.version` and `knotx.conf` properties defined in
`./gradle.properties`. In Knot.x 2.2 we renamed those properties:
- `knotx.version` -> `knotxVersion`
- `knotx.conf` -> `knotxConf`
and update all references in `./build.gradle.kts`

#### Update Docker script
Replace the `./gradle/docker.gradle.kts` with the new [version](https://github.com/Knotx/knotx-starter-kit/blob/2.2.0/gradle/docker.gradle.kts).

#### Fix references to GitHub resources
When applying scripts from GitHub, please update references from:
```kotlin
apply(from = "https://raw.githubusercontent.com/Knotx/knotx-starter-kit/master/gradle/docker.gradle.kts")
apply(from = "https://raw.githubusercontent.com/Knotx/knotx-starter-kit/master/gradle/javaAndUnitTests.gradle.kts")
```
to tag versions:
```kotlin
apply(from = "https://raw.githubusercontent.com/Knotx/knotx-starter-kit/${project.property("knotxVersion")}/gradle/docker.gradle.kts")
apply(from = "https://raw.githubusercontent.com/Knotx/knotx-starter-kit/${project.property("knotxVersion")}/gradle/javaAndUnitTests.gradle.kts")
```

## Release Notes

### Knot.x Gradle Plugins
- [PR-10](https://github.com/Knotx/knotx-gradle-plugins/pull/10) Knot.x release gradle plugins

### Knot.x Dependencies
- [PR-33](https://github.com/Knotx/knotx-dependencies/pull/33) - Migrate from Maven to Gradle.

### Knot.x Commons
- [PR-14](https://github.com/Knotx/knotx-commons/pull/14) - KnotxServer response configuration - wildcards [41](https://github.com/Knotx/knotx-server-http/issues/41)

### Knot.x Launcher
No important changes in this version.

### Knot.x Junit5
- [PR-56](https://github.com/Knotx/knotx-junit5/pull/56) - Move `HoconLoader` from the `Fragments` module to `JUnit5`.

### Knot.x Server Http
- [PR-53](https://github.com/Knotx/knotx-server-http/pull/53) - Enable resolving placeholders without encoding.
- [PR-46](https://github.com/Knotx/knotx-server-http/pull/46) - KnotxServer response configuration - wildcards [41](https://github.com/Knotx/knotx-server-http/issues/41)

### Knot.x Repository Connector
- [PR-14](https://github.com/Knotx/knotx-repository-connector/pull/10) - Make filtering allowed headers case-insensitive

### Knot.x Fragments
- [PR-154](https://github.com/Knotx/knotx-fragments/pull/154) - Cleanup Fragments modules: renamed modules (`Actions` and all Task related once) to be more self-descriptive. Remove hidden API dependencies.
- [PR-149](https://github.com/Knotx/knotx-fragments/pull/149) - Enable invalid fragments processing when a request param or header specified.
- [PR-148](https://github.com/Knotx/knotx-fragments/pull/148) - Add [Fragment JSON Execution Log Consumer](https://github.com/Knotx/knotx-fragments/tree/master/task/handler/log/json) supporting debug data for JSON responses.
- [PR-138](https://github.com/Knotx/knotx-fragments/pull/138) - Extract [Fragment Execution Log Consumer API](https://github.com/Knotx/knotx-fragments/tree/master/task/handler/log/api) and [Fragment HTML Body Writer](https://github.com/Knotx/knotx-fragments/tree/master/task/handler/log/html).
- [PR-136](https://github.com/Knotx/knotx-fragments/pull/136) - Extract [Actions API & Core](https://github.com/Knotx/knotx-fragments/tree/master/action) modules.
- [PR-119](https://github.com/Knotx/knotx-fragments/pull/119) - Introduce [Fragment Operation](https://github.com/Knotx/knotx-fragments/tree/master/api#fragment-operation) to link [Action](https://github.com/Knotx/knotx-fragments/tree/master/action/api#action) and [Task Action Node](https://github.com/Knotx/knotx-fragments/tree/master/task/factory/default#action-node-factory).
- [PR-120](https://github.com/Knotx/knotx-fragments/pull/120) - HTTP methods for [Http Action](https://github.com/Knotx/knotx-fragments/tree/master/action/library#http-action) - support for `POST`/`PUT`/`PATCH`/`DELETE`/`HEAD` and sending body.
- [PR-106](https://github.com/Knotx/knotx-fragments/pull/106) - Extract [Task Engine](https://github.com/Knotx/knotx-fragments/tree/master/task/engine).
- [PR-100](https://github.com/Knotx/knotx-fragments/pull/100) - KnotxServer response configuration - wildcards, case-insensitive filtering allowed headers
- [PR-99](https://github.com/Knotx/knotx-fragments/pull/99) - [Http Action](https://github.com/Knotx/knotx-fragments/tree/master/action/library#http-action) instances can be reused between requests.
- [PR-96](https://github.com/Knotx/knotx-fragments/pull/96) - Move [Http Action](https://github.com/Knotx/knotx-fragments/tree/master/action/library#http-action) from [Knot.x Data Bridge](https://github.com/Knotx/knotx-data-bridge) to Fragments repository. Actions moved to a new module `knotx-fragments-action-library`.
- [PR-80](https://github.com/Knotx/knotx-fragments/pull/80) - [Circuit Breaker Behaviour](https://github.com/Knotx/knotx-fragments/tree/master/action/library#circuit-breaker-behaviour) understands which custom transitions mean error.
- [PR-84](https://github.com/Knotx/knotx-fragments/pull/84) - Add the [action log](https://github.com/Knotx/knotx-fragments/tree/master/action/api#action-log) support [Inline Payload Action](https://github.com/Knotx/knotx-fragments/tree/master/action/library#inline-payload-action).
- [PR-83](https://github.com/Knotx/knotx-fragments/pull/83) - Add the [action log](https://github.com/Knotx/knotx-fragments/tree/master/action/api#action-log) support to [Inline Body Action](https://github.com/Knotx/knotx-fragments/tree/master/action/library#inline-body-action).
- [PR-82](https://github.com/Knotx/knotx-fragments/pull/82) - Add the [action log](https://github.com/Knotx/knotx-fragments/tree/master/action/api#action-log) support to [In-memory Cache Behaviour](https://github.com/Knotx/knotx-fragments/tree/master/action/library#in-memory-cache-behaviour).
- [PR-60](https://github.com/Knotx/knotx-fragments/pull/60) - Add the [action log](https://github.com/Knotx/knotx-fragments/tree/master/action/api#action-log) support to [Circuit Breaker Behaviour](https://github.com/Knotx/knotx-fragments/tree/master/action/library#circuit-breaker-behaviour). Enforce the `fallback` on error strategy.
- [PR-45](https://github.com/Knotx/knotx-fragments/pull/46) - [Fragment Event Consumer](https://github.com/Knotx/knotx-fragments/tree/master/task/handler/log) mechanism implementation.

### Knot.x Template Engine
- [PR-38](https://github.com/Knotx/knotx-template-engine/pull/38) - Knotx/knotx-fragments#135 Extract actions Core & API.
- [PR-21](https://github.com/Knotx/knotx-template-engine/pull/21) - Pebble Template Engine

### Knot.x Stack
- [PR-110](https://github.com/Knotx/knotx-stack/pull/110) - Knotx/knotx-fragments#154 Fragments modules refactor.
- [PR-100](https://github.com/Knotx/knotx-stack/pull/100) - Knotx/knotx-fragments#135 Extract actions Core & API.
- [PR-97](https://github.com/Knotx/knotx-stack/pull/97) - Knotx/knotx-fragments#92 Extract HTML Fragment Event Consumer.
- [PR-96](https://github.com/Knotx/knotx-stack/pull/96) - Knotx/knotx-fragements#73 Functional test for various HTTP methods.
- [PR-92](https://github.com/Knotx/knotx-stack/pull/92) - Knotx/knotx-fragments#92 Functional tests for exposing task metadata.
- [PR-87](https://github.com/Knotx/knotx-stack/pull/87) - Knotx/knotx-fragments#92 Update scenario with more validations.
- [PR-86](https://github.com/Knotx/knotx-stack/pull/86) - #85 Different TE (handlebars and pebble) in fragments integration test.
- [PR-78](https://github.com/Knotx/knotx-stack/pull/78) - Knotx/knotx-fragments#95 Move HTTP Action from Knotx/knotx-data-bridge to Knotx/knotx-fragments.
- [PR-77](https://github.com/Knotx/knotx-stack/pull/77) - Knotx/knotx-fragments#92 Demo scenario for exposing data from task.
- [PR-76](https://github.com/Knotx/knotx-stack/pull/76) - Knotx/knotx-template-engine#20 Pebble Template Engine Integration Test
- [PR-74](https://github.com/Knotx/knotx-stack/pull/74) - knotx/knotx-dependecies#28 Migrate BOM to Gradle & add BOM to Gradle composite build.
- [PR-72](https://github.com/Knotx/knotx-stack/pull/72) - knotx/knotx-fragments#79 Configuration changes & functional tests..
- [PR-69](https://github.com/Knotx/knotx-stack/pull/69) - Circuit breaker: `_fallback` transition && fallback on failure strategy

### Knot.x Docker
- [PR-3](https://github.com/Knotx/knotx-docker/pull/3) - migrate build to Gradle

### Knot.x Starter Kit
- [PR-34](https://github.com/Knotx/knotx-starter-kit/pull/34) - Knotx/knotx-aggregator#19 Releasing with Gradle.
- [PR-35](https://github.com/Knotx/knotx-starter-kit/pull/35) - Knotx/knotx-fragments#154 Update Fragment modules dependencies.
- [PR-31](https://github.com/Knotx/knotx-starter-kit/pull/31) - Knotx/knotx-fragments#135 Extract actions Core & API.
- [PR-27](https://github.com/Knotx/knotx-starter-kit/pull/27) - Knotx/knotx-fragments#118 Update imports.
- [PR-24](https://github.com/Knotx/knotx-starter-kit/pull/24) - #15 Update Knot.x version and apply API changes.
