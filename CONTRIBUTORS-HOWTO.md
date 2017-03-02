This page explains how to maintain Contributors shown on Knotx.io/community page.

## Community Contributors

The Community page of knotx.io website contains the section showing core team members as well as all contributors to the project that are willing to be listed over there.

## How to add myself to contributors

Assuming, that core team of Knot.x decided that you contributed enough to the project to be listed on the page, you can request to be added as follows:
- Fork https://github.com/knotx/knotx-website repository in order to create a pull request with your content.
- Create new branch from the `master` branch, e.g. `contrib/my-name`
- Inside `src/team/contributors` folder create an file with `eco` extension.
> The filename must be in the form `githubuserid.html.eco`. For example, you want to add `marcinczeczko` Github user, then filename should be `marcinczeczko.html.eco`
- Content of the file must have metadata only, as follows:

``` md
---
member: githubuserid
name: FirstName LastName
avatar: https://github.com/identicons/jasonlong.png
website: http://your-website
twitter: https://twitter.com/your-twitter
showOnPage: true
---
```
Each line between the `---` lines are the metadata. The **required** metadata fields are:

* **member**: Github User ID
* **name**: First & Last Name of the Contributor
* **avatar**: Link to the avatar, e.g. from Github
* **website**: Link to user website, if no website leave the field *empty*
* **twitter**: Link to the twitter feed of the user, if no twitter leave the field *empty*
* **github**: ***Optional***. If your want to use link to different github account, e.g. organization, you can do this in this property, if not defined an `http://github.com/member` link will be exposed
* **showOnPage**: Leave true. If you don't want to be listed on Community page, then set to false

### Making a Pull Request
Once you finish writing your Contributor entry:
- create a pull request and we will review/publish on the site.
- the pull request should only contain the file related to your entry.
