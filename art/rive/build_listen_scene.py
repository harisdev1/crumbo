"""Build listen mood: pack artboard 11 + sound waves + attentive lean."""
import copy
import json
from pathlib import Path

ab = json.loads(Path(r"c:\projects\crumbo\art\rive\owl_11.scene.json").read_text(encoding="utf-8"))

shapes = [copy.deepcopy(s) for s in (ab.get("shapes") or [])]
groups = copy.deepcopy(ab.get("groups") or [])

WAVE = "#348ea0"


def wave_arc(gid: str, parent: str, radius: float, thickness: float) -> dict:
    """Open semicircle stroke — sound wave near ear."""
    r = radius
    return {
        "id": gid,
        "type": "polygon",
        "parent": parent,
        "x": 0,
        "y": 0,
        "subpaths": [
            {
                "closed": False,
                "points": [
                    {
                        "x": 0,
                        "y": -r,
                        "cubic": {
                            "rotation": 0,
                            "inRotation": 0,
                            "inDistance": 0,
                            "outDistance": r * 0.55,
                        },
                    },
                    {
                        "x": r,
                        "y": 0,
                        "cubic": {
                            "rotation": 90,
                            "inRotation": 270,
                            "inDistance": r * 0.55,
                            "outDistance": r * 0.55,
                        },
                    },
                    {
                        "x": 0,
                        "y": r,
                        "cubic": {
                            "rotation": 180,
                            "inRotation": 90,
                            "inDistance": r * 0.55,
                            "outDistance": 0,
                        },
                    },
                ],
            }
        ],
        "stroke": {
            "color": WAVE,
            "thickness": thickness,
            "cap": "round",
            "join": "round",
        },
    }


groups.extend(
    [
        {"id": "wave_a", "x": 355, "y": 175},
        {"id": "wave_b", "x": 378, "y": 168},
        {"id": "wave_c", "x": 402, "y": 160},
    ]
)

shapes.extend(
    [
        wave_arc("wave_a_g", "wave_a", 14, 3.2),
        wave_arc("wave_b_g", "wave_b", 20, 3.6),
        wave_arc("wave_c_g", "wave_c", 26, 4.0),
    ]
)

scene = {
    "artboard": {"name": "listen", "width": 500, "height": 500},
    "backgroundColor": "#00000000",
    "groups": groups,
    "shapes": shapes,
    "animations": [
        {
            "name": "listen_loop",
            "fps": 60,
            "duration": 120,
            "loop": "loop",
            "presets": [
                {
                    "preset": "breathing",
                    "target": "node1",
                    "intensity": 0.9,
                    "cycleSeconds": 2.0,
                }
            ],
            "tracks": [
                {
                    "target": "node1",
                    "property": "rotation",
                    "keyframes": [
                        {"frame": 0, "value": -3, "easing": "ease-in-out"},
                        {"frame": 60, "value": 3, "easing": "ease-in-out"},
                        {"frame": 120, "value": -3, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "wave_a",
                    "property": "opacity",
                    "keyframes": [
                        {"frame": 0, "value": 0.2, "easing": "ease-in-out"},
                        {"frame": 30, "value": 1, "easing": "ease-in-out"},
                        {"frame": 60, "value": 0.2, "easing": "ease-in-out"},
                        {"frame": 120, "value": 0.2, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "wave_b",
                    "property": "opacity",
                    "keyframes": [
                        {"frame": 0, "value": 0.15, "easing": "ease-in-out"},
                        {"frame": 20, "value": 0.15, "easing": "ease-in-out"},
                        {"frame": 50, "value": 1, "easing": "ease-in-out"},
                        {"frame": 80, "value": 0.15, "easing": "ease-in-out"},
                        {"frame": 120, "value": 0.15, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "wave_c",
                    "property": "opacity",
                    "keyframes": [
                        {"frame": 0, "value": 0.1, "easing": "ease-in-out"},
                        {"frame": 40, "value": 0.1, "easing": "ease-in-out"},
                        {"frame": 70, "value": 1, "easing": "ease-in-out"},
                        {"frame": 100, "value": 0.1, "easing": "ease-in-out"},
                        {"frame": 120, "value": 0.1, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "wave_a",
                    "property": "scaleX",
                    "keyframes": [
                        {"frame": 0, "value": 0.85, "easing": "ease-in-out"},
                        {"frame": 30, "value": 1.1, "easing": "ease-in-out"},
                        {"frame": 60, "value": 0.85, "easing": "ease-in-out"},
                        {"frame": 120, "value": 0.85, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "wave_a",
                    "property": "scaleY",
                    "keyframes": [
                        {"frame": 0, "value": 0.85, "easing": "ease-in-out"},
                        {"frame": 30, "value": 1.1, "easing": "ease-in-out"},
                        {"frame": 60, "value": 0.85, "easing": "ease-in-out"},
                        {"frame": 120, "value": 0.85, "easing": "ease-in-out"},
                    ],
                },
            ],
        }
    ],
    "stateMachine": {
        "name": "State Machine 1",
        "inputs": [],
        "states": [{"name": "listening", "animation": "listen_loop"}],
        "transitions": [{"from": "entry", "to": "listening"}],
    },
}

out = Path(r"c:\projects\crumbo\art\rive\owl_listen.scene.json")
out.write_text(json.dumps(scene), encoding="utf-8")
print(f"wrote {out} shapes={len(shapes)} groups={len(groups)}")
