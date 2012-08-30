express = require 'express'
view = require './view'
path = require 'path'
stylus = require 'stylus'
bootstrap = require 'bootstrap-stylus'
basepath = process.cwd()
mongoose = require 'mongoose'
Model = require './model'


module.exports = express

compile = (str, path) ->
  stylus(str)
    .set('filename', path)
    .set('compress', true)
    .set('firebug', true)
    .set('linenos', true)
    .use(bootstrap())
    .include(__dirname+'/../public/stylesheets')

module.exports.setup = ->
  app = express()

  require('./view').setup(app)

  app.configure ->
    app.set 'basepath', basepath
    app.set 'port', process.env.PORT || 3000
    app.set 'base views', __dirname+'/../views'
    app.set 'views', basepath+'/views'
    app.use stylus.middleware
      src: basepath + '/public'
      serve: false
      compile: compile
    app.use express.static(path.join(basepath, 'public'))
    app.set 'view engine', 'jade'
    app.set 'view options',
      pretty: true
    app.locals.accounting = require 'accounting'
    app.use express.favicon()
    app.use express.logger 'dev'
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser 'cookie'
    app.use express.session()
    app.use app.router

  app.configure 'development', ->
    app.use express.errorHandler()

  auth = require '../routes/auth'
  app.get '/subscribe', auth.subscribe

  app.start = ->
    require('http').createServer(app).listen app.get('port'), -> 
      console.log app.get('site')+ " server listening on port " + app.get('port')

    db = new Model app.get 'db'
    db.loadModuleDirectory __dirname+'/../models'

    # Stripe CC Processor
    console.log app.get 'stripe api key'
    stripe = require 'stripe'
    stripe = stripe app.get 'stripe api key'
    ###
    Product = mongoose.model 'products'
    product = new Product
      name: 'Neet Box'
      vendor: 'Neet'
      slug: 'box'
      pricing:
        price: 39.99
        subscriptionTiers: [
          {
            renewEvery: 'month'
            shipEvery: 'month'
            price: 39.99
          }
          {
            renewEvery: '3 months'
            shipEvery: 'month'
            price: 110
          }
          {
            renewEvery: '6 months'
            shipEvery: 'month'
            price: 200
          }
        ]
      type: 'subscription'

    product.save (err) ->
      console.log err
    ###
  app