require "active_support/core_ext/hash"

class Hash
  # Return a new hash with all keys camelized.
  #
  #   { :first_name => 'Rob', :years_old => '28' }.camelize_keys
  #   #=> { :firstName => "Rob", :yearsOld => "28" }
  def camelize_keys(first_letter = :lower)
    dup.camelize_keys!(first_letter)
  end

  # Destructively camelize all keys. Same as
  # +camelize_keys+, but modifies +self+.
  def camelize_keys!(first_letter = :lower)
    keys.each do |key|
      new_key = key.to_s.camelize(first_letter)
      self[key.is_a?(Symbol) ? new_key.to_sym : new_key] = delete(key)
    end
    self
  end

  # Return a new hash with all keys underscored.
  #
  #   { :firstName => "Rob", :yearsOld => "28" }.underscore_keys
  #   #=> { :first_name => 'Rob', :years_old => '28' }
  def underscore_keys(recursive=false)
    dup.underscore_keys!(recursive)
  end

  # Destructively underscore all keys. Same as
  # +underscore_keys+, but modifies +self+.
  def underscore_keys!(recursive=false)
    keys.each do |key|
      new_key = key.to_s.underscore
      new_value = delete(key)
      new_value.underscore_keys!(recursive) if recursive and new_value.is_a? Hash
      new_value.map{|v| v.underscore_keys!(recursive) if v.is_a? Hash } if recursive and new_value.is_a? Array
      self[key.is_a?(Symbol) ? new_key.to_sym : new_key] = new_value
    end
    self
  end

  def ensure_keys(required_keys=[], optional_keys=[])
    assert_valid_keys(required_keys + optional_keys)
    required_keys.each  do |k|
      raise(ArgumentError, "Required key not found: #{k}") unless has_key?(k)
    end
    self
  end
end