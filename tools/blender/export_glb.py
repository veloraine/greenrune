"""Exports each top-level mesh object of the open .blend to <out_dir>/<object name>.glb.

Re-export after editing a model:
  /Applications/Blender.app/Contents/MacOS/Blender --background --factory-startup <file.blend> \
      --python-exit-code 1 --python tools/blender/export_glb.py -- <out_dir> [object names...]

With no names it exports every top-level mesh object. Each export applies the object's rotation and
scale, moves its origin to the centre of its base, and sits that origin at the world origin, so the
model lands centred on its tile in Godot. The .blend on disk is not changed.
"""

import os
import sys

import bpy
from mathutils import Matrix, Vector


def export_object(obj, out_dir):
    bpy.ops.object.select_all(action="DESELECT")
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)
    corners = [Vector(c) for c in obj.bound_box]
    base = Vector((
        (min(c.x for c in corners) + max(c.x for c in corners)) / 2,
        (min(c.y for c in corners) + max(c.y for c in corners)) / 2,
        min(c.z for c in corners),
    ))
    obj.data.transform(Matrix.Translation(-base))
    obj.location = (0, 0, 0)
    path = os.path.join(out_dir, obj.name + ".glb")
    bpy.ops.export_scene.gltf(
        filepath=path,
        export_format="GLB",
        use_selection=True,
        export_yup=True,
        export_apply=True,
        export_materials="VIEWPORT",
        export_draco_mesh_compression_enable=False,
        export_meshopt_compression_enable=False,
        export_animations=False,
    )
    print("exported", path)


def main(argv):
    if not argv:
        raise SystemExit("usage: ... --python export_glb.py -- <out_dir> [object names...]")
    out_dir, names = argv[0], argv[1:]
    # 1 Blender unit = 1 m.
    bpy.context.scene.unit_settings.system = "METRIC"
    bpy.context.scene.unit_settings.scale_length = 1.0
    objects = [o for o in bpy.context.scene.objects if o.type == "MESH" and o.parent is None]
    if names:
        missing = set(names) - {o.name for o in objects}
        if missing:
            raise SystemExit("no top-level mesh object named: " + ", ".join(sorted(missing)))
        objects = [o for o in objects if o.name in names]
    os.makedirs(out_dir, exist_ok=True)
    for obj in objects:
        export_object(obj, out_dir)


if __name__ == "__main__":
    main(sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else [])
