"""Flatten pack artboard 11 into absolute shapes + closed eyes, preserving cubics."""
from __future__ import annotations

import copy
import json
import math
from pathlib import Path

HIDE = {
    "shape228",
    "shape235",
    "shape243",
    "shape251",
    "shape269",
    "shape276",
    "shape284",
    "shape292",
    "shape220",
    "shape261",
}


def mat_mul(a, b):
    return [
        a[0] * b[0] + a[1] * b[3] + a[2] * b[6],
        a[0] * b[1] + a[1] * b[4] + a[2] * b[7],
        a[0] * b[2] + a[1] * b[5] + a[2] * b[8],
        a[3] * b[0] + a[4] * b[3] + a[5] * b[6],
        a[3] * b[1] + a[4] * b[4] + a[5] * b[7],
        a[3] * b[2] + a[4] * b[5] + a[5] * b[8],
        a[6] * b[0] + a[7] * b[3] + a[8] * b[6],
        a[6] * b[1] + a[7] * b[4] + a[8] * b[7],
        a[6] * b[2] + a[7] * b[5] + a[8] * b[8],
    ]


def mat_local(x, y, rot_deg=0.0, sx=1.0, sy=1.0):
    r = math.radians(rot_deg or 0.0)
    c, s = math.cos(r), math.sin(r)
    return [c * sx, -s * sy, x, s * sx, c * sy, y, 0, 0, 1]


def apply(m, x, y):
    return m[0] * x + m[1] * y + m[2], m[3] * x + m[4] * y + m[5]


def mat_rotation_deg(m):
    return math.degrees(math.atan2(m[3], m[0]))


def mat_scale(m):
    sx = math.hypot(m[0], m[3])
    sy = math.hypot(m[1], m[4])
    return max(sx, 1e-6), max(sy, 1e-6)


