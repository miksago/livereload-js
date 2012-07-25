guard :coffeescript, :noop => true do
  watch(%r{^src/.+\.coffee$})
  callback(:run_on_changes_end) { `rake` }
end
