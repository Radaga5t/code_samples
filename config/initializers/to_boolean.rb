# frozen_string_literal: true

# Имплементация метода приведения объекта к булевому типу
class Object
  def to_bool
    false
  end

  alias to_boolean to_bool
end

# Имплементация метода приведения символа к булевому типу
class Symbol
  def to_bool
    downcase == :true
  end

  alias to_boolean to_bool
end

# Имплементация метода приведения строки к булевому типу
class String
  def to_bool
    %w[1 true yes t].include? downcase
  end

  alias to_boolean to_bool
end

# Имплементация метода приведения числа к булевому типу
class Integer
  def to_bool
    self == 1
  end

  alias to_boolean to_bool
end

# Имплементация метода приведения числа к булевому типу
class TrueClass
  def to_bool
    true
  end

  alias to_boolean to_bool
end

# Имплементация метода приведения числа к булевому типу
class FalseClass
  def to_bool
    false
  end

  alias to_boolean to_bool
end
