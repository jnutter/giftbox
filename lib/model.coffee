fs = require 'fs'
{join, basename, extname} = require 'path'
mongoose = require 'mongoose'

exports = module.exports = (dbString) -> 
  db = mongoose.connect dbString

  db.loadModuleDirectory = (dir) ->
    for file in fs.readdirSync dir
      mod = require join dir, file
      mod db
  db