def solidify_fill(fill):
    if not isinstance(fill, dict):
        return fill
    if "color" in fill:
        return {"color": fill["color"]}
    g = fill.get("gradient")
    if isinstance(g, dict):
        stops = g.get("stops") or []
        if stops:
            # Prefer mid stop if present
            c = stops[len(stops) // 2].get("color") or stops[0].get("color")
            if c:
                return {"color": c}
    return fill


ab = json.loads(Path(r"c:\projects\crumbo\art\rive\owl_11.scene.json").read_text(encoding="utf-8"))
groups = {g["id"]: g for g in ab.get("groups") or []}


def world_mat(gid: str | None):
    if not gid:
        return [1, 0, 0, 0, 1, 0, 0, 0, 1]
    chain = []
    cur = gid
    seen = set()
    while cur and cur not in seen:
        seen.add(cur)
        g = groups.get(cur)
        if not g:
            break
        chain.append(g)
        cur = g.get("parent")
    m = [1, 0, 0, 0, 1, 0, 0, 0, 1]
    for g in reversed(chain):
        m = mat_mul(
            m,
            mat_local(
                g.get("x") or 0,
                g.get("y") or 0,
                g.get("rotation") or 0,
                g.get("scaleX") if g.get("scaleX") is not None else 1,
                g.get("scaleY") if g.get("scaleY") is not None else 1,
            ),
        )
    return m


flat_shapes = []
for s in ab.get("shapes") or []:
    if s.get("id") in HIDE:
        continue
    if (s.get("opacity") or 1) == 0:
        continue
    parent = s.get("parent")
    m = world_mat(parent)
    m = mat_mul(
        m,
        mat_local(
            s.get("x") or 0,
            s.get("y") or 0,
            s.get("rotation") or 0,
            s.get("scaleX") if s.get("scaleX") is not None else 1,
            s.get("scaleY") if s.get("scaleY") is not None else 1,
        ),
    )
    rot = mat_rotation_deg(m)
    sx, sy = mat_scale(m)
    avg_s = (sx + sy) / 2

    ns: dict = {"id": s["id"], "type": s.get("type", "polygon")}
    if s.get("opacity") is not None and s.get("opacity") != 1:
        ns["opacity"] = s["opacity"]
    fill = solidify_fill(s.get("fill"))
    if fill:
        ns["fill"] = fill
    stroke = s.get("stroke")
    if isinstance(stroke, dict):
        st = copy.deepcopy(stroke)
        if "thickness" in st:
            st["thickness"] = float(st["thickness"]) * avg_s
        ns["stroke"] = st

    if s.get("type") == "ellipse":
        cx, cy = apply(m, 0, 0)
        ns["x"] = cx
        ns["y"] = cy
        ns["width"] = (s.get("width") or 10) * sx
        ns["height"] = (s.get("height") or 10) * sy
    else:
        ns["x"] = 0
        ns["y"] = 0
        new_subs = []
        for sp in s.get("subpaths") or []:
            pts = []
            for p in sp.get("points") or []:
                wx, wy = apply(m, p.get("x") or 0, p.get("y") or 0)
                np = {"x": wx, "y": wy}
                cub = p.get("cubic")
                if isinstance(cub, dict):
                    np["cubic"] = {
                        "rotation": (cub.get("rotation") or 0) + rot,
                        "inRotation": (cub.get("inRotation") or 0) + rot,
                        "inDistance": (cub.get("inDistance") or 0) * avg_s,
                        "outDistance": (cub.get("outDistance") or 0) * avg_s,
                    }
                pts.append(np)
            new_subs.append({"closed": sp.get("closed", True), "points": pts})
        ns["subpaths"] = new_subs
    flat_shapes.append(ns)

lx, ly = apply(world_mat("node227"), 0, 0)
rx, ry = apply(world_mat("node268"), 0, 0)
print(f"eyes L=({lx:.1f},{ly:.1f}) R=({rx:.1f},{ry:.1f})")

FACE = "#e8d0ae"
LASH = "#4a2f1c"


def crease(cid, cx, cy):
    return {
        "id": cid,
        "type": "polygon",
        "x": 0,
        "y": 0,
        "subpaths": [
            {
                "closed": False,
                "points": [
                    {
                        "x": cx - 15,
                        "y": cy,
                        "cubic": {"rotation": 0, "inRotation": 0, "inDistance": 0, "outDistance": 5},
                    },
                    {
                        "x": cx,
                        "y": cy + 5.5,
                        "cubic": {
                            "rotation": 0,
                            "inRotation": 180,
                            "inDistance": 8,
                            "outDistance": 8,
                        },
                    },
                    {
                        "x": cx + 15,
                        "y": cy,
                        "cubic": {"rotation": 0, "inRotation": 180, "inDistance": 5, "outDistance": 0},
                    },
                ],
            }
        ],
        "stroke": {"color": LASH, "thickness": 3.8, "cap": "round", "join": "round"},
    }


flat_shapes.extend(
    [
        {
            "id": "eyeL_lid",
            "type": "ellipse",
            "x": lx,
            "y": ly - 1,
            "width": 34,
            "height": 17,
            "fill": {"color": FACE},
        },
        {
            "id": "eyeR_lid",
            "type": "ellipse",
            "x": rx,
            "y": ry - 1,
            "width": 34,
            "height": 17,
            "fill": {"color": FACE},
        },
        crease("eyeL_crease", lx, ly + 1),
        crease("eyeR_crease", rx, ry + 1),
        {
            "id": "blush_l",
            "type": "ellipse",
            "x": lx - 24,
            "y": ly + 30,
            "width": 18,
            "height": 11,
            "opacity": 0.42,
            "fill": {"color": "#FFAB91"},
        },
        {
            "id": "blush_r",
            "type": "ellipse",
            "x": rx + 24,
            "y": ry + 30,
            "width": 18,
            "height": 11,
            "opacity": 0.42,
            "fill": {"color": "#FFAB91"},
        },
    ]
)

# Body shapes relative to center 250,250 — no parent (import wrapper)
body_shapes = []
for s in flat_shapes:
    s2 = copy.deepcopy(s)
    if s2.get("type") == "ellipse":
        s2["x"] = (s2.get("x") or 0) - 250
        s2["y"] = (s2.get("y") or 0) - 250
    else:
        for sp in s2.get("subpaths") or []:
            for p in sp.get("points") or []:
                p["x"] = (p.get("x") or 0) - 250
                p["y"] = (p.get("y") or 0) - 250
    body_shapes.append(s2)

body_out = Path(r"c:\projects\crumbo\art\rive\owl_sleep_body.scene.json")
body_out.write_text(json.dumps({"shapes": body_shapes}, separators=(",", ":")), encoding="utf-8")
print(f"wrote {body_out} shapes={len(body_shapes)} bytes={body_out.stat().st_size}")
