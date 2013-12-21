exports.config =
    paths:
        public: 'build'
        jadeCompileTrigger: '.compile-jade'
    modules:
      definition: false
      wrapper: false
    files:
        javascripts:
            joinTo:
                "js/vendor.js": /^bower_components/
                "js/dj.js": /^app\/dj/
                "js/listener.js": /^app\/listener/
                "js/admin.js": /^app\/admin/
                "js/utilities.js": /^app\/utilities/
        stylesheets:
            joinTo:
                "css/vendor.css": /^bower_components/
                "css/dj.css": /^app\/dj/
                "css/listener.css": /^app\/listener/
                "css/admin.css": /^app\/admin/
                "css/utilities.css": /^app\/utilities/
        templates:
            joinTo: 
              '.compile-jade': /^app/
    plugins:
        jade:
            pretty: yes