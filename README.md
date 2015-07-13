# unsplash-downloader

Unsplash-downloader downloads all featured photos from https://unsplash.com. First time it will download all photos to `unsplash` dir, and then if there will be new photos on Unsplash and you use download command it will download only new photos to `unsplash` dir.

## Installation

Install this gem by executing:

    $ gem install unsplash_downloader

## Usage

####Downloading photos

To download photos go to a dir where you want to save them and execute:

    $ unsplash_downloader download

It will download all photos to `current/dir/unsplash`

If you want, you can save photos to relative path:

    $ unsplash_downloader download PATH
    
Use `--verbose` flag to see download progress in console.
If you use `--all` flag it won't download not only new photos, but all photos with overwritting old.

####Counting photos

To count all Unsplash photos execute:

    $ unsplash_downloader count_all
    
To count new photos on Unsplash that you don't have in your unsplash dir execute:

    $ unsplash_downloader count_new

Optionally enter a relative path to unsplash folder.

####Getting urls

To get photos urls execute:

    $ unsplash_downloader get_urls

It will print urls in a console.

If you want to save urls to file execute:

    $ unsplash_downloader get_urls >> example.txt

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xennon/unsplash_downloader.

## License

```
The MIT License (MIT)

Copyright (c) 2015 Bartłomiej Jacak

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
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

```
