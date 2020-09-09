# frozen_string_literal: true

class CompareSimilarity
  require 'json'

  def initialize(master_file_path, comparison_file_path)
    @master_file_path = master_file_path
    @comparison_file_path = comparison_file_path

    @master_json_keys = []
    @comparison_json_keys = []
    @match_values = []
  end

  EVALUATIVE_CRITERIA = {
    same_number_keys: 0.2,
    same_keys: 0.3,
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

    hash_base = @master_json_keys.length < @comparison_json_keys.length ? @comparison_json_keys : @master_json_keys

    ### Rule calculation: same number of keys in hash
    hash_aux = @master_json_keys.length < @comparison_json_keys.length ? @master_json_keys : @comparison_json_keys
    value_per_key = EVALUATIVE_CRITERIA[:same_number_keys] / hash_base.length
    decrease = value_per_key * (hash_base.length - hash_aux.length)

    score = EVALUATIVE_CRITERIA[:same_number_keys] - decrease

    ### Rule calculation: same keys in the hash
    value_per_key = EVALUATIVE_CRITERIA[:same_keys] / hash_base.length
    decrease = value_per_key * ((@master_json_keys - @comparison_json_keys) | (@comparison_json_keys - @master_json_keys)).length
    score += EVALUATIVE_CRITERIA[:same_keys] - decrease

    ### Rule calculation: similarity of key values
    key_value = EVALUATIVE_CRITERIA[:similarity_values] / hash_base.count
    score += key_value * @match_values.count
  end

  def compare_json(master_json, comparison_json)
    if master_json.is_a?(Array)
      iterate_array(master_json, comparison_json)
    elsif master_json.is_a?(Hash)
      iterate_hash(master_json, comparison_json)
    end

    @match_values << master_json if match_validation(master_json, comparison_json)
  end

  def iterate_hash(master_json, comparison_json)
    @master_json_keys << master_json.keys if master_json.is_a?(Hash)
    @comparison_json_keys << comparison_json.keys if comparison_json.is_a?(Hash)

    master_json.each do |key, value|
      next unless comparison_json&.key?(key)

      master_json_val, comparison_json_val = value, comparison_json[key]

      compare_json(master_json_val, comparison_json_val)
    end
  end

  def iterate_array(master_json, comparison_json)
    master_json.each_with_index do |obj, index|
      master_json_obj, comparison_json_obj = obj, comparison_json[index]
      compare_json(master_json_obj, comparison_json_obj)
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
