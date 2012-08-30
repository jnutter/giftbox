view = require 'express/lib/view'
fs = require 'fs'
path = require 'path'
utils = require 'express/lib/utils'
dirname = path.dirname
basename = path.basename
extname = path.extname
exists = fs.existsSync
join = path.join

Parser = require 'jade/lib/parser'
nodes = require 'jade/lib/nodes'

exports.setup = (app) ->

  view.prototype.lookup = (path) ->
    ext = @ext

    return path if utils.isAbsolute path and exists path
    # <path>.<engine>
    parentPath = join(this.root, path)
    return parentPath if exists parentPath

    # <path>/index.<engine>
    parentPath = join dirname(parentPath), basename(parentPath, ext), 'index' + ext
    return parentPath if exists parentPath

    path = join app.get('base views'), path
    return path if exists path

    path = join dirname(path), basename(path, ext), 'index' + ext
    return parentPath if exists path

  Parser.prototype.parseExtends = ->
    throw new Error('the "filename" option is required to extend templates') unless @filename

    filename = this.expect('extends').val.trim()
    dir = app.get('views')

    currentPath = join dir, filename + '.jade'
    if exists currentPath
      str = fs.readFileSync currentPath, 'utf8'
    else
      currentPath = join __dirname+'/../views', filename + '.jade'
      str = fs.readFileSync currentPath, 'utf8'
    parser = new Parser str, filename, this.options

    parser.blocks = this.blocks
    parser.contexts = this.contexts
    this.extending = parser

    # TODO: null node
    new nodes.Literal ''

  Parser.prototype.parseInclude = ->

    filename = this.expect('include').val.trim()
    dir = app.get('views')

    if !this.filename
      throw new Error 'the "filename" option is required to use includes';

    # no extension
    if !~basename(filename).indexOf('.')
      filename += '.jade'

    # non-jade
    if '.jade' != filename.substr -5
      filename = join dir, filename
      str = fs.readFileSync filename, 'utf8'
      return new nodes.Literal str

    currentPath = join dir, filename
    if exists currentPath
      str = fs.readFileSync currentPath, 'utf8'
    else
      currentPath = join __dirname+'/../views', filename
      str = fs.readFileSync currentPath, 'utf8'
    parser = new Parser str, currentPath, this.options

    parser.blocks = @blocks
    parser.mixins = @mixins

    this.context parser
    ast = parser.parse()
    this.context()
    ast.filename = path

    ast.includeBlock().push(@block()) if 'indent' == @peek().type

    return ast
