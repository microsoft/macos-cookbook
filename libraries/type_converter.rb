module TypeConversion
  class Converter
    def self.to_string_from_native(value)
      "#{data_type_cases[value.class]} #{value}"
    end

    def self.to_native_from_string(type, value)
      defaults_read_types_table = { boolean: value.to_i == 1,
                                    integer: value.to_i,
                                    float: value.to_f,
                                    string: value }
      defaults_read_types_table[type.to_sym]
    end

    def self.data_type_cases
      { Array => 'array',
        Integer => 'int',
        TrueClass => 'bool',
        FalseClass => 'bool',
        Hash => 'dict',
        String => 'string',
        Float => 'float' }
    end
  end
end
