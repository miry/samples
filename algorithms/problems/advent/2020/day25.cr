class Breaker
  property owner_key : BigInt
  property door_key : BigInt

  def initialize(@owner_key, @door_key)
  end

  def decrypt
    onwer_key_loop_size = secret_loop_size(@owner_key)
    door_key_loop_size = secret_loop_size(@door_key)
    encryption_key = transform(@door_key, onwer_key_loop_size)
    encryption_key
  end

  def transform(subject_number, secret_loop_size)
    val = 1

    secret_loop_size.times do
      val = val * subject_number
      val = val % 20201227
    end
    val
  end

  def secret_loop_size(key)
    subject_number = 7
    val = 1

    result = 0
    while val != key
      result += 1
      val = val * subject_number
      val = val % 20201227
    end
    result
  end
end
