---
title: Knot.x 1.4.0 released!
description: We have just released a minor release Knot.x 1.4.0.
keywords: release
order: 1
date: 2018-10-10
knotxVersions:
    - 1.4.0
---
# Knot.x 1.4.0

## Release Notes

### [knotx-core](https://github.com/Cognifide/knotx)
- [PR-427](https://github.com/Cognifide/knotx/pull/427) - HttpRepositoryConnectorProxyImpl logging improvements
- [PR-422](https://github.com/Cognifide/knotx/pull/422) - Configurable Handlebars delimiters
- [PR-428](https://github.com/Cognifide/knotx/pull/428) - Mark all Service Knot related classes deprecated.
- [PR-432](https://github.com/Cognifide/knotx/pull/432) - Port unit and integration tests to JUnit 5
- [PR-440](https://github.com/Cognifide/knotx/pull/440) - Enable different Vert.x Config stores types fix.
- [PR-443](https://github.com/Cognifide/knotx/pull/443) - Update maven plugins versions.
- [PR-445](https://github.com/Cognifide/knotx/pull/445) - Vert.x version upgrade to 3.5.3
- [PR-458](https://github.com/Cognifide/knotx/pull/458) - Remove unused StringToPattern function

### [knotx-dependencies](https://github.com/Knotx/knotx-dependencies)
- [PR-2](https://github.com/Knotx/knotx-dependencies/pull/2) - JUnit 5 libraries added
- [PR-7](https://github.com/Knotx/knotx-dependencies/pull/7) - Configure Knot.x Data Bridge in BOM file
- [PR-9](https://github.com/Knotx/knotx-dependencies/pull/9) - Updated JUnit, added Apache Collections v4 and AssertJ versions
- [PR-10](https://github.com/Knotx/knotx-dependencies/pull/10) - Vert.x version upgraded to 3.5.3

### [knotx-junit5](https://github.com/Knotx/knotx-junit5)
First release of the Knot.x Junit5 module that enables full support for Junit5 in Knot.x tests.

### [knotx-data-bridge](https://github.com/Knotx/knotx-data-bridge)
First release of the [Knot.x Data Bridge](https://github.com/Knotx/knotx-data-bridge) module
that replaces old [Knot.x Service Knot](https://github.com/Cognifide/knotx/wiki/ServiceKnot)
(which is now deprecated and will be removed soon).

### [knotx-stack](https://github.com/Knotx/knotx-stack)
- [PR-5](https://github.com/Knotx/knotx-stack/pull/5) - Knot.x Data Bridge introduced instead of Service Knot
- [PR-18](https://github.com/Knotx/knotx-stack/pull/18) - Introduced Junit5 and integration tests module
- [PR-25](https://github.com/Knotx/knotx-stack/pull/25) - Fixed http repo headers conifg


### [knotx-example-project](https://github.com/Knotx/knotx-example-project)
- [PR-19](https://github.com/Knotx/knotx-example-project/pull/19) - Fixed http repo headers conifg

## Upgrade Notes

### Replace `Service Knot` with `Data Bridge Knot`

> Notice! You may still use old `Service Knot` with Knot.x 1.4 if you want
In order to start using Knot.x with Data Bridge do following changes:

#### Configuration files
1. In your main config, update `modules` section from:
```hocon
  "serviceKnot=io.knotx.knot.service.ServiceKnotVerticle"
  "serviceAdapter=io.knotx.adapter.service.http.HttpServiceAdapterVerticle"
```

to

```hocon
  "dataBridge=io.knotx.databridge.core.DataBridgeKnot"
  "dataSourceHttp=io.knotx.databridge.http.HttpDataSourceAdapter"
```

2. Define Data Bridge constants in the `global` section of `application.conf`:
```hocon
  # Data Bridge globals
  bridge {
    address = knotx.knot.databridge
    dataSource {
      http.address = knotx.bridge.datasource.http
    }
  }
```
3. nstead including `serviceKnot.conf` and `serviceAdapter.conf` change includes
to `dataBridge.conf` and `dataSourceHttp.conf`.
You will find examples of those files in
[`knotx-stack distribution`](https://github.com/Knotx/knotx-stack/blob/1.4.0/knotx-stack-manager/src/main/packaging/conf/includes).
4. Move all your `services` definitions from `serviceKnot.conf` to `dataDefinitions` in `dataBridge.conf`.
5. Move all your `services` definitions from `serviceAdapter.conf` to `dataSourceHttp.conf`.

Refer to [example application.conf](https://github.com/Knotx/knotx-stack/blob/1.4.0/knotx-stack-manager/src/main/packaging/conf/application.conf)
in the Knot.x Stack project.


#### Page templates
Alter all Knot.x snippets in your repository.
1. Update `data-knotx-knots` values from `services` to `databridge`.
2. Update data bindings from `data-knotx-service-${NAMESPACE}` to `data-knotx-databridge-name-${NAMESPACE}`.
3. Update data params from `data-knotx-params-${NAMESPACE}` to `data-knotx-databridge-params-${NAMESPACE}`.

If you use custom param-prefix (default is `data-knotx-`), you may also set them for Knot.x Data Bridge module.

#### Custom adapters upgrade
If you implemented your own Service Adapter (by implementing
[`io.knotx.proxy.AdapterProxy`](https://github.com/Cognifide/knotx/blob/1.3.0/knotx-core/src/main/java/io/knotx/proxy/AdapterProxy.java)
refactor it to implement
[`io.knotx.databridge.api.DataSourceAdapterProxy.java`](https://github.com/Knotx/knotx-data-bridge/blob/1.4.0/api/src/main/java/io/knotx/databridge/api/DataSourceAdapterProxy.java)
instead.

#### Tests update
Knot.x 1.4 comes with JUnit 5 support. Instead of including `knotx-core` start using `knotx-junit5`.
Instead of using `@RunWith(VertxUnitRunner.class)` use extension `@ExtendWith(KnotxExtension.class)`.

Also you don't need those any more:
```java
  private RunTestOnContext vertx = new RunTestOnContext();
  private TestVertxDeployer knotx = new TestVertxDeployer(vertx);
  @Rule
  public RuleChain chain = RuleChain.outerRule(vertx).around(knotx);
```

Just annotate your tests with `@KnotxApplyConfiguration("path-to-config")`
instead of `@KnotxConfiguration("path-to-config")`.

You may find example of migrating Knot.x JUnit tests in those PRs:
- [Data Bridge JUnit 5 migration](https://github.com/Knotx/knotx-data-bridge/pull/19/files)
- [Knot.x Core JUnit 5 migration](https://github.com/Cognifide/knotx/pull/432/files)

### Fix `Http Repository` headers wildcards
In the Http Repository configuration update `allowedRequestHeaders` section.
`*` is no longer a wildcard, now regexp are allowed so e.g. change any:
```hocon
allowedRequestHeaders = [
  "Accept*"
  ...
]
```
to
```hocon
allowedRequestHeaders = [
  "Accept.*"
  ...
]
```

All regular expressions are supported.
