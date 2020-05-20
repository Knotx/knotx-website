---
title: Knot.x 2.2 released!
description: We have just released a minor release Knot.x 2.2.0.
author: admin
keywords: release
order: 1
date: 2020-05-20
knotxVersions:
  - 2.2
---

# Knot.x 2.2


## Release Notes

### Knot.x Gradle Plugins
- [PR-10](https://github.com/Knotx/knotx-gradle-plugins/pull/10) Knot.x release gradle plugins

### Knot.x Dependencies
- [PR-33](https://github.com/Knotx/knotx-dependencies/pull/33) - Migrate from Maven to Gradle.

### Knot.x Commons
- [PR-14](https://github.com/Knotx/knotx-commons/pull/14) - KnotxServer response configuration - wildcards [41](https://github.com/Knotx/knotx-server-http/issues/41)
- [PR-8](https://github.com/Knotx/knotx-commons/pull/8) - Unit Test for HTTP request commons

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
- [PR-94](https://github.com/Knotx/knotx-stack/pull/94) - Gradle 6.2.2
- [PR-92](https://github.com/Knotx/knotx-stack/pull/92) - Knotx/knotx-fragments#92 Functional tests for exposing task metadata.
- [PR-89](https://github.com/Knotx/knotx-stack/pull/89) - #71 Remove deprecated tests: ResponseHeadersTest.
- [PR-88](https://github.com/Knotx/knotx-stack/pull/88) - #71 Remove deprecated tests: TemplatingIntegrationTest.
- [PR-87](https://github.com/Knotx/knotx-stack/pull/87) - Knotx/knotx-fragments#92 Update scenario with more validations.
- [PR-86](https://github.com/Knotx/knotx-stack/pull/86) - #85 Different TE (handlebars and pebble) in fragments integration test.
- [PR-83](https://github.com/Knotx/knotx-stack/pull/84) - Upgrade to Gradle 6.2
- [PR-83](https://github.com/Knotx/knotx-stack/pull/83) - Upgrade to Gradle 6.1.1
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



## Upgrade notes