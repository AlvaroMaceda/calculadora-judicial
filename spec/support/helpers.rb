def all_autonomous_communities_in_DB()
  AutonomousCommunity.all.to_a.map { |ac| 
      { code: ac.code, name: ac.name, country: ac.country.id}
  }
end