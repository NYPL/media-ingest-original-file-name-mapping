require 'csv'
require 'json'

todays_content_directory = "./output/#{Time.now.strftime("%F-%T").gsub(":", "")}"
Dir.mkdir(todays_content_directory)

CSV.foreach(ARGV[0], headers: true) do |row|
  path_to_output_file = "#{todays_content_directory}/#{row['nameInBag']}.json"
  glorious_content = JSON.generate(nameInMMS: row['nameInMMS'])
  File.write(path_to_output_file, glorious_content)
end
