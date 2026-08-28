# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Emacs configuration (`~/.emacs.d`). Two architectural choices govern it, and both must be respected when editing:

## 1. Module layout — hand-written `.el` files under `lisp/`

The config is split into one `.el` file per feature area, loaded in dependency order by a thin root `init.el`. **`init.el`, `early-init.el`, and `lisp/init-*.el` are hand-maintained source** — edit them directly. They are tracked in git (no longer generated, no longer gitignored).

- `init.el` — the loader: prepends `lisp/` to `load-path`, then `require`s each module in order. Add new modules here.
- `early-init.el` — runs before `init.el` (Emacs convention): GC tuning, the `minimal-emacs.d` fork, borg bootstrap, and `custom-file` setup.
- `lisp/init-<section>.el` — one module per feature area.

**Load order is load-bearing.** `init-startup` must come first — it defines the constants (`*is-mac*` etc.) and utilities (`foobar/add-auto-mode`, proxy helpers) that later modules reference. Preserve the order when adding a module.

Modules (each ends with `(provide 'init-<name>)`):

| Module | Contents |
|---|---|
| `init-startup` | benchmark, constants, env loading, base settings, utils |
| `init-ui` | modeline, theme, fonts, icons |
| `init-evil` | evil, evil-surround, evil-snipe |
| `init-enhancement` | which-key, ivy/counsel/swiper, company, undo-tree, multiple-cursors, helpful |
| `init-programming` | yasnippet, projectile/treemacs, magit, lsp-mode, per-language modes |
| `init-org` | org-mode, org-roam |
| `init-keybindings` | global key bindings |
| `init-hydra` | hydra menus |
| `init-misc` | misc utilities |
| `init-ai` | gptel |

`init.org.legacy` is the retired literate source (kept for reference). **Do not `org-babel-tangle` it** — doing so would overwrite the hand-written `init.el` / `early-init.el`.

## 2. Package management — borg (git submodules under `lib/`)

Packages are called **drones** and live as git submodules in `lib/` (85 of them, registered in `.gitmodules`). They are NOT installed via package.el/MELPA — `package-enable-at-startup` is explicitly `nil`.

- Bootstrap borg on a fresh clone: `make bootstrap-borg` (clones `lib/borg`, then `borg-initialize` runs in early-init).
- Add a package: `M-x borg-assimilate RET <name> RET` — clones into `lib/`, adds the submodule, builds.
- Update all drones: `M-x borg-update`
- Remove a drone: `M-x borg-remove`
- Byte-compile / rebuild: the `Makefile` includes `lib/borg/borg.mk`, which provides the standard borg build targets (`make build`, etc.) once borg is bootstrapped.

`borg-rewrite-urls-alist` rewrites SSH clone URLs to HTTPS, so most `.gitmodules` entries are `https://`.

## Layout notes

- `init.el` — module loader (entry point).
- `early-init.el` — early init (GC, borg bootstrap, custom-file).
- `lisp/init-*.el` — the config modules (see table above).
- `lisp/env.el` — helper loaded by `generate-env-file` / `doom-load-envvars-file` to inject shell env (PATH, etc.) into Emacs. `env` (gitignored) is the generated output.
- `lib/` — borg drones (git submodules). Treat as vendored upstream code; don't edit in place.
- `custom.el` (gitignored) — Emacs writes `customize`-driven settings here; not hand-edited.
- `snippets/` — yasnippet snippets.
- `init.org.legacy` — retired literate source; do not tangle.

## Conventions in the config

- `lexical-binding: t` is set in every `.el` file via the `;;; file.el --- ... -*- lexical-binding: t; -*-` header line. Keep it when adding files.
- Every module ends with `(provide 'init-<name>)` so the loader can `require` it (fail-fast if a module is broken or missing).
- Inline comments are mixed Chinese/English; when adding comments, match the surrounding block's language. (Per global rules, prefer English for consistency.)
- Platform branches use the `*is-mac*` / `*is-linux*` / `*is-windows*` constants defined in `lisp/init-startup.el`.
- Several spots fork settings from `minimal-emacs.d` (clearly marked `START fork` / `END fork`) — preserve those markers if editing within them.
