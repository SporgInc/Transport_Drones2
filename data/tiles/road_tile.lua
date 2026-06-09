local tile = util.copy(data.raw.tile["stone-path"])

tile.name = "transport-drone-road"
tile.localised_name = {"road"}
tile.tint = {0.5, 0.5, 0.5}
tile.collision_mask = {layers = {}}
tile.minable.result = "road"
tile.layer = 250
tile.placeable_by = {{item = "road", count = 1}}
tile.map_color={r=86/2, g=82/2, b=74/2}
tile.walking_speed_modifier = 1.5
tile.vehicle_friction_modifier = 0.9
tile.transitions = nil
tile.transitions_between_transitions = nil
-- Keep stone-path overlay sprites (stone-brick look) but add concrete's hard-edge mask
-- so the boundary clips sharply instead of alpha-fading.
if tile.variants and tile.variants.transition then
  local ol = tile.variants.transition.overlay_layout
  -- Crop overlay sprites to tile_height=1 so they align with the 1-tile-tall concrete mask PNGs.
  -- Stone-path overlays default to tile_height=2; reading them as tile_height=1 uses only the
  -- lower tile row, which contains the actual stone edge texture.
  if ol then
    if ol.inner_corner then ol.inner_corner.tile_height = 1 end
    if ol.outer_corner then ol.outer_corner.tile_height = 1 end
    if ol.side         then ol.side.tile_height         = 1 end
    if ol.u_transition then ol.u_transition.tile_height = 1 end
  end
  -- mask_layout uses concrete's hard-edge shape (no tile_height needed, defaults to 1)
  tile.variants.transition.mask_layout = {
    inner_corner  = {spritesheet = "__base__/graphics/terrain/concrete/concrete-inner-corner-mask.png",  count = 16, scale = 0.5},
    outer_corner  = {spritesheet = "__base__/graphics/terrain/concrete/concrete-outer-corner-mask.png",  count = 8,  scale = 0.5},
    side          = {spritesheet = "__base__/graphics/terrain/concrete/concrete-side-mask.png",           count = 16, scale = 0.5},
    u_transition  = {spritesheet = "__base__/graphics/terrain/concrete/concrete-u-mask.png",              count = 8,  scale = 0.5},
    o_transition  = {spritesheet = "__base__/graphics/terrain/concrete/concrete-o-mask.png",              count = 4,  scale = 0.5},
  }
end


local item =
{
  type = "item",
  name = "road",
  localised_name = {"road"},
  icons =
  {
    {
      icon = "__base__/graphics/icons/concrete.png",
      icon_size = 64,
      tint = {0.5, 0.5, 0.5}
    }
  },
  subgroup = "transport-drones",
  order = "b[concrete]-za[plain]",
  stack_size = 100,
  place_as_tile =
  {
    result = "transport-drone-road",
    condition_size = 1,
    condition = {layers = {}}
  },
  is_road_tile = true
}

local better_tile = util.copy(data.raw.tile["refined-concrete"])

better_tile.name = "transport-drone-road-better"
better_tile.localised_name = {"fast-road"}
better_tile.tint = {0.5, 0.5, 0.5}
better_tile.collision_mask = {layers = {}}
better_tile.minable.result = "fast-road"
better_tile.layer = 251
better_tile.placeable_by = {{item = "fast-road", count = 1}}
better_tile.map_color={r=86/2, g=82/2, b=74/2}
better_tile.walking_speed_modifier = 2
better_tile.vehicle_friction_modifier = 0.8
better_tile.transitions = nil
better_tile.transitions_between_transitions = nil
-- refined-concrete already uses mask-based concrete sprites; no variants changes needed

local better_item =
{
  type = "item",
  name = "fast-road",
  localised_name = {"fast-road"},
  icons =
  {
    {
      icon = "__base__/graphics/icons/refined-concrete.png",
      icon_size = 64,
      tint = {0.5, 0.5, 0.5}
    }
  },
  subgroup = "transport-drones",
  order = "b[concrete]-zb[plain]",
  stack_size = 200,
  place_as_tile =
  {
    result = "transport-drone-road-better",
    condition_size = 1,
    condition = {layers = {}}
  },
  is_road_tile = true
}

local recipe =
{
  type = "recipe",
  name = "road",
  localised_name = {"road"},
  icon = item.icon,
  icon_size = item.icon_size,
  --category = "transport",
  enabled = false,
  ingredients =
  {
    {type = "item", name = "stone-brick", amount = 10},
    {type = "item", name = "coal", amount = 10},
  },
  energy_required = 1,
  results = {{type = "item", name = "road", amount = 10}}
}

local fast_recipe =
{
  type = "recipe",
  name = "fast-road",
  localised_name = {"fast-road"},
  icon = better_item.icon,
  icon_size = better_item.icon_size,
  category = "crafting-with-fluid",
  enabled = false,
  ingredients =
  {
    {type = "item", name = "concrete", amount = 10},
    {type = "fluid", name = "crude-oil", amount = 50},
  },
  energy_required = 1,
  results = {{type = "item", name = "fast-road", amount = 10}}
}

data:extend
{
  tile,
  item,
  recipe,
  fast_recipe,
  better_tile,
  better_item,
  {type = "collision-layer", name = "transport-drones2-road"},
}

if alien_biomes_priority_tiles then
  table.insert(alien_biomes_priority_tiles, "transport-drone-road")
  table.insert(alien_biomes_priority_tiles, "transport-drone-road-better")
end