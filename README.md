# Anonypaste

A [pastebin](http://en.wikipedia.org/wiki/Pastebin) web application that automatically deletes submissions after a short amount of time.

Anonypaste is written in Ruby using the [Sinatra](http://www.sinatrarb.com) framework.

It depends on [pygments](pygments.org) for syntax highlighting and [redis](redis.io) for semi-permanent storage.

The official anonypaste application can be found at [anonypaste.com](http://www.anonypaste.com).

## Todo

Lots of things. For one, I used a modified version of the [pygmentize](https://github.com/tuxedo25/pygmentize) gem. My modifications overlap the better-maintained [pygments.rb](https://github.com/tmm1/pygments.rb), which should probably be used instead.

## License

The MIT License (MIT)

Copyright (c) Foster Hersey, 2011-2013

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE 
USE OR OTHER DEALINGS IN THE SOFTWARE.
