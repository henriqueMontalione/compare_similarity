# frozen_string_literal: true

require 'spec_helper'
require 'json'
require './bin/compare_similarity'

describe CompareSimilarity do
  subject(:compare_similarity) { described_class }

  let(:master_path) { 'spec/fixtures/BreweriesMaster.json' }
  let(:master_read) { File.read(master_path) }
  let(:master_file) { JSON.parse(master_read) }

  let(:compare_path) { 'spec/fixtures/BreweriesSample1.json' }

  let(:replied_score) { 1.0 }

  describe '#call' do
    context 'Calculation with correct params' do
      context 'with a correct file' do
        it { expect(compare_similarity.new(master_path, compare_path).call).to eq(replied_score) }
      end

      context 'file with different number of keys' do
        let(:master_path) { 'spec/fixtures/BreweriesMasterWithOneLessKey.json' }
        let(:replied_score) { 0.9750000000000001 }

        it { expect(compare_similarity.new(master_path, compare_path).call).to eq(replied_score) }
      end

      context 'file with different keys' do
        let(:master_path) { 'spec/fixtures/BreweriesMasterWithdiferenteKeys.json' }
        let(:replied_score) { 0.9725 }

        it { expect(compare_similarity.new(master_path, compare_path).call).to eq(replied_score) }
      end

      context 'file with different value in one key' do
        let(:master_path) { 'spec/fixtures/BreweriesMasterWithdifferenteValueInOneKey.json' }
        let(:replied_score) { 0.9875 }

        it { expect(compare_similarity.new(master_path, compare_path).call).to eq(replied_score) }
      end
    end

    context 'with incorrect params' do
      it { expect { compare_similarity.new.call }.to raise_error(ArgumentError) }
      it { expect { compare_similarity.new(master_file, master_file).call }.to raise_error(TypeError, 'no implicit conversion of Hash into String') }
    end
  end
end
