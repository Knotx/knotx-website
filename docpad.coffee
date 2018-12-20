# DocPad Configuration File
# http://docpad.org/docs/config

# Import
moment = require('moment')
moment.locale('en_gb')

md5 = require('md5')

# Define the DocPad Configuration
docpadConfig = {
    port: 3010
    documentsPaths: [
      'render'
      'documents'
      'team'
    ]
    plugins:
        cleanurls:
          trailingSlashes: true
          static: true
        ghpages:
          deployRemote: 'gh'
          deployBranch: 'master'
          outPath: '.'
        highlightjs:
          aliases:
            hocon: 'ruby'

    environments:
      gh:
        templateData:
          deployAnalytics: true

    templateData:
        deployAnalytics: false
        site:
            url: "http://knotx.io"
            name: "Knot.x Website"
            title: "Knot.x Website"
            description: """
                Knot.x Website
                """
            keywords: """
                knotx, vertx, reactive, asynchronous, templating, java, polyglot, cms
                """
            image: "/img/logo-240x240.png"
            analyticsId: "UA-92165781-1"

        
        getTutorialsVersions: (version) ->
          obj = @getCollection('html')
            .findAll({relativeOutDirPath:  /tutorials(\/|\\).*/, keywords: "tutorial"},[{order: -1}])
            .toJSON().reduce((acc, val) => 
              versionsUrls = val.knotxVersions.map((v) -> {version: v, url: val.url})
              
              if acc[val.relativeDirPath]
                acc[val.relativeDirPath] = acc[val.relativeDirPath].concat(versionsUrls)
              else 
                acc[val.relativeDirPath] = versionsUrls
              
              return acc
            ,{})
          return obj[version].sort (a, b) ->
            return -1 if (a.version == "edge")
            return a.version > b.version

        isEdge: (knotxVersions) -> knotxVersions && knotxVersions.includes("edge")

        getPreparedTitle: ->
          if @document.title
            if @document.addToTitle
              "#{@document.title} - #{@document.addToTitle}"
            else "#{@document.title}"
          else @site.title

        getPreparedOgImage: ->
          if @document.image
            "#{@site.url}#{@document.image}"
          else
            "#{@site.url}#{@site.image}"

        getPreparedUrl: -> @site.url + @document.url
        getPreparedDescription: -> @document.description or @site.description
        getPreparedKeywords: -> @site.keywords.concat(@document.keywords or []).join(', ')
        getBackground: -> if @document.home then "class='colored-background'" else ""

        getPostIdentifier: -> md5("knotx.io+blog+#{@document.basename}")

    		# Post meta
        formatDate: (date,format='MMMM Do, YYYY') -> return moment(date).format(format)
        formatDt: (date,format='YYYY-MM-DD') -> return moment(date).format(format)

        getMember: (userId) ->
          if @getCollection('commiters').findOne({member:userId})
            @getCollection('commiters').findOne({member:userId}).toJSON()
          else
            @getCollection('contributors').findOne({member:userId}).toJSON()

        getMemberGithub: (member) ->
          member.github or "https://github.com/#{member.member}"

        getGithubReleaseTag: (version) ->
          if /^\d+\.\d+\.\d+$/.test(version)
            "https://github.com/Cognifide/knotx/releases/tag/#{version}"
          else "https://github.com/Cognifide/knotx"

        printKnotxVersion: (version) ->
          if version
            "#{version}"
          else ""

        dateToMonthAndYear: (date) -> moment(date).format("MMMM YYYY")

        arrayGroupBy: (array, aggregate) ->
          array.reduce((previous, current, index, context) ->
            group = aggregate(current)
            if previous[group]
              previous[group].push(current)
            else
              previous[group] = [ current ]
            previous
          {})

        postsByMonth: -> arrayGroupBy(posts, (post) -> dateToMonthAndYear(current.date))

        getSectionLink: (section) ->
          @getCollection('html').findOne({basename: section}).toJSON().target or
          @getCollection('html').findOne({basename: section}).toJSON().url

    localeCode: "en"

    collections:
      posts: ->
        @getCollection('html')
          .findAll({relativeOutDirPath: 'blog'},[{date:-1}])
          .on 'add', (model) ->
            model.set({addToTitle: 'Knot.x Blog Post'})
            model.setMetaDefaults({layout: "post"})

      tutorials: ->
        @getCollection('html')
          .findAll({relativeOutPath:  /^tutorials(\/|\\).+?(\/|\\)index\.html$/},[{order: -1}])
          .on 'add', (model) ->
            model.set({addToTitle: 'Knot.x Tutorials'})
            model.setMetaDefaults({layout: "post"})

      commiters: ->
        @getCollection('html').findAll({relativeOutDirPath: 'commiters'})

      contributors: ->
        @getCollection('html').findAll({relativeOutDirPath: 'contributors', showOnPage: true})

      menu: ->
        @getCollection('html').findAll({menu: true},[{order: 1}])
}

# Export the DocPad Configuration
module.exports = docpadConfig
