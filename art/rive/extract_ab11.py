"""Extract artboard 11 from owl decomp into a riv_create-ready scene JSON."""
import json
from pathlib import Path

src = Path(r"c:\projects\crumbo\art\rive\owl_decomp.scene.json")
out = Path(r"c:\projects\crumbo\art\rive\owl_11.scene.json")

data = json.loads(src.read_text(encoding="utf-8"))
artboards = data.get("artboards") or []
ab11 = next((a for a in artboards if a.get("name") == "11"), None)
if ab11 is None:
    names = [a.get("name") for a in artboards]
    raise SystemExit(f"artboard 11 not found; have: {names}")

shapes = ab11.get("shapes") or []
groups = ab11.get("groups") or []
print(f"groups={len(groups)} shapes={len(shapes)}")
print(f"bg={ab11.get('backgroundColor')} size={ab11.get('width')}x{ab11.get('height')}")

# Summarize shape fills near eye region (local coords vary; list ids + fill)
for s in shapes[:30]:
    fill = s.get("fill") or {}
    color = fill.get("color") if isinstance(fill, dict) else None
    if not color and isinstance(fill, dict) and fill.get("gradient"):
        color = "gradient"
    print(
        f"  {s.get('id')} type={s.get('type')} parent={s.get('parent')} "
        f"xy=({s.get('x')},{s.get('y')}) wh=({s.get('width')},{s.get('height')}) fill={color}"
    )
print(f"... total shapes {len(shapes)}")

# Write single-artboard scene for riv_create
scene = {
    "artboard": {
        "name": ab11.get("name", "11"),
        "width": ab11.get("width", 500),
        "height": ab11.get("height", 500),
    },
    "backgroundColor": ab11.get("backgroundColor", "#000000"),
    "groups": groups,
    "shapes": shapes,
    "animations": ab11.get("animations") or [],
}
if ab11.get("images"):
    scene["images"] = ab11["images"]
if ab11.get("stateMachine"):
    scene["stateMachine"] = ab11["stateMachine"]

out.write_text(json.dumps(scene), encoding="utf-8")
print(f"wrote {out} ({out.stat().st_size} bytes)")
