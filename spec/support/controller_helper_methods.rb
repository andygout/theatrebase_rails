def add_whitespace_to_values params
  params.inject({}) do |hash, (key, val)|
    hash[key] = val.is_a?(Hash) ? add_whitespace_to_values(val) : val.is_a?(String) ? " #{val} " : val
    hash
  end
end
