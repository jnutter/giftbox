mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

module.exports = (db) ->

  SubscriptionSchema = new Schema
    renewEvery:
      type: String
      enum: ['month', '3 months', '6 months', '12 months']
    shipEvery:
      type: String
      enum: ['month', '3 months', '6 months', '12 months']
    price: Number

  ProductSchema = new Schema
      name: String
      vendor: String
      enabled:
        type: Boolean
        default: true
      visible:
        type: Boolean
        default: true
      slug:
        type: String
        index: 
          unique: true
      pricing:
        price: Number
        subscriptionTiers: [SubscriptionSchema]
        sale:
          startAt: Date
          endAt: Date
          price: Number
      type:
        type: String
        enum: ['subscription','simple', 'configurable', 'grouped']
      stock:
        quantity: Number
        status:
          type: String
          enum: ['sold out','almost sold out', 'in stock']

  ProductSchema.plugin require '../modules/timestamp'

  mongoose.model 'products', ProductSchema
