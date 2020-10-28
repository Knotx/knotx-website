---
title: Knot.x 2.3.0 released!
description: We have just released a minor release Knot.x 2.3.0.
keywords: release
order: 1
date: 2020-10-28
knotxVersions:
  - 2.3.0
---

# Knot.x 2.3.0
We are extremely pleased to announce that the Knot.x version 2.3.0 has been released.


## Release Notes

### Knot.x Gradle Plugins
No important changes in this version.
                
### Knot.x Dependencies
- [PR-55](https://github.com/Knotx/knotx-dependencies/pull/55) - Upgrade to Vert.x `3.9.4`.

### Knot.x Commons
- [PR-37](https://github.com/Knotx/knotx-commons/pull/37) Updates in `JsonObjectUtil`.
- [PR-35](https://github.com/Knotx/knotx-commons/pull/35) Introduce Cache and CacheFactory interfaces and in-memory implementation - moved from `knotx-fragments` [192](https://github.com/Knotx/knotx-fragments/issues/192)
                
### Knot.x Launcher
No important changes in this version.
                
### Knot.x Junit5
- [PR-62](https://github.com/Knotx/knotx-junit5/pull/62) - Fixes `RequestUtil` failure verification: assertion error not propagated.
                
### Knot.x Server Http
No important changes in this version.
                
### Knot.x Repository Connector
No important changes in this version.
                
### Knot.x Fragments
- [PR-203](https://github.com/Knotx/knotx-fragments/pull/203) - Fixing [#197](https://github.com/Knotx/knotx-fragments/issues/197): Invoke actions via ActionInvoker.
- [PR-201](https://github.com/Knotx/knotx-fragments/pull/201) - Prevent StackOverflowException when evaluating fragment as HTML attributes.
- [PR-198](https://github.com/Knotx/knotx-fragments/pull/198) - Introduce `CopyPayloadKeyActionFactory` to enable coping inside Fragment's payload.
- [PR-196](https://github.com/Knotx/knotx-fragments/pull/196) - Rename `doActionLogs`  in [Actions](https://github.com/Knotx/knotx-fragments/tree/master/action)' log to `invocations`.
- [PR-195](https://github.com/Knotx/knotx-fragments/pull/195) - Simplifie `ActionProvider`'s constructor.
- [PR-194](https://github.com/Knotx/knotx-fragments/pull/194) - Generalize `InMemoryCacheAction` to support different `Cache` implementations. Provides test refactoring.
- [PR-188](https://github.com/Knotx/knotx-fragments/pull/188) - Expose nested doActions' (possibly chained) configuration in `OperationMetadata`.
- [PR-187](https://github.com/Knotx/knotx-fragments/pull/187) - Provide `SingleFragmentOperation` to simplify implementation of RXfied actions.
- [PR-186](https://github.com/Knotx/knotx-fragments/pull/186) - Provide `FutureFragmentOperation` and `SyncFragmentOperation` to simplify implementation of asynchronous and synchronous actions.
- [PR-181](https://github.com/Knotx/knotx-fragments/pull/181) - Introduce an error log to `FragmentResult` for handling failures. All `FragmentResult`constructors are deprecated now.
- [PR-174](https://github.com/Knotx/knotx-fragments/pull/172) - Add node processing errors to the [graph node response log](https://github.com/Knotx/knotx-fragments/blob/master/task/handler/log/api/docs/asciidoc/dataobjects.adoc#graphnoderesponselog).
- [PR-172](https://github.com/Knotx/knotx-fragments/pull/172) - Add a task node processing exception to event log. Remove unused 'TIMEOUT' node status. Update node unit tests.
- [PR-170](https://github.com/Knotx/knotx-fragments/pull/170) - Upgrade to Vert.x `3.9.1`, replace deprecated `setHandler` with `onComplete`.
                
### Knot.x Template Engine
- [PR-47](https://github.com/Knotx/knotx-template-engine/pull/47) - Upgrade to Vert.x `3.9.1`, replace deprecated `setHandler` with `onComplete`.
     
### Knot.x Stack
- [PR-118](https://github.com/Knotx/knotx-stack/pull/118) - Upgrade to Vert.x `3.9.1` - removed `netty-tcnative` as TLS ALPN support has been back-ported to JDK 8.

### Knot.x Docker
No important changes in this version.
                
### Knot.x Starter Kit
No important changes in this version.



## Upgrade notes

### Knot.x Dependencies
- [PR-55](https://github.com/Knotx/knotx-dependencies/pull/55) - Upgrade to Vert.x `3.9.4`.
  - It looks that that validation libs were updated in https://github.com/vert-x3/vertx-web/pull/1708 and after upgrade to Vert.x 3.9.4 the issue was validated so the tests with invalid specs failed. See [knotx-server/#68](https://github.com/Knotx/knotx-server-http/pull/68) for more details.

### Knot.x commons (affecting Knot.x fragments)
- [PR-37](https://github.com/Knotx/knotx-commons/pull/37) Updates in `JsonObjectUtil`.
  - Contract for getString changes: the function no longer returns null if some intermediate key is not present, but returns an empty JsonObject instead. Validated it does not change PlaceholdersResolver behaviour (the only usage in stack).

### Knot.x Fragments
- [PR-203](https://github.com/Knotx/knotx-fragments/pull/203) - Fixing [#197](https://github.com/Knotx/knotx-fragments/issues/197): Invoke actions via ActionInvoker.
  - It is advised to switch from direct action calling to using ActionInvoker utility class.
  - This ensures that the execution will not halt for some of the known issues in Vert.x and Knot.x implementations.

- [PR-172](https://github.com/Knotx/knotx-fragments/pull/172) - Add a task node processing exception to event log. Remove unused 'TIMEOUT' node status. Update node unit tests.
  - Move `io.knotx.fragments.task.engine.exception.NodeFatalException` (from Task Engine module) with `io.knotx.fragments.task.api.NodeFatalException` (to Task API module). When a node throws an exception, the task engine handles it and responds with `io.reactivex.exceptions.CompositeException` containing both `NodeFatalException` and `io.knotx.fragments.task.engine.TaskFatalException`.
  - Remove 'TIMEOUT' from `NodeStatus`. Task engine does not support any time restriction on nodes. It is node responsibility to add such "behaviours". See [Actions](https://github.com/Knotx/knotx-fragments/tree/master/action/library) for more details.

### Knot.x Stack
- [PR-118](https://github.com/Knotx/knotx-template-engine/pull/118) - Upgrade to Vert.x `3.9.1` - removed `netty-tcnative` as TLS ALPN support has been back-ported to JDK 8.
  - TLS ALPN support has been back-ported to JDK 8 recently and Vert.x has been upgraded to support it which means now you can have HTTP/2 on JDK 8 out of the box. `netty-tcnative` was removed from stack dependencies. If your Knot.x image does not base on newer version of JDK 8, you may need to add `io.netty:netty-tcnative-boringssl-static` to the classpath in order to use HTTP/2. See https://github.com/eclipse-vertx/vert.x/issues/3391 for details.
