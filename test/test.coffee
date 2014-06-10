assert = (condition, message) ->
  throw message || "Assertion failed" unless condition

describe 'Mathematics', ->
  it 'should add numbers', ->
    assert (1 + 1) == 2
