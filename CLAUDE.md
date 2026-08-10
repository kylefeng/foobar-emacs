# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Emacs configuration (`~/.emacs.d`). Two architectural choices govern it, and both must be respected when editing:

## 1. Literate config — `init.org` is the source of truth

`init.el` and `early-init.el` are **generated, gitignored build artifacts** (see `.gitignore`). Never edit them directly — changes there get overwritten on the next tangle.

- Edit `init.org` only.
- Regenerate with `M-x org-babel-tangle` (`C-c C-v t`) while visiting `init.org`.
- Each source block's `:tangle` header decides where it lands:
  - `:tangle yes` → `init.el`
  - `:tangle ~/.emacs.d/early-init.el` → `early-init.el` (the dedicated early-init block at top)
- There is **no tangle-on-save hook** — tangle is always manual.

`init.org` is organized as top-level sections: Startup Config → Evil Mode → Enhancement (Ivy/Company/etc.) → Programming (per-language) → Org → Keyboard Bindings → Hydra → AI. `init.el` mirrors this section order.

## 2. Package management — borg (git submodules under `lib/`)

Packages are called **drones** and live as git submodules in `lib/` (85 of them, registered in `.gitmodules`). They are NOT installed via package.el/MELPA — `package-enable-at-startup` is explicitly `nil`.

- Bootstrap borg on a fresh clone: `make bootstrap-borg` (clones `lib/borg`, then `borg-initialize` runs in early-init).
- Add a package: `M-x borg-assimilate RET <name> RET` — clones into `lib/`, adds the submodule, builds.
- Update all drones: `M-x borg-update`
- Remove a drone: `M-x borg-remove`
- Byte-compile / rebuild: the `Makefile` includes `lib/borg/borg.mk`, which provides the standard borg build targets (`make build`, etc.) once borg is bootstrapped.

`borg-rewrite-urls-alist` rewrites SSH clone URLs to HTTPS, so most `.gitmodules` entries are `https://`.

## Layout notes

- `init.org` / `init.el` — the config (see literate-config rule above).
- `lib/` — borg drones (git submodules). Treat as vendored upstream code; don't edit in place.
- `lisp/env.el` — helper loaded by `generate-env-file` / `doom-load-envvars-file` to inject shell env (PATH, etc.) into Emacs. `env` (gitignored) is the generated output.
- `custom.el` (gitignored) — Emacs writes `customize`-driven settings here; not hand-edited.
- `snippets/` — yasnippet snippets.

## Conventions in the config

- `lexical-binding: t` is the default (set in early-init and each tangled block).
- Inline comments are mixed Chinese/English; when adding comments, match the surrounding block's language. (Per global rules, prefer English for consistency.)
- Platform branches use the `*is-mac*` / `*is-linux*` / `*is-windows*` constants defined in the "Constants and Variables" block.
- Several sections fork settings from `minimal-emacs.d` (clearly marked `START fork` / `END fork`) — preserve those markers if editing within them.
