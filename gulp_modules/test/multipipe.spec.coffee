{noop} = require 'gulp-util'
multipipe = require '../multipipe'

describe 'multipipe', ->
  single = multipipe([noop()])()
  multi = multipipe([noop(), noop()])()

  it 'should return a writable pipe', ->
    single.should.have.property 'write'
    single.should.have.property 'end'
    multi.should.have.property 'write'
    multi.should.have.property 'end'

  it 'should return a readable pipe', ->
    single.should.have.property 'pipe'
    multi.should.have.property 'pipe'

  it 'should use a single pipe', (done) ->
    arr = []

    stream = single
    .on 'data', (data) ->
      arr.push data
    .on 'end', ->
      arr.should.eql [1,2]
      done()

    stream.write 1
    stream.write 2
    stream.end()

  it 'should merge multiple pipes', (done) ->
    arr = []

    stream = multi
    .on 'data', (data) ->
      arr.push data
    .on 'end', ->
      arr.sort().should.eql [1,1,2,2]
      done()

    stream.write 1
    stream.write 2
    stream.end()

