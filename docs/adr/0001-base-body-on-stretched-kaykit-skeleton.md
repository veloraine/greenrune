# Base body uses the benchmark's exact proportions on a stretched KayKit skeleton

The base body copies the benchmark model's proportions (about 3.0 heads tall, legs at 0.33 of height), not KayKit's 2.3 heads or a compromise at about 2.6. The user chose exact over the readability of a bigger head at our camera angle, and the head stays about the current player's size, so the character grows from about 2.2 to about 2.9 world units. It is a new mesh on KayKit Adventurers' 41-joint skeleton, with the same bone names and hierarchy but longer bones, so KayKit's 76 clips still play: Godot's retargeting fixes the hips height and stride, and contact-heavy clips (tool grips) are made custom. Proportions come from `tools/blender/base_body_proportions.json` through a build script, so the body can be re-proportioned for later characters. The benchmark itself is a game rip and is measured only, never used as a mesh base.

## Considered options

- **Shrink KayKit's head bone (0.8 → 2.43 heads):** rejected. The chunky KayKit body looked too big.
- **A new custom skeleton:** rejected. Every clip would have to be made from scratch before the character could even walk.
- **About 2.6 heads, between KayKit and the benchmark:** rejected by the user in favour of exact benchmark proportions.

## Consequences

- Doors, the bed, fences and camera framing need re-checking for the taller player.
- Any KayKit clip with hand or foot contact may need a custom replacement; the fit test in Phase 1.0 lists which.
- Re-running the build script overwrites hand-sculpting, so proportions are tuned in the numbers file before any hand-shaping.
