
def to_hex_n_digits(number, n)
  ('0'*n+number.to_s(16)).chars.last(n).join
end

def to_hex_two_digits(n)
  to_hex_n_digits n,2
end

def to_hex_7_digits(n)
  to_hex_n_digits n,7
end

def random_date_not_sunday
  min_date = Time.now - 8.years
  max_date = Time.now + 8.year
  begin
    rand_date = rand(min_date..max_date)
  end while rand_date.sunday?
  return rand_date
end

def all_autonomous_communities_in_DB()
  AutonomousCommunity.all.to_a.map { |ac| 
      { code: ac.code, name: ac.name, country: ac.country.code }
  }
end

def all_municipalities_in_DB()
  Municipality.all.to_a.map do |m| 
    { code: m.code, name: m.name, 
      ac: m.autonomous_community.code, 
      country: m.autonomous_community.country.code 
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
      type: h.holidayable_type,
      code: h.holidayable.code,
      date: h.date
    }
  end
end