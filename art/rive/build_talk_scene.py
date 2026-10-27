"""Build talk mood: pack artboard 11 + mouth bob + bounce."""
import copy
import json
from pathlib import Path

ab = json.loads(Path(r"c:\projects\crumbo\art\rive\owl_11.scene.json").read_text(encoding="utf-8"))

shapes = [copy.deepcopy(s) for s in (ab.get("shapes") or [])]
groups = copy.deepcopy(ab.get("groups") or [])

BEAK_ORANGE = "#F4A261"
MOUTH_DARK = "#5a3824"

# Open-mouth oval under beak (parented to face node151)
shapes.extend(
    [
        {
            "id": "mouth_open",
            "type": "ellipse",
            "parent": "node151",
            "x": 2,
            "y": 22,
            "width": 18,
            "height": 14,
            "fill": {"color": MOUTH_DARK},
        },
        {
            "id": "mouth_inner",
            "type": "ellipse",
            "parent": "node151",
            "x": 2,
            "y": 23,
            "width": 10,
            "height": 7,
            "fill": {"color": "#C45C4A"},
        },
        {
            "id": "beak_tip",
            "type": "ellipse",
            "parent": "node151",
            "x": 2,
            "y": 14,
            "width": 16,
            "height": 10,
            "fill": {"color": BEAK_ORANGE},
        },
    ]
)

scene = {
    "artboard": {"name": "talk", "width": 500, "height": 500},
    "backgroundColor": "#00000000",
    "groups": groups,
    "shapes": shapes,
    "animations": [
        {
            "name": "talk_loop",
            "fps": 60,
            "duration": 60,
            "loop": "loop",
            "presets": [
                {
                    "preset": "breathing",
                    "target": "node1",
                    "intensity": 1.15,
                    "cycleSeconds": 1.0,
                }
            ],
            "tracks": [
                {
                    "target": "node1",
                    "property": "y",
                    "keyframes": [
                        {"frame": 0, "value": 370.5, "easing": "ease-in-out"},
                        {"frame": 15, "value": 358, "easing": "ease-out"},
                        {"frame": 30, "value": 370.5, "easing": "ease-in"},
                        {"frame": 45, "value": 362, "easing": "ease-out"},
                        {"frame": 60, "value": 370.5, "easing": "ease-in"},
                    ],
                },
                {
                    "target": "mouth_open",
                    "property": "scaleY",
                    "keyframes": [
                        {"frame": 0, "value": 0.35, "easing": "ease-in-out"},
                        {"frame": 12, "value": 1.15, "easing": "ease-out"},
                        {"frame": 24, "value": 0.4, "easing": "ease-in"},
                        {"frame": 36, "value": 1.05, "easing": "ease-out"},
                        {"frame": 48, "value": 0.5, "easing": "ease-in"},
                        {"frame": 60, "value": 0.35, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "mouth_inner",
                    "property": "scaleY",
                    "keyframes": [
                        {"frame": 0, "value": 0.3, "easing": "ease-in-out"},
                        {"frame": 12, "value": 1.1, "easing": "ease-out"},
                        {"frame": 24, "value": 0.35, "easing": "ease-in"},
                        {"frame": 36, "value": 1.0, "easing": "ease-out"},
                        {"frame": 48, "value": 0.4, "easing": "ease-in"},
                        {"frame": 60, "value": 0.3, "easing": "ease-in-out"},
                    ],
                },
                {
                    "target": "mouth_open",
                    "property": "opacity",
                    "keyframes": [
                        {"frame": 0, "value": 0.85, "easing": "ease-in-out"},
                        {"frame": 12, "value": 1, "easing": "ease-in-out"},
                        {"frame": 24, "value": 0.7, "easing": "ease-in-out"},
                        {"frame": 36, "value": 1, "easing": "ease-in-out"},
                        {"frame": 60, "value": 0.85, "easing": "ease-in-out"},
                    ],
                },
            ],
        }
    ],
    "stateMachine": {
        "name": "State Machine 1",
        "inputs": [],
        "states": [{"name": "talking", "animation": "talk_loop"}],
        "transitions": [{"from": "entry", "to": "talking"}],
    },
}

out = Path(r"c:\projects\crumbo\art\rive\owl_talk.scene.json")
out.write_text(json.dumps(scene), encoding="utf-8")
print(f"wrote {out} shapes={len(shapes)} groups={len(groups)}")
