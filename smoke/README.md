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

Needs mob ≥ 0.9.9 and mob_dev ≥ 0.7.8. Older iOS builds can't be reached after
a flow relaunches the app (MOB-139, MOB-348), so health goes unchecked.

**Physical iPhone:** agent-device signs its runner with automatic signing.
Start its daemon with your team and a bundle ID your team profile covers:

```bash
export AGENT_DEVICE_STATE_DIR=/tmp/ad-$USER \
  AGENT_DEVICE_IOS_TEAM_ID=<team id> \
  AGENT_DEVICE_IOS_BUNDLE_ID=com.<you>.agentdevice.runner
mix mob.smoke --device <iphone-udid>
```

The first run asks for Touch ID or the passcode on the phone, to enable UI
automation. Approve it there; unattended runs time out until you do.

`kv_browser.ad` scrolls the home screen to the bottom first: on a small phone
(iPhone SE) the KV Browser button is below the fold.

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
