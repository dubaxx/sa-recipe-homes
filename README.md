# Space Age Recipe Homes

[On the mod portal](https://mods.factorio.com/mod/sa-recipe-homes) | MIT licensed

Space Age hands recipes to the new planet buildings by tagging them with a crafting category. It did this for 41 base recipes in `space-age/base-data-updates.lua` and then stopped, which is why you still park an assembler next to a foundry for engine units.

Oil is the one that got me. Every planet got a building and Nauvis refining sat there untouched since 1.1. The refinery is the only production stage from the old game with no successor anywhere in the expansion.

Nothing is removed unless you ask for it. A recipe runs in any machine whose categories overlap its own, so assemblers, chemical plants and refineries keep working as before. The one exception is the battery setting's "move" mode, which takes the recipe off the cryogenic plant.

## What moves

**Foundry:** engine unit, and the metal infrastructure that is nothing but plate, gear, pipe and stick: rail, storage tank, pump, steel chest, steam engine, steam turbine, heat pipe, heat exchanger, electric mining drill, pumpjack, gun turret, flamethrower turret. Three new casting recipes, barrel, uranium fuel cell and refined concrete, unlocked with the foundry itself. Costs follow the vanilla casting ratios, 10 molten iron per iron plate and 30 per steel plate. Vanilla casts plain concrete from molten iron and leaves refined concrete in an assembler, so that path dead-ends one step early.

**Electromagnetic plant:** electric engine unit, flying robot frame, radar, lamp, the four combinators, display panel, programmable speaker, power switch, laser turret. Radar is electromagnetic by definition, the circuit network runs on the same electronics the plant already makes, and the laser turret is the tesla turret's sibling.

**Biochamber:** lubricant, and solid fuel from heavy oil, light oil or petroleum gas. Next to the cracking recipes it already runs.

**Cryogenic plant:** basic oil processing, advanced oil processing, coal liquefaction, atomic bomb. The plant already handles explosives.

Refining had to land in the cryogenic plant. Advanced oil processing puts out three fluids and the cryo plant is the only planet building with three fluid outputs. The other three are 2 in, 2 out.

## Five settings, all off

Rolling stock in the foundry: locomotive, cargo wagon, fluid wagon. The foundry already handles rails and every metal part, but a locomotive has a cab and windows.

Personal equipment in the electromagnetic plant: batteries, shields, personal solar, laser defense, night vision, belt immunity, roboports, exoskeleton. The last two are mechanics and robotics wearing an equipment grid.

Batteries in the electromagnetic plant. They are electrochemical and they feed accumulators, which the EM plant already builds. "Add" gives it the recipe alongside the cryogenic plant, "move" takes the cryo plant's copy away. That removal is the only one in the mod, and the chemical plant keeps the recipe either way.

Uranium processing, Kovarex, reprocessing and nuclear fuel in the cryogenic plant. The centrifuge keeps them either way. Off by default because the centrifuge is a dedicated machine like the rocket silo. If you want it on, the cryo plant is the right host, since it has no built-in productivity.

The six pre-2.0 science packs in planet buildings: automation, logistic, military and production in the foundry, utility in the EM plant, chemical in the cryo plant. Off by default because the packs would then quietly collect the building's 50% productivity.

## Overlap with other mods

[Foundry Restructuring](https://mods.factorio.com/mod/foundry-restructuring), [Foundry Expanded](https://mods.factorio.com/mod/foundry-expanded) and [Electromagnetic Plant Expanded](https://mods.factorio.com/mod/electromagnetic-plant-expanded) all cover the engine chain. [Extraplanetary Production](https://mods.factorio.com/mod/extraplanetary-production) covers a much wider spread of buildings and items. All four declare `factorio_version` 2.0 and predate the 2.1.7 categories rework.

Refining in the cryogenic plant, lubricant in the biochamber, refined concrete casting and the uranium recipes are the parts I could not find anywhere else. The rest is here so the set is complete.

## How it works

Category appends live in `data-final-fixes.lua`, after other mods have settled. A missing recipe logs a line instead of crashing. The three casting recipes and their tech unlocks are in `data.lua`, early enough that the recycler still sees them, and each carries `auto_recycle = false` so it does not duplicate the existing `barrel-recycling`, `uranium-fuel-cell-recycling` and `refined-concrete-recycling`.

The foundry, EM plant and biochamber carry a built-in 50% productivity that applies to everything they craft, including recipes that refuse productivity modules. The recipes moved by default already take productivity in vanilla, so those appends behave like Space Age's own. The settings are off because most of them hand that bonus to things that cannot normally have it: locomotives, personal equipment, science packs. Uranium is the exception, and it goes to the cryogenic plant, which has no built-in productivity at all.

A missing locale key does not fail the data stage. It shows up in game as "Unknown key" on the tooltip, so run `python3 check-locale.py` after adding a recipe or a setting.

Needs Space Age, and 2.1.7 or later where recipes carry a `categories` array.

## Left alone on purpose

Plate smelting, gears, iron sticks and low density structures already have foundry casting recipes, and the old recipe staying in an assembler is the point of that upgrade path. Rocket parts stay in the silo. Space Age's own recipes are out of scope, though tungsten carbide, holmium solution and lithium plate have the same problem: a planet's signature item that needs a building from somewhere else.

## Install

Symlink this directory into the mods folder under a `name_version` name. Give `ln` both arguments, or it creates the link in whatever directory you are standing in:

```bash
ln -s ~/personal/sa-recipe-homes ~/Library/Application\ Support/factorio/mods/sa-recipe-homes_0.1.0
```

```bash
ls -l ~/Library/Application\ Support/factorio/mods | grep sa-recipe-homes
```

## Checking a change

Load the data stage headless and watch for errors:

```bash
"$HOME/Library/Application Support/Steam/steamapps/common/Factorio/factorio.app/Contents/MacOS/factorio" --mod-directory "$HOME/Library/Application Support/factorio/mods" --create /tmp/probe.zip
```

To confirm what the categories actually came out as, dump the prototypes and read them back from `script-output/data-raw-dump.json`:

```bash
"$HOME/Library/Application Support/Steam/steamapps/common/Factorio/factorio.app/Contents/MacOS/factorio" --mod-directory "$HOME/Library/Application Support/factorio/mods" --dump-data
```

Three things that will waste your time otherwise:

- A running game holds an exclusive lock on the data directory. Either close it, or pass `--config` pointing at a config.ini whose `write-data` is a scratch directory.
- Startup settings are cached in `mod-settings.dat` in the mod directory. Changing a `default_value` does nothing until you delete that file.
- Locale is read at startup, so a changed .cfg needs a restart.

## Packaging

The zip must contain a single `sa-recipe-homes_<version>` folder, and the docs and the checker script should not ship:

```bash
rm -f sa-recipe-homes_0.1.0/*.md sa-recipe-homes_0.1.0/*.py && zip -rq sa-recipe-homes_0.1.0.zip sa-recipe-homes_0.1.0 -x '.*' '*/.*'
```
