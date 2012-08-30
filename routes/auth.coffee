mongoose = require 'mongoose'

exports.subscribe = (req, res) ->
  slug = req.app.get('default subscription')
  Product = mongoose.model 'products'
  Product.findOne slug: slug, (err, subscription) ->
    console.log err if err
    res.render 'subscribe', 
      title: "Pick Your Plan"
      subscription: subscription