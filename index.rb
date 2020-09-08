require './compare_similarity_service.rb'

master_file = parse_file(ARGV[0])
comparison_file = parse_file(ARGV[1])

puts calculate_equality(master_file, comparison_file)
