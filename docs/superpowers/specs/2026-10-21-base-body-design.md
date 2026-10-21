# Base body and stand-in character: design

Date: 2026-10-21. Status: approved in chat, before the builder check.
Terms follow [GLOSSARY.md](../../../GLOSSARY.md): **base body**, **body type**, **character part**, **stand-in character**, **benchmark model**.

## Intent

Greenrune's characters should look like modern anime chibis (Blue Archive, Farnia Village), not KayKit's stubby figures. Earlier tests shrank KayKit's head bone to 0.8 (2.43 heads), but the chunky KayKit body then looked too big ([sandbox/prototypes/chibi_hoe/](../../../sandbox/prototypes/chibi_hoe/)). The fix is our own **base body**, built new in Blender on the KayKit Adventurers skeleton, so KayKit's 76 animation clips keep working.

The first character on it is a **stand-in character** that Claude builds to match the **benchmark model** as closely as possible. It replaces the KayKit Rogue as the player. Later the user builds their own final character on the same base body, so the base body must stay easy to adjust and reuse.

This work is the new **Phase 1.0 Character base**, done before Phase 1.1 (the field). It replaces the old Phase 2.0 in [docs/roadmap.md](../../roadmap.md).

## Benchmark model

- File: `~/Downloads/sample_3d_model_baseline/scene.gltf`, the "[Blue Archive] -Mari (Idol)- | Chibi + Stage" model from Sketchfab (uploader VückyZ). It's a static mesh with no skeleton or animations.
- **Measure only.** It's extracted from Blue Archive, so its CC-BY label isn't the uploader's to give. Never copy its files into the repo, never use its mesh as a base, never trace or retopologise over it, and never reuse its textures. Studying its proportions, face layout and painting style is fine.
- Measurement scripts and renders are in this session's scratchpad (`measure/`: `dump.py`, `render.py`, `calc.py`, `outline.py`). Rebuild them under `tools/blender/` if they're needed again, pointed at the Downloads path.

### Measurements

All values are normalised so ground to the top of the hair = 1.0. Mari's hat, cat ears and halo are left out of the height. Values marked * are estimates, because the benchmark has no skeleton and the skirt hides the hips.

| Measure | Mari (target) | KayKit Rogue (current) |
|---|---|---|
| Heads tall (chin to top of hair) | 3.02 | 2.31 |
| Head height | 0.331 | 0.433 |
| Head width (hair) / face width (skin) | 0.361 / 0.278 | 0.451 / 0.350 |
| Neck length | 0.053 | ~0 |
| Shoulder width / ÷ head width | 0.20* / 0.56 | 0.43 / 0.95 |
| Torso, neck base to crotch | 0.28* | 0.40 |
| Hip width | 0.24* | 0.34 |
| Leg, crotch to sole | 0.33* | 0.17 |
| Upper arm / forearm / hand | 0.136* / 0.136* / 0.070 | 0.110 / 0.119 / 0.084 |
| Thickness ÷ head width: upper arm / forearm / thigh / calf | 0.14 / 0.14 / 0.20 / 0.18 | 0.21 / 0.20 / 0.21 / 0.23 |
| Foot length × width | 0.091 × 0.047 (high heel) | 0.169 × 0.101 |
| Eye centre above chin ÷ head height | 0.29 | 0.39 |
| One eye: height ÷ head height / width ÷ head width | 0.19 / 0.22 | 0.13 / 0.13 |
| Gap between the eyes ÷ one eye's width | 0.61 | 2.30 |
| Mouth: height above chin ÷ head height / width ÷ head width | 0.11 / 0.08 | 0.18 / 0.20 |
| Eyebrow centre above chin ÷ head height | 0.48 | 0.52 |
| Triangles (no outline) / with outline shells | 16,431 / 30,172 | 4,347 |

How the benchmark's face is built:
- **Eyes:** a separate 176-triangle mesh with a 128² iris texture. The eye whites and lashes are painted on the 256² face texture.
- **Eyebrows:** a separate 118-triangle mesh.
- **Mouth:** a 32-triangle alpha-blended plate on a 1024² texture holding an 8×8 sheet of mouth shapes. Expressions change by moving the plate's UVs to another cell.
- **Outlines:** separate copies of the body and hair with flipped faces, pushed out evenly by about 0.0016 of height.

## Goals

