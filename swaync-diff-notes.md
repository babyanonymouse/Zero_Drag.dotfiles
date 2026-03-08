# SwayNC Configuration Comparison

Comparing `.config/swaync/` (this repo, `fixes` branch) vs `config/swaync/` ([JwpAT/hypr](https://github.com/JwpAT/hypr)).

---

## `config.json` differences

| Setting | This repo (fixes) | JwpAT/hypr |
|---|---|---|
| `control-center-margin-top` | `0` | `7` |
| `control-center-margin-right` | `0` | `7` |
| `notification-body-image-width` | `200` | `500` |
| `fit-to-screen` | `true` | `false` |
| `control-center-width` | `500` | `350` |
| `notification-window-width` | `500` | `350` |

### Scripts

- **This repo:** Placeholder scripts only (`example-script` echoes a string, `example-action-script` echoes on action). Neither does anything useful.
- **JwpAT/hypr:** Has a real `screenshot-action-script` that runs `~/.config/scripts/swaync-shot.sh open` when a screenshot notification is actioned.

### Notification visibility

- **This repo:** Mutes `example.app.id` at `Normal` urgency (placeholder, does nothing).
- **JwpAT/hypr:** Mutes `Spotify` at `Low` urgency (suppresses Spotify's low-priority notifications).

### Widgets

- **This repo:** `["inhibitors", "title", "dnd", "notifications"]`
  - Has inhibitors widget and DND toggle.
  - No mpris or quick-action buttons.
- **JwpAT/hypr:** `["mpris", "title", "notifications", "buttons-grid"]`
  - Has mpris media player widget at the top.
  - Has a buttons-grid at the bottom for quick actions.
  - No inhibitors widget or DND widget (DND is instead a button in buttons-grid).

### buttons-grid

- **This repo:** `buttons-per-row: 7`, one WiFi toggle using `nmcli`.
- **JwpAT/hypr:** `buttons-per-row: 6`, six functional buttons:
  1. 🎨 Hyprpicker color picker (closes panel, picks color, copies to clipboard, sends notification)
  2. 📸 Screenshot shortcut (`swaync-shot.sh notif`)
  3. 📶 WiFi (opens `nmtui` in Kitty)
  4. 🦷 Bluetooth (opens `bluetuith` in Kitty)
  5. ☕ Caffeine toggle (`caffeine.sh`)
  6. 🔕 DND toggle (`swaync-client --toggle-dnd`)

---

## `style.css` differences

### This repo

- Imports a local `mocha.css` file that defines Catppuccin Mocha palette as GTK `@define-color` variables.
- ~162 lines of fully hand-written CSS covering every notification component.
- Uses GTK-style `@base`, `@surface0`, `@surface1`, `@text`, `@subtext0`, `@subtext1`, `@crust`, `@red`, `@blue` color references.
- No mpris or buttons-grid styling (those widgets aren't used).
- `close-button` uses `border-radius: 8px` (square-ish).
- `notification-content` uses a `2px solid @surface1` border.
- `control-center` uses `background: @crust` with a `2px solid @surface1` border and `border-radius: 16px`.

### JwpAT/hypr

- `style.css` is a single line: `@import 'themes/catppuccin.css';` — all styling lives in the theme file.
- `themes/catppuccin.css` uses CSS custom properties (`:root { --cc-bg: ...; --noti-border-color: ...; }`) instead of GTK `@define-color` variables, which is more portable across CSS renderers.
- Also provides GTK `@define-color` fallbacks for backwards compatibility.
- Includes mpris widget styling: scaled down (`transform: scale(0.8)`), custom artist/title/button styles.
- Includes buttons-grid styling: dark background (`#11111b`), peach border/color (`#fab387`), scale-on-hover effect.
- Has notification image styling: `object-fit: cover`, full width/height fill, rounded corners.
- `close-button` uses `border-radius: 100%` (circular).
- Notification rows use padding/background on `.notification-background` (inner container) rather than on the outer row.
- Modular structure: theme variants (`catppuccin.css`, `transparent.css`, `ultradark.css`) are swappable by changing one import line.

---

## Summary of notable gaps in this repo vs JwpAT/hypr

1. **No functional scripts** — scripts section is all placeholders.
2. **No mpris widget** — no media player controls in the notification center.
3. **No quick-action buttons-grid** — the one wifi button is a stub compared to JwpAT's 6-button layout.
4. **No DND as a button** — uses a separate `dnd` widget instead of integrating it into buttons-grid.
5. **Wider panel** — 500px vs 350px; `fit-to-screen: true` means it may stretch on large monitors.
6. **No margin offset** — panel sits flush against the screen edge instead of floating with a 7px gap.
7. **Monolithic CSS** vs JwpAT's modular theme system with swappable theme files.
8. **No notification image styling** — images in notifications won't fill their icon box neatly.
9. **Notification visibility is a placeholder** — Spotify notifications aren't suppressed.
