---
title: Knot.x 1.5.0 released!
description: We have just released a minor release Knot.x 1.5.0.
author: skejven
keywords: release
order: 1
date: 2018-12-19
knotxVersions:
    - 1.5.0
---
# Knot.x 1.5.0

## Release Notes

### [knotx-core](https://github.com/Cognifide/knotx)
 - [PR-468](https://github.com/Cognifide/knotx/pull/468) - Fragment processing failure handling (configurable fallback)
 - [PR-465](https://github.com/Cognifide/knotx/pull/465) - Action Knot functionality moved to [Knot.x Forms](https://github.com/Knotx/knotx-forms).
 - [PR-467](https://github.com/Cognifide/knotx/pull/467) - fixed typo in logger format (URI already contains leading slash)
 - [PR-473](https://github.com/Cognifide/knotx/pull/473) - mark Handlebars Knot as deprecated on behalf of [Knot.x Template Engine](https://github.com/Knotx/knotx-template-engine).

### [knotx-dependencies](https://github.com/Knotx/knotx-dependencies)
- [PR-16](https://github.com/Knotx/knotx-dependencies/pull/16) - Removed `knotx-adapter-common` dependency
- [PR-15](https://github.com/Knotx/knotx-dependencies/pull/15) - Configure Knot.x Template Engine in BOM file
- [PR-12](https://github.com/Knotx/knotx-dependencies/pull/12) - Configure Knot.x Forms in BOM file

### [knotx-junit5](https://github.com/Knotx/knotx-junit5)
- [PR-5](https://github.com/Knotx/knotx-junit5) - Html Markup Assertion to test html body content

### [knotx-forms](https://github.com/Knotx/knotx-forms)
First release of the Knot.x Forms module that replaces 
[Knot.x Action Knot](https://github.com/Cognifide/knotx/wiki/ActionKnot)
(which is now deprecated and will be removed soon).
Read more in the *Upgrade notes* section.

### [knotx-data-bridge](https://github.com/Knotx/knotx-data-bridge)
- [PR-37](https://github.com/Knotx/knotx-data-bridge/pull/37) - implementation of [fallback handling](https://github.com/Cognifide/knotx/issues/466) in data bridge

### [knotx-template-engine](https://github.com/Knotx/knotx-template-engine)
First release of the Knot.x Template Engine module that replaces 
[Knot.x Handlebars Knot](https://github.com/Cognifide/knotx/wiki/HandlebarsKnot)
(which is now deprecated and will be removed soon).
Read more in the *Upgrade notes* section.

### [knotx-stack](https://github.com/Knotx/knotx-stack)
- [PR-36](https://github.com/Knotx/knotx-stack/pull/36) - Cleanup integration tests
- [PR-32](https://github.com/Knotx/knotx-stack/pull/32) - Extract assembler and splitter EB addresses to globals.
- [PR-33](https://github.com/Knotx/knotx-stack/pull/33) - Knot.x Template Engine introduced instead of HBS Knot
- [PR-35](https://github.com/Knotx/knotx-stack/pull/35) - implementation of [fallback handling](https://github.com/Cognifide/knotx/issues/466) - integration tests

### [knotx-example-project](https://github.com/Knotx/knotx-example-project)
- [PR-33](https://github.com/Knotx/knotx-example-project/pull/33) - Update cluster to use template engine, replace mocks with simple httpd-based images
- [PR-32](https://github.com/Knotx/knotx-example-project/pull/32) - Switched examples from `handlebars knot` to `knotx template engine`, example TE strategy implementation
- [PR-25](https://github.com/Knotx/knotx-example-project/pull/25) - Fixed multiple-forms example. Updated Forms Knot attributes.
- [PR-20](https://github.com/Knotx/knotx-example-project/pull/20) - Change `acme-action-adapter-http` to use [`knotx-forms`](https://github.com/Knotx/knotx-forms)
- [PR-35](https://github.com/Knotx/knotx-example-project/pull/35) - implementation of [fallback handling](https://github.com/Cognifide/knotx/issues/466) in example project

## Upgrade notes
### Migration form Action Knot to Knot.x Forms
Knot.x (<= 1.4.0) used earlier Action Knot. Please follow step below in order to migrate your project from `ActionKnot` to `Knotx Forms` module.


#### Configuration file:
1. In your main config `application.conf`, update `modules` section from:
  ```
    "actionKnot=io.knotx.knot.action.ActionKnotVerticle"
    "actionAdapter=com.acme.adapter.action.http.HttpActionAdapterVerticle"
  ```
  to 
  ```
    "forms=io.knotx.forms.core.FormsKnot"
    "formsAdapter=com.acme.forms.adapter.http.FormsAdapterVerticle"
  ``` 
  
  and define forms in the `global` section
  ```
  global {
    address {
      forms {
        knot = knotx.knot.forms
        example.adapter = knotx.forms.example.adapter.http
      }
    }
  }
  ```

  Change included configuration name `actionKnot.conf` to `forms.conf`

#### Page templates:

  - Rename data attributes accordingly
    
  | Old                        | New                              | 
  | -------------------------- |:--------------------------------:|
  | data-knotx-on-             |data-knotx-forms-on-              |
  | data-knotx-action          |data-knotx-forms-adapter-name     |
  | data-knotx-adapter-params  |data-knotx-forms-adapter-params   |   
 
  - In form snippet change `action` to `form`. 

  For example:

  Old
  ```html
  <script data-knotx-knots="form-1" type="text/knotx-snippet">
    {{#if action._result.validationErrors}}
    <p class="bg-danger">Email address does not exists</p>
    {{/if}}
    <p>Please provide your email address</p>
    <form data-knotx-action="step1"
    data-knotx-on-success="/content/local/login/step2.html"
     data-knotx-on-error="_self"
      data-knotx-adapter-params='{"myKey":"myValue"}' method="post">
      <input type="email" name="email" value="{{#if action._result.validationError}} {{action._result.form.email}} {{/if}}" />
      <input type="submit" value="Submit"/>
    </form>
  </script>
  ```
  
  New
  ```html
  <script data-knotx-knots="form-1" type="text/knotx-snippet">
    {{#if form._result.validationErrors}}
    <p class="bg-danger">Email address does not exists</p>
    {{/if}}
    <p>Please provide your email address</p>
    <form data-knotx-forms-adapter-name ="step1"
      data-knotx-forms-on-success="/content/local/login/step2.html" 
      data-knotx-forms-on-error="_self" 
      data-knotx-forms-adapter-params='{"myKey":"myValue"}' method="post">
      <input type="email" name="email" value="{{#if form._result.validationError}} {{form._result.form.email}} {{/if}}" />
      <input type="submit" value="Submit"/>
    </form>
  </script>
```

#### Custom adapter
Refactor your custom adapter to inherit [`io.knotx.proxy.AdapterProxy`](https://github.com/Cognifide/knotx/blob/1.3.0/knotx-core/src/main/java/io/knotx/proxy/AdapterProxy.java)
to [`io.knotx.forms.api.FormsAdapterProxy`](https://github.com/Knotx/knotx-forms/blob/master/api/src/main/java/io/knotx/forms/api/FormsAdapterProxy.java)

### Migration form Handlebars Knot to Knot.x Template Engine
Knot.x (<= 1.5.0) used `HandlebarsKnot`. Please follow step below in order 
to migrate your project from `HandlebarsKnot` to `Template Engine` module.

Handlebars is still the default Template Engine strategy in Knot.x. Thanks to moving into Template Engine module you may now easily
create and configure your own Template Engine strategy and choose some snippets to be rendered by it.
See the [example project](https://github.com/Knotx/knotx-example-project) for more details.

> Notice! You may still use old Handlebars Knot with Knot.x 1.5 if you want.
> However, remember that it is marked as @Deprecated and will be removed in the next major version.

#### Configuration file:
1. In your main config `application.conf`, update `modules` section from:
  ```
    "hbsKnot=io.knotx.knot.templating.HandlebarsKnotVerticle"
  ```
  to 
  ```
    "templateEngine=io.knotx.te.core.TemplateEngineKnot"
  ``` 
  
2. Define module address in the `global` section
  ```
  global {
    ...
    templateEngine.address = knotx.knot.te
  }
  ```
3. Replace all occurenes of the Handlebars Knot address in the Server routing `defaultFlow` from `${global.hbs.address}` to `${global.templateEngine.address}`.

3. Instead including `hbsKnot.conf` change include to `templateEngine.conf`. You will find examples configuration files in 
the [knotx-stack distribution](https://github.com/Knotx/knotx-stack/blob/master/knotx-stack-manager/src/main/packaging/conf/includes).

#### Page templates:

1. Update `data-knotx-knots` values from `handlebars` to `te`.

2. Example helpers: `string_equals` and `encode_uri` that were embedded into Handlebars Knot are no longer available in the Template Engine.
You may introduce them by defining handlebars extension as it is presented in the [example project](https://github.com/Knotx/knotx-example-project/tree/master/acme-handlebars-ext).
