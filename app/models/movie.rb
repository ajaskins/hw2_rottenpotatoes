class Movie < ActiveRecord::Base
    def self.all_ratings
        array = Array.new
        self.select("rating").uniq.each {|mov| array.push(mov.rating)}
        array.sort.uniq
    end
end