1. **Proportions:** the benchmark's, within ±3% on every measurement in the table. Where a value is marked *, match the benchmark's silhouette in front and side renders instead. *(Claude's call)* The foot row is exempt and replaced by the flat-boot size below. Ground to crotch stays 0.33 with flat feet, so the shins are a little longer than the benchmark's heeled ones.
2. **Size in the world:** the head is about the size of the current player's (about 0.95 world units), which makes the stand-in about 2.9 units tall at 3.0 heads. The current KayKit player is about 2.2 units; tiles are 1 unit.
3. **Face:** the benchmark's layout within ±3%: eye position, size and gap; mouth position and size; eyebrow position.
4. **Face construction:** like the benchmark's.
   - Separate eye, eyebrow and mouth meshes.
   - The mouth uses a sheet of shapes, swapped by moving its UVs.
   - The eyes also get a sheet of shapes, at least open, half-closed, closed and happy, so blinking works.
   - Start with one neutral expression plus a blink.
5. **Face lighting:** the face is lit flat, with no cel shadow bands across it. The body keeps the project's cel shading.
6. **Outlines:** inverted-hull shells for the body and hair, kept only if a side-by-side test at the gameplay camera looks better than no outline. The repo already has `outline.gdshader`.
7. **Budget:** about 10k triangles without the outline shells. Body texture about 512², face and hair about 256² each, hair with a colour gradient. Characters don't use the shared palette texture; they get their own painted textures in the benchmark's style.
8. **Skeleton:** KayKit Adventurers' 41-joint skeleton. Keep its bone names, its hierarchy and the `handslot_l` and `handslot_r` attachment points, and lengthen bones to the new proportions. Godot's import retargeting (normalise position tracks, rest fixer) corrects the hips height and stride in KayKit's clips.
9. **Animations:**
   - **Fit test:** play all 76 KayKit clips on the new body and list each one as fine, fixable, or needing a replacement.
   - **Custom clips:**
     - **Tool carry:** like RF4 and Farnia, the selected tool stays in the right hand at all times, while standing, walking and running. Every tool shares the same one-hand grip and carry pose. The hoe stands upright at the right side, held at chest-to-shoulder height, never crossing the body's centre line. The left hand is free. The carry pose is layered over Idle, Walking_* and Running_A on the right arm, so the legs and the rest of the body keep their normal motion. `scripts/player.gd` shows the tool whenever it is selected, not only while charging and swinging. *(Claude's call)* Which bones the layer covers (right arm only, or the whole upper body) is the builder's choice, as long as the tool stays steady.
     - **Hoe chop:** a straight two-handed overhead chop, in the vertical plane along the facing direction. The hoe head's sideways drift stays under 10 cm, and both hands stay on the handle (IK for the left hand is allowed).
     - **Blink.**
   - The watering can and sickle keep KayKit's clips unless the fit test flags them.
   - *(Claude's call)* "Fixed" covers only the clips the game uses in Phases 1–3: Idle, Walking_*, Running_A, Use_Item, the chop and slice clips used by tools, PickUp, and the Sit_* and Lie_* clips. Combat, ranged, spellcast, dodge, block and death clips are only listed, for Phase 4.
   - *(Claude's call)* Phase 1.0 wires the hoe to the new chop: `data/items/hoe.tres` switches `swing_animation` to it and retunes `impact_time`. Phase 1.2 Step 4 (2H_Melee_Attack_Chop with a grip fix) is retired.
10. **Easy to adjust later:**
    - **Proportions file:** every proportion lives in one numbers file, `tools/blender/base_body_proportions.json`. A build script reads it and rebuilds the body mesh and the bone lengths.
    - **Shape keys:** the chest difference between male and female builds is a shape key. Later child and elderly body types can be shape keys too, or separate builds from the same script.
    - **Separate parts:** head, face pieces, hair and boots are separate meshes. *(Claude's call)* The outfit is mostly painted on the body texture, with separate meshes only for pieces that stand off the body (a collar or a skirt edge, if the design has them). There is one full body mesh, no hidden skin under clothes.
    - **Workflow rule:** tune proportions with the numbers file first. Hand-shaping in the `.blend` comes after that, because re-running the script overwrites hand work.
11. **Modelling practice:** standard for animated game characters.
    - Mostly four-sided polygons with clean edge flow.
    - Extra edge loops at shoulders, elbows, wrists, hips, knees and ankles so they bend cleanly.
    - Built mirrored, so left and right match.
    - All transforms applied, real scale, the pivot point at the feet between the soles, facing the direction KayKit faces, and +Y up after Godot import.
    - Non-overlapping UVs with consistent texel density per part, except for deliberately mirrored areas.
    - Weights normalised, with at most 4 bones per vertex.
    - Consistent, readable names for meshes, materials and bones.
    - No stray objects in the export. KayKit's Rogue GLB contains a stray 80-triangle Icosphere; avoid that kind of thing.

## Stand-in character design

- **Our own design:**
  - an adult female farmer, following the benchmark's build;
  - shoulder-length hair as its own mesh, with a gradient;
  - a simple painted farm outfit;
  - simple flat boots: slim, about 0.10 of height long, no heels;
  - hands in one fixed, slightly curled shape with a separate thumb, and no finger bones.
- **Nothing from the benchmark character:** no cat ears, top hat, idol dress, halo, or Mari's own eye art.

## Non-goals

- More than one character, or child and elderly body types (they come when the first such NPC needs one).
- Finger bones, facial bones, or blend-shape facial animation.
- Anime-style face shadows (SDF face shadow maps or edited normals). The face is lit flat for now.
- Expressions beyond neutral and a blink.
- Animation clips beyond the tool carry, hoe chop, blink and whatever the fit test says must be fixed or replaced.
- The system that builds a character from a data file (which head, hair, outfit and colours) and assembles its scene. It comes in Phase 2, before the first NPC. In Phase 1.0 the parts are separate meshes and the player uses the stand-in directly.
- The user's own final character. They build it later on this base.

## Anti-goals (failure even if it technically works)

- Any benchmark geometry, UVs or textures in the repo or the game.
- A rig whose bone names or hierarchy differ from KayKit's, so its clips stop playing.
- Hand-sculpted proportions that the numbers file can no longer reproduce.
- Feet that sink into the ground, float above it, or slide during walk and run.
- A face that's unreadable at the gameplay camera.

## Constraints

- Godot 4.7.2 (the installed version), typed GDScript, GLB (glTF 2.0) assets, and the community cel shader through ShaderMaterial (see [CLAUDE.md](../../../CLAUDE.md)).
- Blender is at `/Applications/Blender.app/Contents/MacOS/Blender`. Claude drives it headless: `--background --python <script>`.
- Claude builds the base and placeholder art; the user polishes and later builds their own character ([CLAUDE.md](../../../CLAUDE.md) "AI assistant behavior").
- Each piece of work gets the repo's usual close-out: deslop, an independent review, a commit, and a short test script for the user.
- Don't touch `data/camera.tres` until the user commits or discards their uncommitted change. Camera reframing at checkpoint 4 waits for that.
- *(Claude's call)* The character's size is fixed by goal 2. If the taller player doesn't fit doors, the bed, fences or the player's collision capsule, those get adjusted to the character, not the other way round. The house interior is built from boxes, so this is cheap.

## Files

- `tools/blender/`: the build scripts and `base_body_proportions.json`.
- `assets/characters/greenrune/`: the `.blend` source and the exported `.glb`, plus face and texture sheets.
- `docs/adr/0001-…`: why the base body uses the benchmark's exact proportions on a stretched KayKit skeleton.
- `scenes/player.tscn`: swaps `Rogue.glb` for the stand-in at checkpoint 4.

## Checkpoints (the user signs off each one; every checkpoint shows renders next to the benchmark)

1. **Grey blockout:** proportions and silhouette only, at the same normalised height as the benchmark, in front and side views, with a measurement table showing each value's percentage off target.
2. **Face:** face pieces in place, placeholder eye, eyebrow and mouth art, the expression sheets working, and the flat-lit face shown in Godot.
3. **Hair, outfit and textures:** painted placeholder textures, the hair gradient, and the outline-on vs outline-off comparison.
4. **In the game:** skeleton fitted, fit-test results, the two hoe clips and the blink, the stand-in as the player at the gameplay camera, and doors, bed, fences and camera framing re-checked for the taller character.

## Done when

- Every proportion and face measurement is within ±3% of the benchmark.
- Under about 10k triangles, without the outline shells.
- All 76 KayKit clips are fit-tested; every clip used in Phases 1–3 plays with no sinking, floating or foot sliding, fixed or replaced where flagged.
- Tool carry: the selected tool is visible in the right hand in idle, walk and run; the hoe stays within 5° of vertical when standing and within 15° *(default)* while walking and running; the hand stays on the handle within 1 cm; no clipping into the body or legs.
- Hoe chop: sideways drift under 10 cm, both hands on the handle.
- The blink works.
- The farm runs at 60 fps with the stand-in.
- Save and load still work with the new player model.
- The user approves it at the gameplay camera.
- Every item meets [docs/endgame.md](../../endgame.md)'s definition of done.

## Left to the builder

- The topology layout and exact loop counts within the 10k budget.
- How the face's flat lighting is done (an unshaded face material, a shader flag, or normals pointing forward).
- Expression sheet cell sizes and layout.
- How the hoe chop is keyed, and whether the left hand uses `TwoBoneIK3D`. The earlier test showed it needs a pole node in 4.7.2.
- The JSON schema of the proportions file.
- How the retargeting import settings are configured.
