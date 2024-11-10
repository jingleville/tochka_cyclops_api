# frozen_string_literal: true

require 'dry/schema'

Undefined = Dry::Schema::Undefined

module Types
  include Dry.Types()
end

class DocCompiler
  def visit(node)
    meth, rest = node
    public_send(:"visit_#{meth}", rest)
  end

  def visit_set(nodes)
    nodes.map { |node| visit(node) }.flatten(1)
  end

  def visit_and(node)
    left, right = node
    [visit(left), visit(right)].compact
  end

  def visit_key(node)
    name, rest = node

    predicates = visit(rest).flatten

    if predicates[0].is_a? Symbol
      validations = predicate_description(predicates[0], predicates[1])

      { key: name, validations: validations }
    else
      { key: name, validations: predicates }
    end
  end

  def visit_implication(node)
    _, right = node.map(&method(:visit))
    right.merge(optional: true)
  end

  def visit_predicate(node)
    name, args = node

    return if name.equal?(:key?)

    { name => args.map(&:last).reject { |v| v.equal?(Dry::Schema::Undefined) } }
  end

  def predicate_description(name, args)
    case name
    when :str? then "string"
    when :bool? then "true/false"
    when :filled? then "filled"
    when :int? then "integer"
    when :gt? then "greater than #{args[0]}"
    else
      raise NotImplementedError, "#{name} not supported yet"
    end
  end
end

module TochkaCyclopsApi
  class Methods
    METHODS = %w[
      echo
      create_beneficiary_ul
      create_beneficiary_ip
      create_beneficiary_fl
      update_beneficiary_ul
      update_beneficiary_ip
      update_beneficiary_fl
      get_beneficiary
      list_beneficiary
      activate_beneficiary
      deactivate_beneficiary
    ]

    DIVIDER = ["\n", "="*80, "\n"]

    def self.get_method(method)
      return unless method_exists? method

      require_relative "schemas/requests/#{method}"

      @method = method

      define_schema_class
      define_schema_ast
      parse_schema_ast
      @formatted_schema_ast = format_schema_ast
      show_schema

      puts @method.split('_').map(&:capitalize).join
      puts @formatted_schema_ast
      puts DIVIDER
      puts ['EXAMPLE', "\n"]
      puts @schema_class.const_get('EXAMPLE')
    end

    private

    def self.method_exists?(method)
      return true if method.in? METHODS

      puts "Method #{method} is not found"
      false
    end

    def self.define_schema_class
      @schema_class = [
        "TochkaCyclopsApi",
        "Schemas",
        "Requests",
        camel_case(@method)].join('::').constantize
    end

    def self.define_schema_ast
      @schema_ast = @schema_class.new.schema.ast
    end

    def self.parse_schema_ast
      compiler = DocCompiler.new

      @schema_ast = compiler.visit(@schema_ast).map do |row|
        key = row[:key]
        validations = row[:validations]
        optional = row[:optional] ? 'optional' : 'mandatory'

        if validations.is_a? Array
          validations = validations.map do |validation|
            v_key = validation[:key]
            v_validations = validation[:validations]
            v_optional = validation[:optional] ? 'optional' : 'mandatory'

            [v_key, v_optional, v_validations]
          end
        end
        [key, optional, validations]
      end
    end

    def self.column_sizes(array)
      sizes = []
      3.times do |index|
        size = array.map do |row|
          next if row[index].is_a? Array

          row[index].to_s.length
        end
        sizes << size.compact.max
      end
      sizes
    end

    def self.format_schema_ast(array = @schema_ast)
      sizes = column_sizes(array)
      array.map do |sub_array|
        sub_array.each_with_index.map { |row, index| format_row(row, sizes[index]) }
      end
    end

    def self.format_row(row, indent)
      if row.is_a? Array
        format_schema_ast(row)
      else
        row.to_s.ljust(indent)
      end
    end

    def self.show_schema
      @formatted_schema_ast.map! do |row|
        array = row.select { |element| element.is_a? Array }.last
        if array.present?
          max_first_element_size = array.map { |row| row[0].strip.to_s.length }.max

          # 9 is size of 2 dividers (" | ") and 1 brace
          row_indent = row[0].size + row[1].size + 7

          # 2 is 2 spaces indent
          array.map! do |row|
            row[0] = row[0].rjust(row_indent + max_first_element_size + 2)
            row.join(' | ')
          end

          array = ["{"] + array + ["}".rjust(row_indent)]

          row[-1] = array.join("\n")
        end
        row.join(' | ')
      end
    end


    def self.camel_case(string)
      string.split('_').map(&:capitalize).join
    end
  end
end
