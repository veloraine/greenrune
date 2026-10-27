"""Builds the field's tile models on the shared palette, saves them to field_tiles.blend and exports
each one as a GLB next to the palette.

  /Applications/Blender.app/Contents/MacOS/Blender --background --factory-startup \
      --python-exit-code 1 --python tools/blender/build_field_tiles.py

This is the base blockout. It overwrites field_tiles.blend, so once the models are polished by hand,
re-export them with export_glb.py instead of running this again.
"""

import os
import sys

import bmesh
import bpy

sys.path.insert(0, os.path.dirname(__file__))
import export_glb  # noqa: E402
import palette  # noqa: E402

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT_DIR = os.path.join(ROOT, "assets", "environment", "greenrune")
BLEND_PATH = os.path.join(OUT_DIR, "source", "field_tiles.blend")


def palette_material():
    mat = bpy.data.materials.new("palette")
    mat.use_backface_culling = True
    nodes = mat.node_tree.nodes
    bsdf = next(n for n in nodes if n.type == "BSDF_PRINCIPLED")
    tex = nodes.new("ShaderNodeTexImage")
    tex.image = bpy.data.images.load(palette.PNG_PATH)
    tex.image.filepath = bpy.path.relpath(tex.image.filepath, start=os.path.dirname(BLEND_PATH))
    tex.interpolation = "Closest"
    mat.node_tree.links.new(tex.outputs["Color"], bsdf.inputs["Base Color"])
    return mat


class Builder:
    """Faces added to one mesh, each UV'd onto a single palette swatch."""

    def __init__(self):
        self.bm = bmesh.new()
        self.uv = self.bm.loops.layers.uv.new("UVMap")

    def face(self, points, swatch):
        face = self.bm.faces.new([self.bm.verts.new(p) for p in points])
        for loop in face.loops:
            loop[self.uv].uv = palette.uv(swatch)

    def box(self, x0, x1, y0, y1, z0, z1, top, side):
        """An axis-aligned box with no bottom face, which no camera sees."""
        self.face([(x0, y0, z1), (x1, y0, z1), (x1, y1, z1), (x0, y1, z1)], top)
        self.face([(x0, y0, z0), (x1, y0, z0), (x1, y0, z1), (x0, y0, z1)], side)
        self.face([(x1, y1, z0), (x0, y1, z0), (x0, y1, z1), (x1, y1, z1)], side)
        self.face([(x0, y1, z0), (x0, y0, z0), (x0, y0, z1), (x0, y1, z1)], side)
        self.face([(x1, y0, z0), (x1, y1, z0), (x1, y1, z1), (x1, y0, z1)], side)

    def object(self, name, material):
        mesh = bpy.data.meshes.new(name)
        self.bm.to_mesh(mesh)
        self.bm.free()
        mesh.materials.append(material)
        obj = bpy.data.objects.new(name, mesh)
        bpy.context.scene.collection.objects.link(obj)
        return obj


def test_tile(material):
    b = Builder()
    b.box(-0.5, 0.5, -0.5, 0.5, 0.0, 0.02, "untilled", "untilled_side")
    return b.object("test_tile", material)


# Matches FarmGrid.TILE_FILL: a soil tile covers 0.95 of its 1 m cell, leaving a thin gap.
HALF = 0.475
SLAB = 0.02


def untilled(material):
    b = Builder()
    b.box(-HALF, HALF, -HALF, HALF, 0.0, SLAB, "untilled", "untilled_side")
    return b.object("soil_untilled", material)


def furrowed(name, ridge, furrow, sheen, material):
    """Two ridges running across the tile, with the crop's furrow between them. Blender's -Y is the
    side facing the camera. sheen, if given, paints puddles in the furrows."""
    b = Builder()
    b.box(-HALF, HALF, -HALF, HALF, 0.0, SLAB, furrow, furrow)
    for y in (-0.2, 0.2):
        x0, x1, z1 = -0.38, 0.38, 0.05
        lo0, lo1, hi0, hi1 = y - 0.11, y + 0.11, y - 0.04, y + 0.04
        b.face([(x0, hi0, z1), (x1, hi0, z1), (x1, hi1, z1), (x0, hi1, z1)], ridge)
        b.face([(x0, lo0, SLAB), (x1, lo0, SLAB), (x1, hi0, z1), (x0, hi0, z1)], ridge)
        b.face([(x1, lo1, SLAB), (x0, lo1, SLAB), (x0, hi1, z1), (x1, hi1, z1)], ridge)
        b.face([(x0, lo1, SLAB), (x0, lo0, SLAB), (x0, hi0, z1), (x0, hi1, z1)], furrow)
        b.face([(x1, lo0, SLAB), (x1, lo1, SLAB), (x1, hi1, z1), (x1, hi0, z1)], furrow)
    if sheen:
        z = SLAB + 0.002
        for x0, x1, y0, y1 in ((-0.34, -0.08, -0.06, 0.04), (0.1, 0.3, -0.03, 0.06), (-0.2, 0.12, 0.34, 0.4)):
            b.face([(x0, y0, z), (x1, y0, z), (x1, y1, z), (x0, y1, z)], sheen)
    return b.object(name, material)


def main():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    material = palette_material()
    objects = [
        test_tile(material),
        untilled(material),
        furrowed("soil_tilled", "tilled", "tilled_furrow", None, material),
        furrowed("soil_watered", "watered", "watered_furrow", "watered_sheen", material),
    ]
    os.makedirs(os.path.dirname(BLEND_PATH), exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=BLEND_PATH)
    export_glb.main([OUT_DIR] + [o.name for o in objects])


main()
