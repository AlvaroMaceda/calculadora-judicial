def to_hex_two_digits(n)
  ('00'+n.to_s(16)).chars.last(2).join
end

def to_hex_7_digits(n)
  ('0000000'+n.to_s(16)).chars.last(7).join
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
  Holiday.find_by(holidayable_type: type.to_sym).to_a.map do |h|
    {
      type: h.holidayable_type,
      code: h.holidayable.code,
      date: h.date
    }
  end
end

def all_holidays_in_DB()
  # Holidays.
end