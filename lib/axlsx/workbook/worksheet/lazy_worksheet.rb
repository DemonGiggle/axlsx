# encoding: UTF-8
module Axlsx

  # The Worksheet class represents a worksheet in the workbook.
  class LazyWorksheet < Worksheet

    serializable_attributes :sheet_id, :state

    def add_row(values=[], options={})
      row_raw_data << {values: values, options: options}
    end

    def sheet_data
      @sheet_data ||= LazySheetData.new self
    end

    def row_raw_data
      @row_raw_data ||= []
    end
  end
end
