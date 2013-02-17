class Movie < ActiveRecord::Base
    #creates a list of all the possible ratings
    def self.ratings_form
        rating_list = Array.new
        self.select("rating").uniq.each {|mov| rating_list.push(mov.rating)}
        rating_list.sort.uniq
    end
end
