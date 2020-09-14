# frozen_string_literal: true

class CompareSimilarity
  require 'json'

  def initialize(master_file_path, comparison_file_path)
    @master_file_path = master_file_path
    @comparison_file_path = comparison_file_path

    @master_json_keys = []
    @comparison_json_keys = []
    @equal_keys_and_values = []
  end

  EVALUATIVE_CRITERIA = {
    same_number_keys: 0.2,
    same_name_keys: 0.3,
    similarity_values: 0.5
  }.freeze

  def call
    compare_json(parse_file(@master_file_path), parse_file(@comparison_file_path))

    calculate_equality
  end

  private

  def calculate_equality
    @master_json_keys.flatten!
    @comparison_json_keys.flatten!

    @hash_base = @master_json_keys.length < @comparison_json_keys.length ? @comparison_json_keys : @master_json_keys

    same_number_of_keys_in_json_object
    same_name_keys_in_json_object
    similarity_of_key_values
  end

  def same_number_of_keys_in_json_object
    hash_aux = @master_json_keys.length < @comparison_json_keys.length ? @master_json_keys : @comparison_json_keys
    value_per_key = EVALUATIVE_CRITERIA[:same_number_keys] / @hash_base.length
    decrease = value_per_key * (@hash_base.length - hash_aux.length)

    @score = EVALUATIVE_CRITERIA[:same_number_keys] - decrease
  end

  def same_name_keys_in_json_object
    value_per_key = EVALUATIVE_CRITERIA[:same_name_keys] / @hash_base.length
    decrease = value_per_key * ((@master_json_keys - @comparison_json_keys) | (@comparison_json_keys - @master_json_keys)).length
    @score += EVALUATIVE_CRITERIA[:same_name_keys] - decrease
  end

  def similarity_of_key_values
    key_value = EVALUATIVE_CRITERIA[:similarity_values] / @hash_base.count
    @score += key_value * @equal_keys_and_values.count
  end

  def compare_json(master_json, comparison_json)
    if master_json.is_a?(Array)
      iterate_array(master_json, comparison_json)
    elsif master_json.is_a?(Hash)
      iterate_hash(master_json, comparison_json)
    end
  end

  def iterate_hash(master_json, comparison_json)
    @master_json_keys << master_json.keys if master_json.is_a?(Hash)
    @comparison_json_keys << comparison_json.keys if comparison_json.is_a?(Hash)

    master_json.each do |key, value|
      next unless comparison_json&.key?(key)

      @equal_keys_and_values << key if comparison_json[key] == value
      compare_json(value, comparison_json[key])
    end
  end

  def iterate_array(master_json, comparison_json)
    master_json.each_with_index do |obj, index|
      compare_json(obj, comparison_json[index])
    end
  end

  def match_validation(master_json, comparison_json)
    (!master_json.is_a?(Hash) && !master_json.is_a?(Array)) && master_json == comparison_json
  end

  def parse_file(file_path)
    file = File.read(file_path)

    raise "The input file: '#{file_path}' must be a json" unless valid_json?(file)

    JSON.parse(file)
  end

  def valid_json?(string)
    !!JSON.parse(string)
  rescue JSON::ParserError
    false
  end
end
