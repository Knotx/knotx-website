---
title: Knot.x 2.4.0 released!
description: We have just released a minor release Knot.x 2.4.0.
keywords: release
order: 1
date: 2024-03-16
knotxVersions:
  - 2.4.0
---

# Knot.x 2.4.0
We are extremely pleased to announce that the Knot.x version 2.4.0 has been released.

## Changes

### JDK 11 support
All modules within Knot.x were updated from JDK `8` (`AdoptOpenJDK`) to JDK 11 (`Temurin`).

### Fixing vulnerabilities
This release addresses security concerns by resolving the following vulnerabilities:

- [io.vertx:vertx-dependencies:3.9.8](https://mvnrepository.com/artifact/io.vertx/vertx-dependencies/3.9.8) -> [io.vertx:vertx-dependencies:3.9.16](https://mvnrepository.com/artifact/io.vertx/vertx-dependencies/3.9.16)
- [commons-io:commons-io:2.5](https://mvnrepository.com/artifact/commons-io/commons-io/2.5) -> [commons-io:commons-io:2.15.1](https://mvnrepository.com/artifact/commons-io/commons-io/2.15.1)
- [org.apache.commons:commons-collections4:4.2](https://mvnrepository.com/artifact/org.apache.commons/commons-collections4/4.2) -> [org.apache.commons:commons-collections4:4.4](https://mvnrepository.com/artifact/org.apache.commons/commons-collections4/4.4)
- [com.google.guava:guava:30.1.1-jre](https://mvnrepository.com/artifact/com.google.guava/guava/30.1.1-jre) -> [com.google.guava:guava:33.0.0-jre](https://mvnrepository.com/artifact/com.google.guava/guava/33.0.0-jre)
- [ch.qos.logback:logback-classic:1.2.3](https://mvnrepository.com/artifact/ch.qos.logback/logback-classic/1.2.3) -> [ch.qos.logback:logback-classic:1.4.14](https://mvnrepository.com/artifact/ch.qos.logback/logback-classic/1.4.14)
- [com.github.tomakehurst:wiremock-jre8:2.30.1](https://mvnrepository.com/artifact/com.github.tomakehurst/wiremock-jre8/2.30.1) -> [org.wiremock:wiremock:3.3.1](https://mvnrepository.com/artifact/org.wiremock/wiremock/3.3.1)
- [io.pebbletemplates:pebble:3.1.2](https://mvnrepository.com/artifact/io.pebbletemplates/pebble/3.1.2) -> [io.pebbletemplates:pebble:3.2.2](https://mvnrepository.com/artifact/io.pebbletemplates/pebble/3.2.2)

## Release Notes

### Knot.x Gradle Plugins
- [PR-50](https://github.com/Knotx/knotx-gradle-plugins/pull/50) Upgrade JDK from 8 to 11, upgrade Gradle to 7.6.3
        
### Knot.x Dependencies
- [PR-71](https://github.com/Knotx/knotx-dependencies/pull/71) **[security]** Upgrade to Vert.x `3.9.16`, fixing outdated dependencies vulnerabilities

### Knot.x Commons
No important changes in this version.
                
### Knot.x Launcher
- [PR-51](https://github.com/Knotx/knotx-launcher/pull/51) - Upgrade Gradle to 7.6.3

### Knot.x Junit5
- [PR-78](https://github.com/Knotx/knotx-junit5/pull/78) Upgrade Gradle to 7.6.3, upgrade wiremock dependency.

### Knot.x Server Http
- [PR-78](https://github.com/Knotx/knotx-server-http/pull/78) Upgrade Gradle to 7.6.3, Rest-Assured

### Knot.x Repository Connector
- [PR](https://github.com/Knotx/knotx-repository-connector/pull/41) Upgrade Gradle to 7.6.3, Wiremock.

### Knot.x Fragments
- [PR-223](https://github.com/Knotx/knotx-fragments/pull/223) Upgrade Gradle to 7.6.3, Wiremock

### Knot.x Template Engine
- [PR-59](https://github.com/Knotx/knotx-template-engine/pull/59) Upgrade Gradle to 7.6.3, Handlebars to 4.3.1, Pebble Templates to 3.2.2

### Knot.x Stack
No important changes in this version.
                
### Knot.x Docker
- [PR-30](https://github.com/Knotx/knotx-docker/pull/30) Upgrade Docker images to JDK 11, upgrade Gradle to 7.6.3
         
### Knot.x Starter Kit
- [PR-53](https://github.com/Knotx/knotx-starter-kit/pull/53) Upgrade to JDK 11, upgrade Gradle to 7.6.3

## Upgrade notes
Configure JDK 11 in your Gradle project:

```
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(11))
        vendor.set(JvmVendorSpec.ADOPTIUM)
    }
}
```
