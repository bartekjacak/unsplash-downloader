require "unsplash_downloader/version"
require "unsplash_downloader/unsplash"

require "thor"
require "mechanize"
require "fileutils"

module UnsplashDownloader
  class CLI < Thor

    option :verbose, :type => :boolean
    option :all, :type => :boolean

    desc "download PATH [--all] [--verbose]", "Downloads photos to `PATH/unsplash`"
    long_desc <<-LONGDESC
      `download PATH [--all] [--verbose]` will download photos.
      Photos will be saved in `PATH/unsplash`. Defaultly PATH is current dir path.
      Without -all flag it downloads only new photos that are on Unsplash and aren't in folder.
      If `PATH/unsplash` dir doesn't exist it creates dir and downloads all photos.

      Optionally you can use relative path and there will be created new folder.

      > $ unsplash_downloader download photos-folder

      Use --all flag to force download all photos.
      It will overwrite all previously downloaded photos in this folder!

      > $ unsplash_downloader download photos-folder --all

      Use --verbose flag to show info about work progress.

      > $ unsplash_downloader download photos-folder --verbose
    LONGDESC

    def download(path = Dir.pwd) 
      path = File.join(Dir.pwd, path) if path != Dir.pwd
      verbose = options[:verbose]
      unsplash = Unsplash.new(options[:verbose])
      photos = Photos.new(path, options[:verbose])
      unsplash.get_source
      puts "Getting Unsplash source." if verbose
      unsplash.count_pages
      print "Counting pages.." if verbose
      puts unsplash.number_of_pages if verbose
      photos.get_urls(unsplash.merge_all_elements)
      photos.save_urls
      puts "Saving urls to `#{path}/unsplash/unsplash_urls.txt`.." if verbose
      photos.count_all
      puts "There are #{photos.number_of_photos} photos on Unsplash." if verbose
      if options[:all] 
        puts "Downloading.." if verbose
        photos.download_all
      else 
        number_of_new_photos = photos.count_new
        puts "You don't have #{number_of_new_photos} photos in `#{path}/unsplash` folder." if verbose 
        puts "Downloading.." if verbose
        photos.download_new
      end
      puts 'Done!' if verbose
    end

    desc "get_urls PATH", "Gets photos urls to `urls.txt` file"


    desc "count_new PATH", "Counts new photos in `PATH/unsplash` dir. Defaultly PATH is current dir path."
    def count_new(path = Dir.pwd)
      path = File.join(Dir.pwd, path) if path != Dir.pwd
      if File.exist?(File.join(path, "unsplash", "urls.txt"))      
        photos = Photos.new(path, false)
        photos.count_all_from_file
        puts "You don't have #{photos.count_new} photos in `#{path}/unsplash` folder."
      else
        puts "File `urls.txt` not found. Creating.."
        unsplash = Unsplash.new(false)
        photos = Photos.new(path, false)
        unsplash.get_source
        unsplash.count_pages
        urls = photos.get_urls(unsplash.merge_all_elements)
        photos.save_urls
        photos.count_all
        puts "You don't have #{photos.count_new} photos in `#{path}/unsplash` folder."   
      end
    end

    desc "count_all", "Counts all Unplash photos. "
    def count_all(path = Dir.pwd)
      path = File.join(Dir.pwd, path) if path != Dir.pwd 
      unsplash = Unsplash.new(false)
      photos = Photos.new(path, false)
      puts "Counting.."
      unsplash.get_source
      unsplash.count_pages
      photos.get_urls(unsplash.merge_all_elements)
      puts "There are #{photos.count_all} Unsplash photos."
    end

    desc "get_urls PATH", "Gets urls to `PATH/unsplash/urls.txt`"
    def get_urls(path = Dir.pwd) 
      path = File.join(Dir.pwd, path) if path != Dir.pwd
      unsplash = Unsplash.new(false)
      photos = Photos.new(path, false)
      unsplash.get_source
      unsplash.count_pages
      urls = photos.get_urls(unsplash.merge_all_elements)
      puts urls
    end
  end
end
