# Phase 0 — 8-week learning checklist

Target: ~8 hrs/week. Adjust pace to your reality; don't crunch.

## Week 1 — Setup + first 3D taste

- [ ] Install Godot 4 stable
- [ ] Install Blender LTS (won't use yet)
- [ ] Install `godot-tools` extension in Cursor
- [ ] Configure Godot to use Cursor as external editor (Editor Settings → Text Editor → External)
- [ ] Verify `.cursorrules` is in repo root
- [ ] Set up Git LFS: `git lfs install` then verify `.gitattributes` rules are tracking
- [ ] Complete [Godot Docs: Your First 3D Game](https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html) (~3 hours)
- [ ] Spend 1 hour in a fresh project: add a cube, make it move with WASD

**Exit criterion:** you have a working "Squash the Creeps" project and a separate sandbox project with a moving cube.

## Weeks 2–3 — Second 3D project + Blender begins

- [ ] Complete [GDQuest: Survivor Arena FPS](https://www.youtube.com/watch?v=NJJNWGD25rg) (~5–7 hours)
- [ ] Start [Blender Guru's Donut Tutorial](https://www.youtube.com/playlist?list=PLjEaoINr3zgEPv5y--4MKpciLaoQYZB1Z) — finish parts 1–4
- [ ] Read [Godot Docs: Introduction to 3D](https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html)
- [ ] Read [Godot Docs: Using 3D Transforms](https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html)

**Exit criterion:** comfortable navigating both editors. Can move things in 3D space without thinking.

## Weeks 3–6 — The big one (3D RPG fundamentals)

- [ ] Complete [Coding Quests 3D Action RPG Remastered](https://www.youtube.com/watch?v=1m6UXCtw2Pg) (~8 hours of video, 25–40 hours real time)
- [ ] Finish Blender Guru's Donut Tutorial
- [ ] Optional: [Grant Abbitt – Low Poly Animal](https://www.youtube.com/watch?v=F_JK9eaYYTQ)

**Exit criterion:** you understand state machines, AnimationTree, GridMap, and basic AI patterns. You could explain them to a friend.

## Weeks 6–7 — Pipeline + assets + first character

- [ ] Download [KayKit Adventurers](https://kaylousberg.com/game-assets) → `assets/characters/`
- [ ] Download [KayKit Dungeon Pack](https://kaylousberg.com/game-assets) → `assets/environment/`
- [ ] Download [Quaternius Ultimate Nature](https://quaternius.com/) → `assets/environment/`
- [ ] Watch [Exporting 3D Models to Godot 4 — GLTF settings](https://www.youtube.com/watch?v=_eIAl_HZWXM)
- [ ] Watch [Blender low poly to Godot 4 export workflow](https://www.youtube.com/watch?v=4blCo5BpgWM)
- [ ] Complete [Antz: From Mixamo to Godot](https://antzgames.github.io/godot/demo/tutorial/Mixamo/) — get a Mixamo animation playing on a KayKit character

**Exit criterion:** a KayKit chibi character is animated with a Mixamo walk/idle in a Godot scene.

## Weeks 7–8 — Toon shader + baseline scene

- [ ] Download [Complete Cel Shader for Godot 4](https://godotshaders.com/shader/complete-cel-shader-for-godot-4/) → `assets/shaders/`
- [ ] Read [Supermatrix Studio: Godot 4 Anime Shader Guide](https://supermatrix.studio/blog/creating-a-stylized-3D-cel-shader-in-godot-4-from-scratch) (optional)
- [ ] Apply cel shader to test scene with KayKit character + Quaternius grass
- [ ] Build `baseline_scene.tscn`:
  - KayKit Adventurer character
  - Mixamo idle/walk animation
  - Quaternius grass patch + 2–3 trees
  - Cel shader on everything
  - Camera3D + SpringArm3D at semi-top-down RF4 angle
  - DirectionalLight3D for sun
- [ ] Take screenshot, commit to repo as `docs/baseline_screenshot.png`

**Phase 0 exit criterion (the only one that matters):** `baseline_scene.tscn` exists, looks RF4-ish, and you understand every node in it.

## Notes / journal

Use this section to log anything weird, things you learned, or "wouldn't it be cool" ideas (which go in [NOT_IN_SCOPE.md](NOT_IN_SCOPE.md) instead of code).

---

(Add notes below as you progress.)
