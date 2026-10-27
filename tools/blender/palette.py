"""The shared palette: one atlas of flat colour squares that every Blender model UVs onto.

Run with plain Python to rewrite the PNG:  python3 tools/blender/palette.py
Blender scripts import it to find a swatch's UV:  palette.uv("tilled")
"""

import os
import struct
import zlib

PNG_PATH = os.path.join(os.path.dirname(__file__), "..", "..", "assets", "environment", "greenrune", "palette.png")
GRID = 8
SWATCH_PX = 16
# Unused squares stay this grey, so a face UV'd onto one stands out.
EMPTY = (128, 128, 128)

# Name → sRGB colour, filled left to right, top to bottom. Append new swatches at the end:
# moving one moves its square, and every model UV'd onto it changes colour.
SWATCHES = {
    "untilled": (158, 128, 84),
    "untilled_side": (122, 97, 63),
    "tilled": (112, 72, 42),
    "tilled_furrow": (82, 52, 30),
    "watered": (54, 34, 22),
    "watered_furrow": (40, 25, 17),
    "watered_sheen": (96, 98, 112),
}


def uv(name):
    """The UV at the centre of a swatch's square, with V up as Blender counts it."""
    index = list(SWATCHES).index(name)
    col, row = index % GRID, index // GRID
    return ((col + 0.5) / GRID, 1.0 - (row + 0.5) / GRID)


def write_png(path=PNG_PATH):
    size = GRID * SWATCH_PX
    colours = list(SWATCHES.values())
    rows = []
    for y in range(size):
        row = bytearray([0])  # filter type: none
        for x in range(size):
            index = (y // SWATCH_PX) * GRID + x // SWATCH_PX
            row += bytes(colours[index] if index < len(colours) else EMPTY)
        rows.append(bytes(row))

    def chunk(kind, data):
        return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))

    header = struct.pack(">IIBBBBB", size, size, 8, 2, 0, 0, 0)
    with open(path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", header) + chunk(b"IDAT", zlib.compress(b"".join(rows))) + chunk(b"IEND", b""))


if __name__ == "__main__":
    write_png()
    print("wrote", os.path.normpath(PNG_PATH))
