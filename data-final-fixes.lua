local shared = require("shared")
local collision_mask_util = require("collision-mask-util")

local road_collision_layer = "transport-drones2-road"
local tiles = data.raw.tile


local road_list = {}
local road_tile_list =
{
  type = "selection-tool",
  name = "road-tile-list",
  hidden = true,
  icon = "__Transport_Drones2__/data/tf_util/empty-sprite.png",
  icon_size = 1,
  tile_filters = road_list,
  stack_size = 1,
  select =
  {
    mode = {"any-tile"},
    border_color = {},
    cursor_box_type = "entity"
  },
  alt_select =
  {
    mode = {"any-tile"},
    border_color = {},
    cursor_box_type = "entity"
  }
}
data:extend{road_tile_list}

local place_as_tile_condition = {layers = {water_tile = true}}

local process_road_item = function(item)

  local tile = tiles[item.place_as_tile.result]
  if not tile then return end
  local seen = {}
  while true do
    tile.collision_mask = {layers = {[road_collision_layer] = true}}
    table.insert(road_list, tile.name)
    seen[tile.name] = true
    tile = tiles[tile.next_direction or ""]
    if not tile then break end
    if seen[tile.name] then break end
  end
  item.place_as_tile.condition = place_as_tile_condition
end


local process_non_road_item = function(item)
  local condition = item.place_as_tile.condition
  if not condition.layers then condition.layers = {} end
  if condition.layers[road_collision_layer] then return end
  condition.layers[road_collision_layer] = true
end

for k, item in pairs (data.raw.item) do
  if item.place_as_tile then
    if item.is_road_tile then
      process_road_item(item)
    else
      process_non_road_item(item)
    end
  end
end

local all_used_tile_collision_masks = {}
for k, tile in pairs (tiles) do
  tile.check_collision_with_entities =  true
  for layer in pairs ((tile.collision_mask and tile.collision_mask.layers) or {}) do
    all_used_tile_collision_masks[layer] = true
  end
end

shared.drone_collision_mask = {
  layers = all_used_tile_collision_masks,
  not_colliding_with_itself = true,
  colliding_with_tiles_only = true,
}
shared.drone_collision_mask.layers[road_collision_layer] = nil

for k, prototype in pairs (collision_mask_util.collect_prototypes_with_layer("player-layer")) do
  if prototype.type ~= "gate" and prototype.type ~= "tile" then
    local mask = collision_mask_util.get_mask(prototype)
    if mask.layers and mask.layers["item-layer"] then
      mask.layers[road_collision_layer] = true
    end
    prototype.collision_mask = mask
  end
end

if data.raw["assembling-machine"]["mining-depot"] then
  local mask = collision_mask_util.get_mask(data.raw["assembling-machine"]["mining-depot"])
  mask.layers[road_collision_layer] = true
end

--Disable belts on roads
--[[
  for k, prototype in pairs (collision_mask_util.collect_prototypes_with_layer("transport-belt-layer")) do
    local mask = collision_mask_util.get_mask(prototype)
    collision_mask_util.add_layer(mask, road_collision_layer)
    prototype.collision_mask = mask
  end
]]

--error(serpent.block(road_list))

--So you don't place any tiles over road.

local util = require "__Transport_Drones2__/data/tf_util/tf_util"
require("data/entities/transport_drone/transport_drone")
require("data/make_request_recipes")
