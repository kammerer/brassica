SELECT
  linkage_maps.id,
  linkage_maps.user_id,
  linkage_maps.updated_at,
  (linkage_maps.published AND plant_populations.published) AS published,
  taxonomy_terms.name AS taxonomy_term_name,
  plant_populations.name AS plant_population_name,
  linkage_map_label,
  linkage_map_name,
  map_version_no,
  map_version_date,
  linkage_groups_count,
  map_locus_hits_count,
  plant_population_id,
  pubmed_id
FROM linkage_maps
LEFT OUTER JOIN plant_populations ON plant_populations.id = linkage_maps.plant_population_id
LEFT OUTER JOIN taxonomy_terms ON taxonomy_terms.id = plant_populations.id;
