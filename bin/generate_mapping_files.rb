require 'csv'
require 'json'

todays_content_directory = "./output/#{Time.now.strftime('%F-%T').delete(':')}"
Dir.mkdir(todays_content_directory)

rows = 0
rows_with_errors = []

CSV.foreach(ARGV[0], headers: true) do |row|
  rows += 1
  if row['nameInBag'] && row['nameInMMS']
    path_to_output_file = "#{todays_content_directory}/#{row['nameInBag']}.json"
    glorious_content = JSON.generate(nameInMMS: row['nameInMMS'])
    File.write(path_to_output_file, glorious_content)
  else
    rows_with_errors << row
  end
end

# Generate report
missing_just_mms_name = rows_with_errors.find_all { |row| row['nameInMMS'] && !row['nameInBag'] }
missing_just_bag_name = rows_with_errors.find_all { |row| !row['nameInMMS'] && row['nameInBag'] }
missing_both_names = rows_with_errors.find_all { |row| !row['nameInMMS'] && !row['nameInBag'] }

puts "There were #{rows} rows. (#{rows_with_errors.length} with errors)"
puts " #{missing_just_mms_name.length} with just nameInMMS"
puts " #{missing_both_names.length} blank rows"
puts " #{missing_just_bag_name.length} with just nameInBag"
