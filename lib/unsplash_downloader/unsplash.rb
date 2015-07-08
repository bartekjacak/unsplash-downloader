module UnsplashDownloader
  class Unsplash

    attr_accessor :number_of_pages
    attr_accessor :photos_urls

    def initialize(verbose)
      @mechanize = Mechanize.new
      @all_elements = []
      @source = get_source
      @number_of_pages = count_pages
      @verbose = verbose
    end

    def get_source
      @mechanize.get('https://unsplash.com/')
    end

    def count_pages
      @pagination = @source.search('div.pagination')
      @pagination.to_s.match(/(\d+)<\/a> <a class="next_page"/i).captures
    end

    def get_single_page_elements(number)
      @single_page_elements = @mechanize.get("https://unsplash.com/?page=#{number}").search('div.photo')
    end

    def merge_all_elements
      for index in 1..@number_of_pages[0].to_i + 1 do
        print "Merging pages: #{index - 1} of #{@number_of_pages[0]}" if @verbose
        get_single_page_elements index
        @single_page_elements.each do |element|
          @all_elements.unshift(element)
        end
        print "\r" if @verbose
      end
      puts "Merging pages: #{@number_of_pages[0]} of #{@number_of_pages[0]}. Done!" if @verbose
      return @all_elements
    end
  end

  class Photos
    attr_accessor :number_of_photos
    attr_accessor :number_of_new_photos

    def initialize(path, verbose)
      @mechanize = Mechanize.new
      @photos_urls = []
      @new_photos = []
      @path = path
      @verbose = verbose
    end

    def get_urls(elements)
      elements.each do |element|
        @photos_urls.push(/https[^\?]*/.match(element.to_s))
      end
      return @photos_urls
    end

    def save_urls
      FileUtils.mkdir_p(File.join(@path, "unsplash")) unless File.directory?(File.join(@path, "unsplash"))
      file = File.open(File.join(@path, "unsplash", "urls.txt"), "wb") do |line|
        @photos_urls.each do |url|
          line.puts url
        end
      end
    end

    def count_all
      @number_of_photos = 0
      @photos_urls.each do |line|
        @number_of_photos += 1
      end
      return @number_of_photos
    end

    def count_all_from_file
      @number_of_photos = 0
      file = File.open(File.join(@path, "unsplash", "urls.txt"))
      file.each do |line|
        @number_of_photos += 1
      end
      return @number_of_photos
    end

    def count_new
      @new_photos = []
      for i in 1..@number_of_photos
        File.exist?(File.join(@path, "unsplash", "#{i}.jpg")) ? next : @new_photos.push(i)
      end
      @number_of_new_photos = @new_photos.length
      return @number_of_new_photos
    end

    def download_all
      file = File.open(File.join(@path, "unsplash", "urls.txt"))
      downloaded_photos = 0
      puts "Downloaded #{downloaded_photos} of #{@number_of_photos}." if @verbose
      file.each_with_index do |line, index|
          @mechanize.get(line).save! File.join(@path, "unsplash", "#{index + 1}.jpg")
          downloaded_photos += 1
          print "Downloaded #{downloaded_photos} of #{@number_of_photos}. #{line}" if @verbose
      end
    end

    def download_new
      file = File.open(File.join(@path, "unsplash", "urls.txt"))
      downloaded_photos = 0
      puts "Downloaded #{downloaded_photos} of #{@number_of_new_photos}." if @verbose
      file.each_with_index do |line, index|
        if @new_photos.include?(index + 1)
          @mechanize.get(line).save File.join(@path, "unsplash", "#{index + 1}.jpg")
          downloaded_photos += 1
          print "Downloaded #{downloaded_photos} of #{@number_of_new_photos}. #{line}" if @verbose
        else
          next
        end
      end
    end
  end
end