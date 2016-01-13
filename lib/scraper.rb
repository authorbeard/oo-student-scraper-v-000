require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  # attr_accessor :name, :location, :profile_url

  def self.scrape_index_page(index_url)
    Nokogiri::HTML(open(index_url)).css(".student-card").collect {|c|
        { 
        name: c.css("h4").text,
        location: c.css(".student-location").text,
        profile_url: "http://students.learn.co/#{c.css("a").attribute("href").value}"
        }}
  end

  def self.scrape_profile_page(profile_url)
  # binding.pry
    profile = Nokogiri::HTML(open(profile_url)).css(".profile > div:not(:empty)")
# binding.pry    
    social_details = profile.css(".social-icon-container a").collect{|s|
      s.attribute("href").value}.flatten
    social_hash = 
      {
        twitter: social_details.detect{|d| d.include?("twitter")},
        linkedin: social_details.detect{|d| d.include?("linkedin")},
        github: social_details.detect{|d| d.include?("github")},
        blog: social_details.last,
        profile_quote: profile.css(".profile_quote").text,
        bio: profile.css(".description-holder p").text
      }
     

# binding.pry
  end

end


=begin
  to scrape: 
  1) first collect all ".student_card" elements
    --this takes the url, opens with open-uri
    --gives this to Nokogiri to parse
    --then calls css method on that, handing (".student_card")
    --that should give me something to iterate on 
    --create empty array to shovel attributes into
  2) then iterate, using css method to pull out name/location
    --so something like doc.each{|card| card}
    -- should look like: whatever: card.css(".whatever").text 
    -- should be two of these per student, each shoveled into a hash

  3) Mmake sure the hash in step 2 is shoveled into the array from step 1

 students_array = []
 student_hash = {}
 students = Nokogiri::HTML(open(index_url)).css(".student-card")
 students.each{|student|
    name: student.css("h4 .student-name").text
    location: student.css("p .student-location").text
    students_array << {:name, :location}
   }


=end