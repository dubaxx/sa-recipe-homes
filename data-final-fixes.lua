-- Category appends run in final fixes so recipes touched by other mods are already in their final shape.
-- A recipe crafts in every machine whose crafting_categories intersect its categories, so appending is additive:
-- the assembler / chemical plant / refinery route always survives.

local function add_category(recipe_name, category)
  local recipe = data.raw.recipe[recipe_name]
  if not recipe then
    log("sa-recipe-homes: recipe " .. recipe_name .. " not found, skipping " .. category)
    return
  end
  recipe.categories = recipe.categories or {"crafting"}
  for _, existing in pairs(recipe.categories) do
    if existing == category then return end
  end
  table.insert(recipe.categories, category)
end

local function add_all(pairs_list)
  for _, entry in pairs(pairs_list) do
    add_category(entry[1], entry[2])
  end
end

-- Only used by the battery "move" mode. Never leaves a recipe with no category, which would make it uncraftable.
local function remove_category(recipe_name, category)
  local recipe = data.raw.recipe[recipe_name]
  if not recipe or not recipe.categories or #recipe.categories < 2 then return end
  for index, existing in ipairs(recipe.categories) do
    if existing == category then
      table.remove(recipe.categories, index)
      return
    end
  end
end

-- Foundry: the metal-assembly step the casting recipes skipped over.
-- Electromagnetic plant: the electric drivetrain that ends in robot frames and utility science.
-- Biochamber: hydrocarbon handling, next to its own heavy/light cracking.
-- Cryogenic plant: the refinery tier, which is the one pre-2.0 production stage with no planet building.
-- Only the cryogenic plant has 3 fluid outputs, so advanced oil processing and coal liquefaction can go nowhere else.
add_all({
  {"engine-unit", "metallurgy"},

  -- Metal infrastructure. Nothing here is more than plate, gear, pipe and stick.
  {"rail", "metallurgy"},
  {"storage-tank", "metallurgy"},
  {"pump", "metallurgy"},
  {"steel-chest", "metallurgy"},
  {"steam-engine", "metallurgy"},
  {"steam-turbine", "metallurgy"},
  {"heat-pipe", "metallurgy"},
  {"heat-exchanger", "metallurgy"},
  {"electric-mining-drill", "metallurgy"},
  {"pumpjack", "metallurgy"},
  {"gun-turret", "metallurgy"},
  {"flamethrower-turret", "metallurgy"},

  {"electric-engine-unit", "electromagnetics"},
  {"flying-robot-frame", "electromagnetics"},

  -- Radar is an electromagnetic device by definition, and the circuit network runs on the same electronics the plant
  -- already makes. The laser turret is the tesla turret's sibling.
  {"radar", "electromagnetics"},
  {"small-lamp", "electromagnetics"},
  {"arithmetic-combinator", "electromagnetics"},
  {"decider-combinator", "electromagnetics"},
  {"selector-combinator", "electromagnetics"},
  {"constant-combinator", "electromagnetics"},
  {"display-panel", "electromagnetics"},
  {"programmable-speaker", "electromagnetics"},
  {"power-switch", "electromagnetics"},
  {"laser-turret", "electromagnetics"},

  -- The cryogenic plant already handles explosives.
  {"atomic-bomb", "cryogenics"},

  {"lubricant", "organic"},
  {"solid-fuel-from-heavy-oil", "organic"},
  {"solid-fuel-from-light-oil", "organic"},
  {"solid-fuel-from-petroleum-gas", "organic"},

  {"basic-oil-processing", "cryogenics"},
  {"advanced-oil-processing", "cryogenics"},
  {"coal-liquefaction", "cryogenics"},
})

-- Off by default: the centrifuge is a dedicated machine in the same class as the rocket silo, so vanilla leaving it
-- alone is defensible. The cryogenic plant is the balance-safe host because it is the one planet building with no
-- built-in productivity.
if settings.startup["sarh-uranium-in-cryogenic-plant"].value then
  add_all({
    {"uranium-processing", "cryogenics"},
    {"kovarex-enrichment-process", "cryogenics"},
    {"nuclear-fuel-reprocessing", "cryogenics"},
    {"nuclear-fuel", "cryogenics"},
  })
end

-- Batteries are electrochemical and feed accumulators, which the electromagnetic plant already builds. "add" leaves the
-- cryogenic plant route in place; "move" takes it away, which is the only removal this mod ever makes. The chemical
-- plant keeps the recipe either way.
local battery_mode = settings.startup["sarh-battery-in-electromagnetic-plant"].value
if battery_mode ~= "off" then
  add_category("battery", "electromagnetics")
  if battery_mode == "move" then
    remove_category("battery", "cryogenics")
  end
end

-- Off by default: a locomotive has a cab and windows. Casting the chassis is fine, the rest of it is a stretch.
if settings.startup["sarh-rolling-stock-in-foundry"].value then
  add_all({
    {"locomotive", "metallurgy"},
    {"cargo-wagon", "metallurgy"},
    {"fluid-wagon", "metallurgy"},
  })
end

-- Off by default: batteries, shields and personal solar are electrical, but the exoskeleton and personal roboport are
-- mostly mechanics and robotics wearing an equipment grid.
if settings.startup["sarh-personal-equipment-in-electromagnetic-plant"].value then
  add_all({
    {"battery-equipment", "electromagnetics"},
    {"battery-mk2-equipment", "electromagnetics"},
    {"battery-mk3-equipment", "electromagnetics"},
    {"energy-shield-equipment", "electromagnetics"},
    {"energy-shield-mk2-equipment", "electromagnetics"},
    {"solar-panel-equipment", "electromagnetics"},
    {"personal-laser-defense-equipment", "electromagnetics"},
    {"night-vision-equipment", "electromagnetics"},
    {"belt-immunity-equipment", "electromagnetics"},
    {"personal-roboport-equipment", "electromagnetics"},
    {"personal-roboport-mk2-equipment", "electromagnetics"},
    {"exoskeleton-equipment", "electromagnetics"},
  })
end

-- Off by default: vanilla's rule is that each planet building makes only its own science pack. Turning this on also
-- hands the packs the building's built-in 50% productivity, which is a large and permanent throughput change.
if settings.startup["sarh-old-science-in-planet-buildings"].value then
  add_all({
    {"automation-science-pack", "metallurgy"},
    {"logistic-science-pack", "metallurgy"},
    {"military-science-pack", "metallurgy"},
    {"production-science-pack", "metallurgy"},
    {"utility-science-pack", "electromagnetics"},
    {"chemical-science-pack", "cryogenics"},
  })
end
