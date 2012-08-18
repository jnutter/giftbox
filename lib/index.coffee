express = require 'express'
basepath = process.cwd()

module.exports = ->
  app = express()

  app.configure ->
    app.set('basepath', basepath)
    app.set 'port', process.env.PORT || 3000
    app.set 'views', basepath + '/views'
    app.set 'view engine', 'ejs'
    app.use express.favicon()
    app.use express.logger 'dev'
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser 'cookie'
    app.use express.session()
    app.use app.router

  app.configure 'development', ->
    app.use express.errorHandler()

module.exports.start = ->
  require('http').createServer(app).listen app.get('port'), -> 
    console.log "Mint server listening on port " + app.get('port')