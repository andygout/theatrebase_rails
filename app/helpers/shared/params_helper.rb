module Shared::ParamsHelper

  def extract_alphabetise_value string
    string[/^(A |An |The |\W+)(\S+.*)$/i, 2]
  end

end
