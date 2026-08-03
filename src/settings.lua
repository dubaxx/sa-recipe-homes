data:extend({
  {
    type = "bool-setting",
    name = "sarh-uranium-in-cryogenic-plant",
    setting_type = "startup",
    default_value = false,
    order = "a",
  },
  {
    type = "bool-setting",
    name = "sarh-old-science-in-planet-buildings",
    setting_type = "startup",
    default_value = false,
    order = "b",
  },
  {
    type = "string-setting",
    name = "sarh-battery-in-electromagnetic-plant",
    setting_type = "startup",
    default_value = "off",
    allowed_values = {"off", "add", "move"},
    order = "c",
  },
  {
    type = "bool-setting",
    name = "sarh-rolling-stock-in-foundry",
    setting_type = "startup",
    default_value = false,
    order = "d",
  },
  {
    type = "bool-setting",
    name = "sarh-personal-equipment-in-electromagnetic-plant",
    setting_type = "startup",
    default_value = false,
    order = "e",
  },
})
