require 'csv'
require 'json'

# Some times we get exports with file extensions in the `nameInBag` column.
# That's bad! We'll miss our matches.
# This cleans up the CSV.

todays_content_directory = "./output/#{Time.now.strftime('%F-%T').delete(':')}"
Dir.mkdir(todays_content_directory)

rows = 0

CSV.open("./without_extensions.csv", "wb") do |csv|
  CSV.foreach(ARGV[0], headers: true) do |row|
    if rows == 0
      csv << ['row', 'nameInMMS', 'nameInBag']
      rows += 1
    else
      rows += 1
      csv << [rows-1, row['nameInMMS'], row['nameInBag'].split('.')[0]]
    end
  end
end
