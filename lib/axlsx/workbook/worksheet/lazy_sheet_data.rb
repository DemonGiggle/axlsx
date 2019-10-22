module Axlsx

  class LazySheetData < SheetData

    class RowWrapper
      def to_xml_string(data, index, str)
        if @row == nil
          @row = LazyRow.new(*data)
        else
          @row.initialize_data(*data)
        end
        @row.to_xml_string(index, str)
      end
    end


    # Serialize the sheet data
    # @param [String] str the string this objects serializaton will be concacted to.
    # @return [String]
    def to_xml_string(str = '')
      row = RowWrapper.new
      str << '<sheetData>'
      worksheet.row_raw_data.each_with_index do |data, index|
        row.to_xml_string([worksheet, data[:values], data[:options]], index, str)
      end
      str << '</sheetData>'
    end
  end
end
