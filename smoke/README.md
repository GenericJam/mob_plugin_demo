# Smoke flows

UI flows recorded with [agent-device](https://github.com/callstack/agent-device)
and replayed by `mix mob.smoke` (mob_dev 0.7.6+). Each flow relaunches the app,
drives it through real taps, and asserts what the screen shows. `mob.smoke`
also checks the app's own diagnostics (`Mob.Diag.health/0`): a store that lost
data or reset fails the run, and the receipt count shows the taps reached the
app (mob 0.9.7+).

| Flow | Checks |
|---|---|
| `dice.ad` | Home → Roll Dice → roll once ("Last 1 rolls") → back. Three receipts. |
| `kv_browser.ad` | Home → KV Browser, the in-repo plugin: its bundled-font line renders; tapping `beta` opens the detail screen ("value: second letter"); Back returns to the list. |

## Running

Install and start the app on the device first (`mix mob.deploy --native …`),
then:

```bash
mix mob.smoke --device <serial-or-udid>
```

**iOS simulator:** until MOB-139 is fixed, an app launched by anything other
than mob_dev binds its BEAM distribution to port 9101 and dies silently if
another mob simulator app holds it. The flows relaunch the app, so give it a
free port:

```bash
SIMCTL_CHILD_MOB_DIST_PORT=9555 mix mob.smoke --device <simulator-udid>
```

A physical iPhone also needs agent-device's runner signed; see mob_dev's README
("Smoke flows on devices").

## Recording

Record with an absolute `--save-script` path and `--relaunch`, and assert with
`wait text`:

```bash
agent-device open com.example.mob_plugin_demo --udid <id> --relaunch \
  --session rec --save-script "$PWD/smoke/<name>.ad"
agent-device wait text "Roll Dice" 30000 --session rec
agent-device press 'label="Roll Dice"' --session rec --settle
agent-device close --session rec --save-script
```

These flows have their `# agent-device:target-v1` identity comments removed.
On the simulator the recorded identity (ancestry, position) did not match on
replay even when the selector did, and the replay refused the step. The
selectors start with mob's own tap ids (`id="open_dice"`), which are stable.
