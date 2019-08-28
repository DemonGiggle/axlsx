# encoding: UTF-8
require 'singleton'

module Axlsx
  class LazyRow
    include SerializedAttributes
    include Accessors

    ####
    # mimic Array
    # :: but we store nothing
    SimpleTypedList::DELEGATES.each do |method|
      class_eval %{
        def #{method}(*args, &block)
          [].send(:#{method}, *args, &block)
        end
      }
    end

    class CellWrapper
      include Singleton

      def data(row, value = nil, options = {})
        # each time we create a new one
        @cell = Cell.new(row, value, options)
      end

      def to_xml_string(r_index, c_index, str = '')
        @cell.to_xml_string(r_index, c_index, str)
      end
    end

    # A list of serializable attributes.
    serializable_attributes []

    def initialize(worksheet, values=[], options={})
      @worksheet = worksheet
      @values = values
      @options = options
      @worksheet.rows << self
    end

    # Serializes the row
    # @param [Integer] r_index The row index, 0 based.
    # @param [String] str The string this rows xml will be appended to.
    # @return [String]
    def to_xml_string(r_index, str = '')
      DataTypeValidator.validate :array_to_cells, Array, @values
      types, style, formula_values = @options.delete(:types), @options.delete(:style), @options.delete(:formula_values)

      serialized_tag('row', str, :r => r_index + 1) do
        tmp = '' # time / memory tradeoff, lots of calls to rubyzip costs more
                 # time..
        @values.each_with_index do |value, c_index|
          @options[:style] = style.is_a?(Array) ? style[index] : style if style
          @options[:type] = types.is_a?(Array) ? types[index] : types if types
          @options[:formula_value] = formula_values[index] if formula_values.is_a?(Array)

          cell = CellWrapper.instance
          cell.data(self, value, @options)

          cell.to_xml_string(r_index, c_index, tmp)
        end
        str << tmp
      end
    end
  end
end
