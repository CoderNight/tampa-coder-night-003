class Person
  attr_reader :user, :mentions
  def initialize user_array
    @user = user_array.shift.to_s.to_sym
    @mentions = user_array
  end
end