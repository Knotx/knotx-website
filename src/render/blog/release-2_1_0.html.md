---
title: Knot.x 2.1.0 released!
description: We have just released a minor release Knot.x 2.1.0.
keywords: release
order: 1
date: 2019-12-16
knotxVersions:
    - 2.1.0
---
# Knot.x 2.1.0

## Release Notes

### [knotx-dependencies](https://github.com/Knotx/knotx-dependencies)
- [PR-30](https://github.com/Knotx/knotx-dependencies/pull/30) - Upgrade to Vert.x `3.8.4`.

### [knotx-launcher](https://github.com/Knotx/knotx-launcher)
- [PR-19](https://github.com/Knotx/knotx-launcher/pull/19) - Remove deprecated API usage, Vert.x 3.8.1.

### [knotx-junit5](https://github.com/Knotx/knotx-junit5)
- [PR-39](https://github.com/Knotx/knotx-junit5/pull/39) - Fixed missing content-type header for ClasspathResourcesMockServer files

### [knotx-server-http](https://github.com/Knotx/knotx-server-http)
- [PR-35](https://github.com/Knotx/knotx-server-http/pull/35) - Vert.x upgrade to 3.8.1. Cookie Handler was deprecated: cookies are enabled by default and `cookieHandler` handler is not required anymore.

### [knotx-fragments](https://github.com/Knotx/knotx-fragments)
- [PR-62](https://github.com/Knotx/knotx-fragments/pull/62) - It introduces task & graph node factories. It is connected with issue #49.
- [PR-51](https://github.com/Knotx/knotx-fragments/pull/51) - Introduces extendable task definition allowing to define different node types and custom task providers. Marks the `actions` task configuration entry as deprecated, introduces `subtasks` instread.
- [PR-56](https://github.com/Knotx/knotx-fragments/pull/56) - Makes composite node identifiers changeable. Renames `ActionNode` to `SingleNode`. 
- [PR-55](https://github.com/Knotx/knotx-fragments/pull/55) - Action log mechanism implementation. Renames `ActionFatalException` to `NodeFatalException`.

### [knotx-data-bridge](https://github.com/Knotx/knotx-data-bridge)
- [PR-58](https://github.com/Knotx/knotx-data-bridge/pull/58) - HTTP response body validation for content-type

### [knotx-template-engine](https://github.com/Knotx/knotx-template-engine)
- [PR-18](https://github.com/Knotx/knotx-template-engine/pull/18) - `com.github.jknack` Handlebars updated to `4.1.2`.

### [knotx-stack](https://github.com/Knotx/knotx-stack)
- [PR-68](https://github.com/Knotx/knotx-stack/pull/68) - Fix unit tests with custom wiremock instance.
- [PR-62](https://github.com/Knotx/knotx-stack/pull/62) - Configure task and node factories in Fragments Handler module.
- [PR-64](https://github.com/Knotx/knotx-stack/pull/64) - Add Unit tests for default stack configuration files.
- [PR-59](https://github.com/Knotx/knotx-stack/pull/59) - Remove cookie handler, it is not required from Vert.x 3.8.1.

### [knotx-starter-kit](https://github.com/Knotx/knotx-starter-kit)
- [PR-18](https://github.com/Knotx/knotx-starter-kit/pull/18) - Apply task & node factories changes.
- [PR-17](https://github.com/Knotx/knotx-starter-kit/pull/17) - Build ZIP distribution.

## Upgrade notes

### Task & node factories configuration changes
#### In 2.0
```hocon
tasks { # tasks here }
actions { # actions here }
```
#### In 2.1
```hocon
taskFactories = [
  {
    factory = default
    config {
      tasks = tasks { # tasks here }
      nodeFactories = [
        {
          factory = action
          config.actions = { # actions here }
        }
        {
          factory = subtasks
        }
      ]
    }
  }
]
```

### Rename `actions` to `subtasks`
#### In 2.0
```hocon
tasks {
  books-and-authors-listing {
    actions = [
      {
        ...
      },
      {
        ...
      }
    ]
    onTransitions {
      ...
    }
  }
}
```
#### In 2.1
```hocon
tasks {
  books-and-authors-listing {
    subtasks = [
      {
        ...
      },
      {
        ...
      }
    ]
    onTransitions {
      ...
    }
  }
}
```

### HTTP response body validation for content-type (HTTP Action)
If you wish to leave the previous behaviour (when non-json response is returned, exception is thrown), 
just configure responseOptions in your action config like this:
```hocon
     responseOptions {
        predicates = [JSON]
        forceJson = false
      }
```  

### Remove `cookieHandler` from server common handlers list:
#### In 2.0
```hocon
config.server {
  handlers.common {
    request = [
      {	
        name = cookieHandler	
      },	
      {	
        name = bodyHandler
      },
      // ...
    ]
  }
}  
```
#### In 2.1
```hocon
config.server {
  handlers.common {
    request = [
      {	
        name = bodyHandler
      },
      //...
    ]
  }
}
```

### Build ZIP distribution with Knot.x Starter Kit
Remove:
```
tasks.named("build") {
    dependsOn("runTest")
}
```

and add:
```
tasks.named("build") {
    dependsOn("build-stack")
}

tasks.register("build-docker") {
    group = "docker"
    dependsOn("runTest")
}

tasks.register("build-stack") {
    group = "stack"
    // https://github.com/Knotx/knotx-gradle-plugins/blob/master/src/main/kotlin/io/knotx/distribution.gradle.kts
    dependsOn("assembleCustomDistribution")
    mustRunAfter("build-docker")
}
```
in `build.gradle.kts` when [Knot.x Starter Kit](https://github.com/Knotx/knotx-starter-kit) used.
