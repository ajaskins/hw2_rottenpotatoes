class Movie < ActiveRecord::Base
    def all_ratings
        array = Array.new
        select("rating").uniq.each {|mov| array.push(mov.rating)}
        array.sort.uniq
    end
end
