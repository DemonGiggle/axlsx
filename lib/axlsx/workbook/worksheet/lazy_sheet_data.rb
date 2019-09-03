module Axlsx

  class LazySheetData < SheetData

    # Serialize the sheet data
    # @param [String] str the string this objects serializaton will be concacted to.
    # @return [String]
    def to_xml_string(str = '')
      str << '<sheetData>'
      worksheet.row_raw_data.each_with_index do |data, index|
        row = LazyRow.new(worksheet, data[:values], data[:options])
        row.to_xml_string(index, str)
      end
      str << '</sheetData>'
    end
  end
end
