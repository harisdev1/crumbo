import copy
import json
from pathlib import Path

flat = json.loads(Path(r"c:\projects\crumbo\art\rive\owl_sleep_flat.scene.json").read_text(encoding="utf-8"))

body_shapes = []
for s in flat["shapes"]:
    if s.get("parent") != "owl_body":
        continue
    s2 = copy.deepcopy(s)
    # Import wrapper becomes the parent — drop nested parent ref
    s2.pop("parent", None)
    body_shapes.append(s2)

body_scene = {"shapes": body_shapes}
out = Path(r"c:\projects\crumbo\art\rive\owl_sleep_body.scene.json")
out.write_text(json.dumps(body_scene, separators=(",", ":")), encoding="utf-8")
print("body shapes", len(body_shapes), "bytes", out.stat().st_size)
