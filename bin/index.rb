# frozen_string_literal: true

require './bin/compare_similarity'

master_file = parse_file(ARGV[0])
comparison_file = parse_file(ARGV[1])

puts calculate_equality(master_file, comparison_file)
