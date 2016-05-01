require 'rails_helper'

describe Shared::ParamsHelper, type: :helper do
  context 'extracting alphabetise value with no leading article present in string' do
    it 'will return nil' do
      expect(extract_alphabetise_value('Adler & Gibb')).to eq nil
    end
  end

  context 'extracting alphabetise value with leading article present in string' do
    it 'will return string with leading article (A) removed' do
      expect(extract_alphabetise_value('A Number')).to eq 'Number'
    end

    it 'will return string with leading article (An) removed' do
      expect(extract_alphabetise_value('An Oak Tree')).to eq 'Oak Tree'
    end

    it 'will return string with leading article (The) removed' do
      expect(extract_alphabetise_value('The Tempest')).to eq 'Tempest'
    end

    it 'will return string with leading non-alphanumeric character (\') removed' do
      expect(extract_alphabetise_value('\'Tis Pity She\'s A Whore')).to eq 'Tis Pity She\'s A Whore'
    end
  end
end
