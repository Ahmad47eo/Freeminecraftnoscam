#!/usr/bin/env python3
"""Create a deterministic Horizon .hnmod source bundle."""
import hashlib
import json
from pathlib import Path
import tomllib
import zipfile

ROOT = Path(__file__).resolve().parents[1]
GAME = "26.3"


def package():
    compat = json.loads((ROOT / "compatibility.json").read_text())
    manifests = sorted((ROOT / "mixins").glob("*/horizon-mixin.toml"))
    if len(manifests) != 1:
        raise SystemExit("Expected exactly one mixin bundle.")
    bundle = manifests[0].parent
    mixin = tomllib.loads(manifests[0].read_text())
    mod = mixin["mod"]
    if bundle.name != mod["id"]:
        raise SystemExit("The bundle folder must match the mod id.")
    if mixin.get("compatibility", {}).get("horizon_revision") != compat["horizon_revision"]:
        raise SystemExit("The Horizon revision pins do not match.")

    manifest = {
        "schema": 1,
        "id": mod["id"],
        "version": mod["version"],
        "game": GAME,
        "horizon": compat["horizon_revision"],
        "mixins": compat["horizon_mixins_revision"],
    }
    files = {
        "horizon-native.json": (json.dumps(manifest, indent=2, sort_keys=True) + "\n").encode()
    }
    for path in sorted(bundle.iterdir()):
        if path.is_file() and path.suffix in (".rs", ".toml"):
            files[path.relative_to(ROOT).as_posix()] = path.read_bytes()

    out = ROOT / "target" / f"{mod['id']}-{mod['version']}.hnmod"
    out.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        for name, content in sorted(files.items()):
            info = zipfile.ZipInfo(name, (2026, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, content)

    digest = hashlib.sha256(out.read_bytes()).hexdigest()
    print(json.dumps({"file": str(out), "size": out.stat().st_size, "sha256": digest}, indent=2))


if __name__ == "__main__":
    package()
