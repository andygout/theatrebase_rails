require 'rails_helper'

describe Shared::ParamsHelper, type: :helper do
  context 'getting alphabetise value with no leading article present in string' do
    it 'will return nil' do
      expect(get_alphabetise_value('Adler & Gibb')).to eq nil
    end

    it 'will remove whitespace before getting alphabetise value' do
      expect(get_alphabetise_value(' Adler & Gibb ')).to eq nil
    end
  end

  context 'extracting alphabetise value with leading article present in string' do
    it 'will return string with leading article (A) removed' do
      expect(get_alphabetise_value('A Number')).to eq 'Number'
    end

    it 'will return string with leading article (An) removed' do
      expect(get_alphabetise_value('An Oak Tree')).to eq 'Oak Tree'
    end

    it 'will return string with leading article (The) removed' do
      expect(get_alphabetise_value('The Tempest')).to eq 'Tempest'
    end

    it 'will return string with leading non-alphanumeric character (\') removed' do
      expect(get_alphabetise_value('\'Tis Pity She\'s A Whore')).to eq 'Tis Pity She\'s A Whore'
    end

    it 'will remove whitespace before getting alphabetise value' do
      expect(get_alphabetise_value(' A Number')).to eq 'Number'
    end
  end

  context 'generating url' do
    it 'will convert input string to lowercase and replace whitespace with hyphens' do
      expect(generate_url('The Taming Of The Shrew')).to eq 'the-taming-of-the-shrew'
    end

    it 'will convert ampersands to \'and\'' do
      expect(generate_url('Romeo & Juliet')).to eq 'romeo-and-juliet'
    end

    it 'will remove apostrophes from certain grammatical instances' do
      expect(generate_url('Duke of York\'s Theatre')).to eq 'duke-of-yorks-theatre'
      expect(generate_url('He\'d they\'ll I\'m we\'re she\'s didn\'t should\'ve')).to eq 'hed-theyll-im-were-shes-didnt-shouldve'
    end

    it 'will remove apostrophes from certain grammatical instances (including uppercase)' do
      expect(generate_url('HE\'D THEY\'LL I\'M WE\'RE SHE\'S DIDN\'T SHOULD\'VE')).to eq 'hed-theyll-im-were-shes-didnt-shouldve'
    end

    it 'will convert apostrophes to hyphens (outside of main grammatical instances)' do
      expect(generate_url('Peter O\'Toole')).to eq 'peter-o-toole'
      expect(generate_url('O\'Malley\'s')).to eq 'o-malleys'
      expect(generate_url('Palme d\'Or')).to eq 'palme-d-or'
      expect(generate_url('Sa\'mya')).to eq 'sa-mya'
    end

    it 'will remove unpermitted characters (leading apostrophes)' do
      expect(generate_url('\'Tis Pity She\'s A Whore')).to eq 'tis-pity-shes-a-whore'
    end

    it 'will remove unpermitted characters (colons)' do
      expect(generate_url('Henry IV: Part I')).to eq 'henry-iv-part-i'
    end

    it 'will remove unpermitted characters (forward slashes)' do
      expect(generate_url('Blue/Orange')).to eq 'blue-orange'
    end

    it 'will remove unpermitted characters (periods)' do
      expect(generate_url('Revolt. She said. Revolt again.')).to eq 'revolt-she-said-revolt-again'
      expect(generate_url('4.48 Psychosis')).to eq '4-48-psychosis'
    end

    it 'will remove unpermitted characters (commas)' do
      expect(generate_url('Caroline, or Change')).to eq 'caroline-or-change'
    end

    it 'will remove unpermitted characters (ellipses - whether typed as ellipsis or three periods)' do
      expect(generate_url('A… My Name Is Alice')).to eq 'a-my-name-is-alice'
      expect(generate_url('A... My Name Is Alice')).to eq 'a-my-name-is-alice'
    end

    it 'will remove unpermitted characters (question marks)' do
      expect(generate_url('Where Has Tommy Flowers Gone?')).to eq 'where-has-tommy-flowers-gone'
    end

    it 'will remove unpermitted characters (inverted exclamation points)' do
      expect(generate_url('¡Vamos Cuba!')).to eq 'vamos-cuba!'
    end

    it 'will retain permitted characters (asterisks)' do
      expect(generate_url('The Motherf**ker with the Hat')).to eq 'the-motherf**ker-with-the-hat'
    end

    it 'will retain permitted characters (exclamation points)' do
      expect(generate_url('Awake and Sing!')).to eq 'awake-and-sing!'
    end

    it 'will retain permitted characters (plus signs)' do
      expect(generate_url('Romeo + Juliet')).to eq 'romeo-+-juliet'
    end

    it 'will retain permitted characters (parentheses)' do
      expect(generate_url('In the Night Time (Before the Sun Rises)')).to eq 'in-the-night-time-(before-the-sun-rises)'
    end

    it 'will retain international characters (Chinese)' do
      expect(generate_url('哈姆雷特')).to eq '哈姆雷特'
    end

    it 'will retain international characters (Japanese hiragana)' do
      expect(generate_url('はむれっと')).to eq 'はむれっと'
    end

    it 'will retain international characters (Japanese katakana)' do
      expect(generate_url('ハムレット')).to eq 'ハムレット'
    end

    it 'will retain international characters (Hebrew)' do
      expect(generate_url('כְּפָר קָטָן')).to eq 'כְּפָר-קָטָן'
    end

    it 'will retain international characters (Arabic)' do
      expect(generate_url('قرية')).to eq 'قرية'
    end

    it 'will retain international characters (Thai)' do
      expect(generate_url('หมูบานเลก ๆ')).to eq 'หมูบานเลก-ๆ'
    end

    it 'will remove leading and trailing whitespace' do
      expect(generate_url(' Coriolanus ')).to eq 'coriolanus'
    end

    it 'will remove leading and trailing hyphens' do
      expect(generate_url('-Coriolanus-')).to eq 'coriolanus'
    end

    it 'will replace diacritics' do
      expect(generate_url('Tena Štivičić')).to eq 'tena-stivicic'
    end

    it 'will lowercase certain non-Roman characters' do
      expect(generate_url('Гамлет')).to eq 'гамлет'
    end

    it 'will reduce multiple spaces to a single space' do
      expect(generate_url('Titus  Andronicus')).to eq 'titus-andronicus'
    end
  end
end
