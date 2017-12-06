require 'rexml/document'
require 'csv'

doc = REXML::Document.new(open('S12-16.xml'))

CSV.open('S12-16.csv', 'w') do |row|

  doc.elements.each('ksj:Dataset/ksj:TheNumberofTheStationPassengersGettingonandoff') do |element|
    # データを必要最低限に落として、CSVフォーマットに変換
    # ksj:stationName
    # ksj:administrationCompany
    # ksj:routeName
    # ksj:passengers2015

    row << [ element.elements['ksj:stationName'].text, element.elements['ksj:administrationCompany'].text, element.elements['ksj:routeName'].text, element.elements['ksj:passengers2015'].text ]
  end
end
