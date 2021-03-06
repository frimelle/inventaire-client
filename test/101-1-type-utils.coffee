_ = require './utils_builder'

should = require 'should'
expect = require('chai').expect
trycatch = require 'trycatch'


describe 'UTILS', ->
  describe 'TYPEOF', ->
    it "should return the right type", (done)->
      trycatch( ->
        _.typeOf('hello').should.equal 'string'
        _.typeOf(['hello']).should.equal 'array'
        _.typeOf({hel:'lo'}).should.equal 'object'
        _.typeOf(83110).should.equal 'number'
        _.typeOf(null).should.equal 'null'
        _.typeOf().should.equal 'undefined'
        _.typeOf(false).should.equal 'boolean'
        _.typeOf(Number('boudu')).should.equal 'NaN'
        done()
      , done)

  describe 'TYPE', ->
    describe 'STRING', ->
      it "should throw on false string", (done)->
        trycatch( ->
          (-> _.type ['im an array'], 'string').should.throw()
          (-> _.type 1252154125123, 'string').should.throw()
          (-> _.type {whoami: 'im an object'}, 'string').should.throw()
          done()
        , done)

      it "should not throw on true string", (done)->
        trycatch( ->
          (-> _.type 'im am a string', 'string').should.not.throw()
          done()
        , done)


    describe 'NUMBER', ->
      it "should throw on false number", (done)->
        trycatch( ->
          (-> _.type ['im an array'], 'number').should.throw()
          (-> _.type 'im am a string', 'number').should.throw()
          (-> _.type {whoami: 'im an object'}, 'number').should.throw()
          done()
        , done)

      it "should not throw on true number", (done)->
        trycatch( ->
          (-> _.type 1252154125123, 'number').should.not.throw()
          done()
        , done)

    describe 'ARRAY', ->
      it "should throw on false array", (done)->
        trycatch( ->
          (-> _.type 'im am a string', 'array').should.throw()
          (-> _.type 1252154125123, 'array').should.throw()
          (-> _.type {whoami: 'im an object'}, 'array').should.throw()
          done()
        , done)

      it "should not throw on true array", (done)->
        trycatch( ->
          (-> _.type ['im an array'], 'array').should.not.throw()
          done()
        , done)

    describe 'OBJECT', ->
      it "should throw on false object", (done)->
        trycatch( ->
          (-> _.type 'im am a string', 'object').should.throw()
          (-> _.type 1252154125123, 'object').should.throw()
          (-> _.type ['im an array'], 'object').should.throw()
          done()
        , done)

      it "should not throw on true object", (done)->
        trycatch( ->
          (-> _.type({whoami: 'im an object'}, 'object')).should.not.throw()
          done()
        , done)

    describe 'GENERAL', ->
      it "should return the passed object", (done)->
        trycatch( ->
          array = ['im an array']
          _.type(array, 'array').should.equal array
          obj = {'im': 'an array'}
          _.type(obj, 'object').should.equal obj
          done()
        , done)

      it "should accept mutlitple possible types separated by | ", (done)->
        trycatch( ->
          (-> _.type 1252154, 'number|null').should.not.throw()
          (-> _.type null, 'number|null').should.not.throw()
          (-> _.type 'what?', 'number|null').should.throw()
          done()
        , done)

      it "should throw when none of the multi-types is true", (done)->
        trycatch( ->
          (-> _.type 'what?', 'number|null').should.throw()
          (-> _.type {andthen: 'what?'}, 'array|string').should.throw()
          done()
        , done)


  describe 'TYPES', ->
      it "should handle multi arguments type", (done)->
        trycatch( ->
          (-> _.types([{whoami: 'im an object'}], ['object'])).should.not.throw()
          (-> _.types([{whoami: 'im an object'}, 1, 2, 125], ['object', 'number', 'number', 'number'])).should.not.throw()
          done()
        , done)

      it "should handle throw when on argument is of the wrong type", (done)->
        trycatch( ->
          args = [{whoami: 'im an object'}, 1, 2, 125]
          (-> _.types(args, ['object', 'number', 'string', 'number'])).should.throw()
          (-> _.types([{whoami: 'im an object'}, 1, 'hello', 125], ['object', 'array', 'string', 'number'])).should.throw()
          done()
        , done)

      it "should throw when not enought arguments", (done)->
        trycatch( ->
          (-> _.types([{whoami: 'im an object'}, 1], ['object', 'number', 'array'])).should.throw()
          done()
        , done)

      it "should throw when too many arguments", (done)->
        trycatch( ->
          (-> _.types([{whoami: 'im an object'}, [1, [123], 2, 3], 'object', 'number', 'array'])).should.throw()
          done()
        , done)

      it "should not throw when less arguments than types but more or as many as minArgsLength", (done)->
        trycatch( ->
          (-> _.types ['im am a string'], ['string', 'string']).should.throw()
          (-> _.types ['im am a string'], ['string', 'string'], 0).should.not.throw()
          (-> _.types ['im am a string'], ['string', 'string'], 1).should.not.throw()
          (-> _.types ['im am a string'], ['string'], 0).should.not.throw()
          (-> _.types ['im am a string'], ['string'], 1).should.not.throw()
          done()
        , done)

      it "should throw when less arguments than types and not more or as many as minArgsLength", (done)->
        trycatch( ->
          (-> _.types ['im am a string'], ['string', 'string'], 2).should.throw()
          done()
        , done)

      it "accepts a common type for all the args as a string", (done)->
        (-> _.types([1,2,3,41235115], 'numbers...')).should.not.throw()
        (-> _.types([1,2,3,41235115, 'bobby'], 'numbers...')).should.throw()
        done()

      it "only accepts the 's...' interface", (done)->
        (-> _.types([1,2,3,41235115], 'numbers')).should.throw()
        done()

  describe 'ALL', ->
    describe 'areStrings', ->
      it "should be true when all are strings", (done)->
          trycatch( ->
            _.areStrings(['a', 'b', 'c']).should.equal true
            done()
          , done)

      it "should be false when not all are strings", (done)->
          trycatch( ->
            _.areStrings(['a', 'b', 4]).should.equal false
            _.areStrings(['a', {a:12}, 4]).should.equal false
            _.areStrings([[], 'e', 'f']).should.equal false
            done()
          , done)