import json
from pathlib import Path

ab = json.loads(Path(r"c:\projects\crumbo\art\rive\owl_11.scene.json").read_text(encoding="utf-8"))
groups = {g["id"]: g for g in ab.get("groups") or []}
shapes = ab.get("shapes") or []

print("=== groups with solo/eye-ish ===")
for g in ab.get("groups") or []:
    keys = sorted(g.keys())
    interesting = {k: g[k] for k in keys if k not in ("id", "x", "y", "parent") or True}
    if "solo" in g or g["id"].startswith("solo") or "active" in g:
        print(json.dumps(g, indent=2)[:500])

print("\n=== all group ids ===")
for g in ab.get("groups") or []:
    print(f"{g['id']} parent={g.get('parent')} solo={g.get('solo')} active={g.get('active')}")

print("\n=== eye-colored shapes full ===")
eye_colors = {"#feffff", "#76421c", "#9d6132", "#ffffff", "#feffff"}
for s in shapes:
    fill = s.get("fill") or {}
    color = fill.get("color") if isinstance(fill, dict) else None
    parent = s.get("parent")
    if color in eye_colors or parent in ("node227", "node268", "node226", "node267", "solo219", "solo260"):
        print(f"{s['id']} parent={parent} fill={color} opacity={s.get('opacity')}")
        # print first subpath point count
        subs = s.get("subpaths") or []
        pts = sum(len(sp.get("points") or []) for sp in subs)
        print(f"  subpaths={len(subs)} points={pts}")
