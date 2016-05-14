module Shared::ParamsHelper

  def strip_reqd k
    self[k].class == String && ![:password, :password_confirmation].include?(k)
  end

  def strip_whitespace
    self.attributes.keys.map { |k| self[k] = self[k].strip if strip_reqd(k) }
  end

  def extract_alphabetise_value string
    string[/^(A |An |The |\W+)(\S+.*)$/i, 2]
  end

  def generate_url string
    string.permanent
  end

end
