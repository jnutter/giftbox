mongoose = require 'mongoose'
_ = require 'underscore'
Schema = mongoose.Schema

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

  UserSchema = new Schema
    email:
      type: String
      index: 
        unique: true
      lowercase: true
      required: true
      match: /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    salt: String
    hash: String
    name:
      first:
        type: String
        index: true
      last:
        type: String
        index: true
    billing: PaymentSchema
    shipping: AddressSchema
    subscription:
      active: Boolean
      startedOn: Date
      billOn: Date
      numberOfBillingAttempts: Number
      price: Number
      billEvery: Number
    order_history: []

  UserSchema.plugin require '../modules/timestamp'

  mongoose.model 'users', UserSchema