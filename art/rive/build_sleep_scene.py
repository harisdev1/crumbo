"""Build sleep scene: pack artboard 11 vectors + closed eyes + Zzz + breath."""
import copy
import json
from pathlib import Path

ab = json.loads(Path(r"c:\projects\crumbo\art\rive\owl_11.scene.json").read_text(encoding="utf-8"))

# Open-eye parts to hide (iris, sclera highlight layers that read as open eyes)
HIDE_SHAPE_IDS = {
    "shape228",  # L highlight
    "shape235",  # L iris dark
    "shape243",  # L iris mid
    "shape251",  # L white
    "shape269",  # R highlight
    "shape276",  # R iris dark
    "shape284",  # R iris mid
    "shape292",  # R white
    "shape220",  # L clip-ish
    "shape261",  # R clip-ish
}

shapes = []
for s in ab.get("shapes") or []:
    s2 = copy.deepcopy(s)
    if s2.get("id") in HIDE_SHAPE_IDS:
        s2["opacity"] = 0
    shapes.append(s2)

# Closed-eye creases — short thick arcs in local eye space (parented to eye nodes).
# Cream lids sit slightly above the dark crease so it reads as a soft closed eye.
FACE_CREAM = "#e8d0ae"
LASH = "#5a3824"


def closed_eye(prefix: str, parent: str) -> list:
    """Return lid + crease shapes for one eye, local to eye node."""
    return [
        {
            "id": f"{prefix}_lid",
            "type": "ellipse",
            "parent": parent,
            "x": 0,
            "y": -2,
            "width": 28,
            "height": 14,
            "fill": {"color": FACE_CREAM},
        },
        {
            "id": f"{prefix}_crease",
            "type": "polygon",
            "parent": parent,
            "x": 0,
            "y": 1,
            "subpaths": [
                {
                    "closed": False,
                    "points": [
                        {
                            "x": -12,
                            "y": 0,
                            "cubic": {
                                "rotation": 0,
                                "inRotation": 0,
                                "inDistance": 0,
                                "outDistance": 4,
                            },
                        },
                        {
                            "x": 0,
                            "y": 4.5,
                            "cubic": {
                                "rotation": 0,
                                "inRotation": 180,
                                "inDistance": 6,
                                "outDistance": 6,
                            },
                        },
                        {
                            "x": 12,
                            "y": 0,
                            "cubic": {
                                "rotation": 0,
                                "inRotation": 180,
                                "inDistance": 4,
                                "outDistance": 0,
                            },
                        },
                    ],
                }
            ],
            "stroke": {
                "color": LASH,
                "thickness": 3.2,
                "cap": "round",
                "join": "round",
            },
        },
    ]


# Eyes live under node227 (L) and node268 (R)
shapes.extend(closed_eye("eyeL", "node227"))
shapes.extend(closed_eye("eyeR", "node268"))

# Soft blush on cheeks (face node area — node153 is beak/face-ish; use node151 head)
shapes.extend(
    [
        {
            "id": "blush_l",
            "type": "ellipse",
            "parent": "node151",
            "x": -28,
            "y": 18,
            "width": 16,
            "height": 10,
            "opacity": 0.4,
            "fill": {"color": "#FFAB91"},
        },
        {
            "id": "blush_r",
            "type": "ellipse",
            "parent": "node151",
            "x": 32,
            "y": 16,
            "width": 16,
            "height": 10,
            "opacity": 0.4,
            "fill": {"color": "#FFAB91"},
        },
    ]
)

# Zzz as simple stroked Z polygons in artboard space (above head)
def z_glyph(gid: str, x: float, y: float, scale: float) -> dict:
    s = scale
    return {
        "id": gid,
        "type": "polygon",
        "x": x,
        "y": y,
        "subpaths": [
            {
                "closed": False,
                "points": [
                    {"x": -8 * s, "y": -6 * s, "cubic": {"rotation": 0, "inRotation": 0, "inDistance": 0, "outDistance": 0}},
                    {"x": 8 * s, "y": -6 * s, "cubic": {"rotation": 0, "inRotation": 0, "inDistance": 0, "outDistance": 0}},
                    {"x": -8 * s, "y": 6 * s, "cubic": {"rotation": 0, "inRotation": 0, "inDistance": 0, "outDistance": 0}},
                    {"x": 8 * s, "y": 6 * s, "cubic": {"rotation": 0, "inRotation": 0, "inDistance": 0, "outDistance": 0}},
                ],
            }
        ],
        "stroke": {"color": "#8d8cc0", "thickness": 2.8 * s, "cap": "round", "join": "round"},
    }


