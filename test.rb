parents = [{"id"=>"5691", "parent_id"=>nil, "lft"=>"3", "rght"=>"9096", "slug"=>"north-america", "slug_name"=>nil, "slug_root"=>false, "is_root"=>true, "is_country"=>false, "is_region"=>false, "is_main"=>false, "is_simple"=>true, "is_editable"=>false, "is_closed_a"=>false, "is_closed_c"=>false, "sort"=>"3", "contributor_id"=>nil, "name"=>"North America", "aliases"=>nil, "type"=>"mixed", "city"=>"", "state"=>"", "state_code"=>"", "country"=>"", "lat"=>nil, "lon"=>nil, "search_name"=>"north america", "description"=>nil, "directions"=>nil, "date_created"=>"2011-01-01 00:00:00", "date_modified"=>"2022-02-04 15:27:38"}, {"id"=>"5694", "parent_id"=>"5691", "lft"=>"8836", "rght"=>"9035", "slug"=>"mexico", "slug_name"=>nil, "slug_root"=>true, "is_root"=>false, "is_country"=>true, "is_region"=>false, "is_main"=>false, "is_simple"=>false, "is_editable"=>false, "is_closed_a"=>false, "is_closed_c"=>false, "sort"=>"0", "contributor_id"=>nil, "name"=>"Mexico", "aliases"=>nil, "type"=>"mixed", "city"=>"", "state"=>"", "state_code"=>"", "country"=>"", "lat"=>nil, "lon"=>nil, "search_name"=>"mexico", "description"=>nil, "directions"=>nil, "date_created"=>"2011-01-01 00:00:00", "date_modified"=>"2022-02-04 15:27:38"}, {"id"=>"1415", "parent_id"=>"5694", "lft"=>"8905", "rght"=>"8920", "slug"=>"salto-mexico", "slug_name"=>nil, "slug_root"=>false, "is_root"=>false, "is_country"=>false, "is_region"=>false, "is_main"=>false, "is_simple"=>false, "is_editable"=>true, "is_closed_a"=>false, "is_closed_c"=>false, "sort"=>"0", "contributor_id"=>nil, "name"=>"El salto", "aliases"=>nil, "type"=>"sport", "city"=>"Monterrey", "state"=>"", "state_code"=>"", "country"=>"Mexico", "lat"=>"25.40296471893534", "lon"=>"-100.25608062706641", "search_name"=>"el salto", "description"=>nil, "directions"=>nil, "date_created"=>"2011-01-01 00:00:00", "date_modified"=>"2022-02-04 15:27:38"}]
parent_areas = parents.map {|i| i["name"]}
p parent_areas