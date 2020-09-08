# frozen_string_literal: true

require 'spec_helper'
require 'json'
require './bin/compare_similarity'

describe 'compare_similarity' do
  let(:master_path) { 'spec/fixtures/BreweriesMaster.json' }
  let(:master_read) { File.read(master_path) }
  let(:master_file) { JSON.parse(master_read) }

  let(:compare_path) { 'spec/fixtures/BreweriesSample1.json' }
  let(:compare_read) { File.read(compare_path) }

  let(:textFile_path) { 'spec/fixtures/TextFile.txt' }

  let(:master_json_value) { 'qwerty' }
  let(:comparison_json_value) { 'qwerty' }
  let(:comparison_json_value_hash) { { 'qwerty': 'qwerty' } }
  let(:comparison_json_value_array) { ['qwerty'] }
  let(:comparison_json_value_wrong) { 'qwert2' }

  describe '#match_validation' do
    context 'with correct params' do
      it { expect(match_validation(master_json_value, comparison_json_value)).to be_truthy }
    end

    context 'with incorrect params' do
      it { expect(match_validation(master_json_value, comparison_json_value_hash)).to be_falsey }
      it { expect(match_validation(master_json_value, comparison_json_value_array)).to be_falsey }
      it { expect(match_validation(master_json_value, comparison_json_value_wrong)).to be_falsey }
    end
  end

  describe '#parse_file' do
    context 'with correct params' do
      it { expect(parse_file(master_path)).to eq(master_file) }
    end

    context 'with incorrect params' do
      it { expect { parse_file(textFile_path) }.to raise_error(RuntimeError, "The input file: 'spec/fixtures/TextFile.txt' must be a json") }
    end
  end

  describe '#valid_json?' do
    context 'with correct params' do
      it { expect(valid_json?(master_read)).to be_truthy }
    end

    context 'with incorrect params' do
      it { expect(valid_json?(textFile_path)).to be_falsey }
    end
  end
end
