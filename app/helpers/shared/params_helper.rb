module Shared::ParamsHelper

  def strip_reqd k
    self[k].class == String && ![:password, :password_confirmation].include?(k)
  end

  def strip_whitespace
    self.attributes.keys.map { |k| self[k] = self[k].strip if strip_reqd(k) }
  end

  def get_alphabetise_value string
    string.strip[/^(A |An |The |\W+)(\S+.*)$/i, 2]
  end

  def generate_url string
    string
      .gsub(/&/, 'and')               # convert '&' to 'and'
      .gsub(/\'(d |ll |m |re |s |t |ve )|\'(d|ll|m|re|s|t|ve)$/i, '\1\2')  # remove apostrophes from certain grammatical instances
      .gsub(/[^\p{Alnum}*!+()]/, ' ') # convert non-alphanumeric characters (save some exceptions) to whitespace
      .strip                          # remove leading and trailing whitespace
      .permanent                      # apply diacritics permanent method
      .gsub(/-+/, '-')                # convert double hyphens (resulting from double whitespace) to single hyphens
  end

  def amplify_attributes model, text_attr
    text_attr = params[model][text_attr]
    params[model][:alphabetise] = get_alphabetise_value(text_attr)
    params[model][:url] = generate_url(text_attr)
  end

end
