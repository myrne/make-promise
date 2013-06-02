require "setimmediate"

module.exports = makePromise = (fn) ->
  state = undefined
  finalState = undefined
  deferreds = []
  
  resultCB = (err, result, forceError=false) ->
    return unless state is undefined
    state = if err or forceError then [false, err] else [true, result]
    resolve returnedPromise, state, (resolvedState) -> 
      finalState = resolvedState
      call deferred, finalState while deferred = deferreds.shift()
  try fn resultCB catch error then resultCB error, null, true
  returnedPromise = then: (whenKept, whenBroken) ->
    if whenKept? and typeof whenKept is "object" and (whenKept.onFulfilled or whenKept.onRejected)
      whenBroken = whenKept.onRejected
      whenKept = whenKept.onFulfilled
    makePromise (cb) -> 
      deferred = {whenKept, whenBroken, cb}
      return deferreds.push deferred if finalState is undefined
      return setImmediate -> call deferred, finalState

resolve = (returnedPromise, [kept, value], cb) ->
  return cb [false, new TypeError "Cannot resolve with returned promise."] if value is returnedPromise
  return cb [false, value] unless kept
  return cb [true, value] if not value
  return cb [true, value] unless typeof value in ["object","function"]
  try thenFn = value.then catch error then return cb [false, error]
  return cb [true, value] unless typeof thenFn is "function"
  resolved = false
  try
    thenFn.call(
      value
      (result) -> 
        return if resolved
        resolved = true
        resolve returnedPromise, [true, result], cb
      (err) -> cb [false, err] unless resolved )
  catch error then cb [false, error] unless resolved

call = (deferred, [kept, value]) ->
  cb = if kept then deferred.whenKept else deferred.whenBroken
  if typeof cb is "function"
    return try deferred.cb null, cb value catch err then deferred.cb err, null, true
  if kept then deferred.cb null, value else deferred.cb value, null, true