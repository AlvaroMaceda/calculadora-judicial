def all_autonomous_communities_in_DB()
  AutonomousCommunity.all.to_a.map { |ac| 
      { code: ac.code, name: ac.name, country: ac.country.code }
  }
end

def all_municipalities_in_DB()
  Municipality.all.to_a.map { |m| 
    { code: m.code, name: m.name, 
      ac: m.autonomous_community.code, 
      country: m.autonomous_community.country.code 
    }
  }
end