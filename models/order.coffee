mongoose = require 'mongoose'
_ = require 'underscore'
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

module.exports = (db) ->

  AddressSchema =
    name: 
      first: String
      last: String
    street1: String
    street2: String
    city: String
    state: String
    zipcode: String
    country: String

  PaymentSchema = _.extend {last4: String, cardType: String, experation: Date}, AddressSchema

  ShipmentSchema = new Schema
    items: [ObjectId]
    shippedOn: Date
    trackingNumber: String
    carrier: String
    method: String

  ItemSchema = new Schema
    name: String
    type: String
    product: 
      type: ObjectId
      ref: 'products'
    itemPrice: Number
    itemTax: Number
    itemsOrdered: Number
    itemsShipped: Number
    itemsReturned: Number
    contains: [] # if box, we want to say whats in it

  OrderSchema = new Schema
    user: 
      type: ObjectId
      ref: 'users'
    billing: PaymentSchema
    shipping: AddressSchema
    placedOn: Date
    fulfilledOn: Date
    status:
      type: String
      enum: ['processing','completed', 'canceled', 'voided', 'returned']
    items: [ItemSchema]
    shipments: [ShipmentSchema]
    totals:
      subtotal: Number
      discount: Number
      tax: Number
      shipping: Number
      grandTotal: Number
    ip: String
    comments: [{date: Date, by: String, body: String}]

  OrderSchema.plugin require '../modules/timestamp'

  mongoose.model 'orders', OrderSchema