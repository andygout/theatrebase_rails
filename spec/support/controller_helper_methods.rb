def add_whitespace_to_values params
  params.transform_values { |v| " #{v} " }
end