# Groups for Zzz so we can animate y/opacity independently
groups = copy.deepcopy(ab.get("groups") or [])
groups.extend(
    [
        {"id": "zzz_a", "x": 340, "y": 150},
        {"id": "zzz_b", "x": 375, "y": 110},
        {"id": "zzz_c", "x": 410, "y": 75},
    ]
)

shapes.extend(
    [
        {**z_glyph("zzz_a_glyph", 0, 0, 1.0), "parent": "zzz_a"},
        {**z_glyph("zzz_b_glyph", 0, 0, 1.25), "parent": "zzz_b"},
        {**z_glyph("zzz_c_glyph", 0, 0, 1.5), "parent": "zzz_c"},
    ]
)

scene = {
    "artboard": {"name": "sleep", "width": 500, "height": 500},
    # Transparent — no black square in Flutter circle stage
    "backgroundColor": "#00000000",
    "groups": groups,
    "shapes": shapes,
    "animations": [
        {
            "name": "sleep_loop",
            "fps": 60,
            "duration": 180,
            "loop": "loop",
            "presets": [
                {
                    "preset": "breathing",
                    "target": "node1",
                    "intensity": 1.35,
                    "cycleSeconds": 2.8,
                }
            ],
            "tracks": [
                {
                    "target": "zzz_a",
                    "property": "y",
                    "keyframes": [
                        {"frame": 0, "value": 150, "easing": "ease-in-out"},
                        {"frame": 90, "value": 105, "easing": "ease-in-out"},
                        {"frame": 180, "value": 150, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "zzz_a",
                    "property": "opacity",
                    "keyframes": [
                        {"frame": 0, "value": 0.25, "easing": "ease-in-out"},
                        {"frame": 60, "value": 1, "easing": "ease-in-out"},
                        {"frame": 180, "value": 0.25, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "zzz_b",
                    "property": "y",
                    "keyframes": [
                        {"frame": 0, "value": 110, "easing": "ease-in-out"},
                        {"frame": 90, "value": 60, "easing": "ease-in-out"},
                        {"frame": 180, "value": 110, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "zzz_b",
                    "property": "opacity",
                    "keyframes": [
                        {"frame": 0, "value": 0.5, "easing": "ease-in-out"},
                        {"frame": 80, "value": 1, "easing": "ease-in-out"},
                        {"frame": 180, "value": 0.5, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "zzz_c",
                    "property": "y",
                    "keyframes": [
                        {"frame": 0, "value": 75, "easing": "ease-in-out"},
                        {"frame": 90, "value": 30, "easing": "ease-in-out"},
                        {"frame": 180, "value": 75, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "zzz_c",
                    "property": "opacity",
                    "keyframes": [
                        {"frame": 0, "value": 0.85, "easing": "ease-in-out"},
                        {"frame": 100, "value": 0.2, "easing": "ease-in-out"},
                        {"frame": 180, "value": 0.85, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "zzz_a",
                    "property": "rotation",
                    "keyframes": [
                        {"frame": 0, "value": -8, "easing": "ease-in-out"},
                        {"frame": 90, "value": 8, "easing": "ease-in-out"},
                        {"frame": 180, "value": -8, "easing": "ease-in-out"},
                    ],
                },
            ],
        }
    ],
    "stateMachine": {
        "name": "State Machine 1",
        "inputs": [],
        "states": [{"name": "sleeping", "animation": "sleep_loop"}],
        "transitions": [{"from": "entry", "to": "sleeping"}],
    },
}

out = Path(r"c:\projects\crumbo\art\rive\owl_sleep.scene.json")
out.write_text(json.dumps(scene), encoding="utf-8")
print(f"wrote {out} shapes={len(shapes)} groups={len(groups)}")
