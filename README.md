# make-promise [![Build Status](https://travis-ci.org/meryn/make-promise.png?branch=master)](https://travis-ci.org/meryn/make-promise) [![Dependency Status](https://david-dm.org/meryn/make-promise.png)](https://david-dm.org/meryn/make-promise)

A function which creates a Promises/A+ promise.

This module passes version 1.3.1 of the [Promises/A+ Compliance Test Suite](https://github.com/promises-aplus/promises-tests) but is *not* an implementation of the spec itself. It simply delegates everything to a proper Promises/A+ implementation. Currently, this is [Promiscuous](https://npmjs.org/package/promiscuous) by [Ruben Verborgh](http://ruben.verborgh.org/).

## Rationale

I noticed that I wanted a simple way to create a promise in multiple projects. I already had written a `makePromise` function for [Faithful](https://github.com/meryn/faithful), but I did not want to introduce a dependency on the whole Faithful library. 

This module effectively serves as a convenient interface which I can write to, and which abstracts away the specific implementation method, so I can choose another one when this seems useful.

## Usage

`make-promise` exports a single function, which takes a function as it sole argument. After you have called `makePromise`, the function you have provided is immediately called afterwards with two paramaters; `resolve` and `reject`. Calling `resolve` at some point will cause the promise to be fulfilled, calling `reject` at some point will cause the promise to fail.

## Code example

```javascript
var skyIsFalling
makePromise = require("make-promise")
makePromise(function(resolve,reject) {
  setImmediate function() {
    if skyIsfalling
      reject(new Error("Sky is falling."))
    else
      resolve()
  }
})
```

## Credits

Absolutely everything is done by [Promiscuous](https://npmjs.org/package/promiscuous), a Promises/A+ implementation created by [Ruben Verborgh](http://ruben.verborgh.org/).

The idea for the specific API is not mine either. It mimics the API of the (upcoming) RSVP 2.0. The only difference is that RSVP uses `new RSVP.Promise` and in mine its just `makePromise`.

## License

make-promise is released under the [MIT License](http://opensource.org/licenses/MIT).  
Copyright (c) 2013 Meryn Stol  