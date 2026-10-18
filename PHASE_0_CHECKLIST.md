# Phase 0 — 8-week learning checklist

Target: ~8 hrs/week. Adjust pace to your reality; don't crunch.

## Week 1 — Setup + first 3D taste

- [x] Install Godot 4 stable (`brew install --cask godot`)
- [x] Enable Editor Settings → Text Editor → Behavior → Files → **Auto Reload Scripts on External Change**
- [x] Open Claude Code in the project folder; check it picks up `CLAUDE.md`
- [x] Set up Git LFS: `git lfs install` then verify `.gitattributes` rules are tracking
- [x] Complete [Godot Docs: Your First 3D Game](https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html) (~3 hours)
- [x] Spend 1 hour in a fresh project: add a cube, make it move with WASD

**Exit criterion:** you have a working "Squash the Creeps" project and a separate sandbox project with a moving cube.

## Week 2 — Second 3D project

- [x] Complete [GDQuest: Survivor Arena FPS](https://www.youtube.com/watch?v=NJJNWGD25rg) (~5–7 hours)
- [x] Read [Godot Docs: Introduction to 3D](https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html)
- [ ] Read [Godot Docs: Using 3D Transforms](https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html)

**Exit criterion:** comfortable in the Godot editor. Can move things in 3D space without thinking.

## Weeks 3–5 — The big one (3D RPG fundamentals)

- [x] Complete [Coding Quests 3D Action RPG Remastered](https://www.youtube.com/watch?v=1m6UXCtw2Pg) (~8 hours of video, 25–40 hours real time)

**Exit criterion:** you understand state machines, AnimationTree, GridMap, and basic AI patterns. You could explain them to a friend.

## Week 6 — Pipeline + assets + first character

- [x] Download [KayKit Adventurers](https://kaylousberg.com/game-assets) → `assets/characters/`
- [ ] Download [KayKit Dungeon Pack](https://kaylousberg.com/game-assets) → `assets/environment/` (deferred to Phase 1: unused in Phase 0, and its default import makes 203 separate texture copies)
- [x] Download [Quaternius Ultimate Nature](https://quaternius.com/) → `assets/environment/` (only the 5 grass and tree models the baseline scene uses)
- [x] ~~Complete [Antz: From Mixamo to Godot](https://antzgames.github.io/godot/demo/tutorial/Mixamo/)~~ Not needed: KayKit Adventurers ships 76 built-in animations (Idle, Walking_A, Running_A, 2H_Melee_Attack_Chop, ...). `scenes/player.tscn` uses them.

**Exit criterion:** a KayKit chibi character is animated with a Mixamo walk/idle in a Godot scene.

## Week 7 — Toon shader + baseline scene

- [x] Download [Complete Cel Shader for Godot 4](https://godotshaders.com/shader/complete-cel-shader-for-godot-4/) → `assets/shaders/`
- [ ] Read [Supermatrix Studio: Godot 4 Anime Shader Guide](https://supermatrix.studio/blog/creating-a-stylized-3D-cel-shader-in-godot-4-from-scratch) (optional)
- [x] Apply cel shader to test scene with KayKit character + Quaternius grass
- [x] Build `baseline_scene.tscn`:
  - KayKit Adventurer character
  - ~~Mixamo~~ KayKit built-in idle/run animation (see Week 6)
  - Quaternius grass patch + 2–3 trees
  - Cel shader on everything
  - Camera3D + SpringArm3D at semi-top-down RF4 angle
  - DirectionalLight3D for sun
- [x] Take screenshot, commit to repo as `docs/baseline_screenshot.png`

**Exit criterion:** `baseline_scene.tscn` exists, looks RF4-ish, and you understand every node in it.

## Week 8 — Feel test (throwaway)

- [x] New throwaway scene: the baseline character with a hoe and a 5×5 tile grid (`scenes/feel_test.tscn`; the hoe is KayKit's 2H axe as a stand-in)
- [x] Swing: animation → hitbox → the hit tile changes colour (the "hitbox" is the grid cell one tile ahead)
- [x] Add "pop": sound, dust particle, tiny camera shake, ~50 ms hit-stop (sound: Kenney CC0 `impactSoft_heavy`)
- [x] Tweak until 10 swings in a row feel satisfying, then write down what made the difference

**Week 8 tuning notes.** These are the final values in `player.gd` and `feel_test.gd`.

- `swing_speed` 2.5. The chop at 1x felt sluggish; RF tools are fast.
- `SWING_IMPACT_TIME` 1.0, the frame where the axe head is lowest. At 0.3 the tile changed mid-windup, before the tool touched it, and the hit felt fake.
- `swing_follow_through` 0.15 s. The player recovers soon after the hit, which keeps it snappy without cutting the swing.
- Each press restarts the swing clip. Without that, fast presses skipped the impact.
- Hit-stop 0.05 s. The freeze is short enough to feel like weight, not lag.
- Camera shake 0.05 strength for 0.1 s. The first 0.15 for 0.2 s felt like an explosion, too much for a farm tool.
- The thud picks from 5 samples with random pitch, so 10 swings in a row don't sound identical.
- Dust spawns after the hit-stop ends, so the burst is visible.

**Exit criterion:** swinging the hoe feels good, and you have notes on what made it feel good for Phase 1's tool pipeline.

**Phase 0 exit criterion (the only one that matters):** `baseline_scene.tscn` exists, looks RF4-ish, you understand every node in it, and the feel test is done.

## Later — Blender (when you first need a custom prop, Phase 4+)

Not part of Phase 0: the plan uses asset packs only until Phase 4. See [plan.md › Blender for game devs](docs/plan.md#blender-for-game-devs-when-you-first-need-a-custom-prop).

- [ ] Install Blender LTS
- [ ] [Blender Guru's Donut Tutorial](https://www.youtube.com/playlist?list=PLjEaoINr3zgEPv5y--4MKpciLaoQYZB1Z)
- [ ] Watch [Exporting 3D Models to Godot 4 — GLTF settings](https://www.youtube.com/watch?v=_eIAl_HZWXM)
- [ ] Watch [Blender low poly to Godot 4 export workflow](https://www.youtube.com/watch?v=4blCo5BpgWM)
- [ ] Export one prop as `.glb` and import it into Godot

## Notes / journal

Use this section to log anything weird, things you learned, or "wouldn't it be cool" ideas (which go in [NOT_IN_SCOPE.md](NOT_IN_SCOPE.md) instead of code).

---

(Add notes below as you progress.)

### Carry into Phase 1 (from the Week 8 review)

- The axe head lands about 0.6 m to the player's right of the tile that gets tilled (the chop swings across the body). Fix with a real hoe asset or by offsetting the tool in `handslot_r`.
- The tool target is one world point. Phase 1 needs grid cells from one function shared by the target highlight and the effect, so charge areas work.
- A press during swing recovery is dropped. Consider input buffering.
- Move the hit-stop to an autoload so scene changes can't leave `Engine.time_scale` at 0.
- ~~The baseline scene's trees have no collision, so the player walks through trunks.~~ Done for the farm: `scenes/props/tree_*.tscn` have trunk colliders.
