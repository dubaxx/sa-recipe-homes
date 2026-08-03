-- New foundry casting recipes for pre-2.0 items whose only route is an assembler.
-- Molten iron cost mirrors the vanilla casting ratios: 10 molten iron per iron plate, 30 per steel plate.

local function unlock(technology_name, recipe_name)
  local technology = data.raw.technology[technology_name]
  if not technology then return end
  technology.effects = technology.effects or {}
  table.insert(technology.effects, {type = "unlock-recipe", recipe = recipe_name})
end

data:extend({
  {
    type = "recipe",
    name = "sarh-casting-barrel",
    categories = {"metallurgy"},
    subgroup = "vulcanus-processes",
    order = "b[casting]-y[barrel]",
    icon = "__base__/graphics/icons/fluid/barreling/empty-barrel.png",
    enabled = false,
    energy_required = 1,
    ingredients = {{type = "fluid", name = "molten-iron", amount = 30, fluidbox_multiplier = 10}},
    results = {{type = "item", name = "barrel", amount = 1}},
    allow_productivity = true,
    allow_decomposition = false,
    auto_recycle = false,
  },
  {
    type = "recipe",
    name = "sarh-casting-uranium-fuel-cell",
    categories = {"metallurgy"},
    subgroup = "vulcanus-processes",
    order = "b[casting]-z[uranium-fuel-cell]",
    icon = "__base__/graphics/icons/uranium-fuel-cell.png",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "fluid", name = "molten-iron", amount = 100},
      {type = "item", name = "uranium-235", amount = 1},
      {type = "item", name = "uranium-238", amount = 19},
    },
    results = {{type = "item", name = "uranium-fuel-cell", amount = 10}},
    allow_productivity = true,
    allow_decomposition = false,
    auto_recycle = false,
  },
  {
    -- Vanilla casts plain concrete from molten iron but leaves refined concrete in an assembler, so the casting path
    -- dead-ends one step early. Molten iron stands in for the steel plate (30) and the eight iron sticks (40).
    type = "recipe",
    name = "sarh-casting-refined-concrete",
    categories = {"metallurgy"},
    subgroup = "vulcanus-processes",
    order = "b[casting]-x[refined-concrete]",
    icon = "__base__/graphics/icons/refined-concrete.png",
    enabled = false,
    energy_required = 15,
    ingredients = {
      {type = "item", name = "concrete", amount = 20},
      {type = "fluid", name = "molten-iron", amount = 70},
      {type = "fluid", name = "water", amount = 100},
    },
    results = {{type = "item", name = "refined-concrete", amount = 10}},
    allow_productivity = true,
    allow_decomposition = false,
    auto_recycle = false,
  },
})

-- All gated on the foundry itself; uranium is separately gated by needing enriched uranium to feed it.
unlock("foundry", "sarh-casting-barrel")
unlock("foundry", "sarh-casting-uranium-fuel-cell")
unlock("foundry", "sarh-casting-refined-concrete")
