
def to_hex_n_digits(number, n)
  ('0'*n+number.to_s(16)).chars.last(n).join
end

def to_hex_two_digits(n)
  to_hex_n_digits n,2
end

def to_hex_7_digits(n)
  to_hex_n_digits n,7
end

def pick_random(array)
  array[rand(0..array.length-1)]
end

def random_date_not_sunday
  # 8 is an arbitrary number
  min_date = Time.now - 8.years
  max_date = Time.now + 8.year
  begin
    rand_date = rand(min_date..max_date)
  end while rand_date.sunday?
  return rand_date
end

def all_territories_in_DB()
  Territory.all.to_a.map do |t| 
    { 
      kind: t.kind, 
      code: t.code,
      name: t.name, 
      parent: (t.parent ? t.parent.code : '') 
    }
  end
end

def all_holidays_in_DB_of_type(type)
  Holiday.where(holidayable_type: type.to_sym).to_a.map do |h|
    {
      type: h.holidayable_type,
      code: h.holidayable.code,
      date: h.date
    }
  end
end

def all_holidays_in_DB()
  Holiday.all.to_a.map do |h|
    {
      code: h.holidayable.code,
      date: h.date
    }
  end
end