# frozen_string_literal: true

require './bin/compare_similarity'

puts CompareSimilarity.new(ARGV[0], ARGV[1]).call
