# Local Mac 1point3acres Checkin

This setup runs only the 1point3acres checkin from your own Mac. It does not use GitHub Actions, CircleCI, or Cloudflare Worker for scheduling.

## Files

- `local/run-onepoint3acres.sh`: creates a local Python virtual environment and runs the checkin.
- `.env.local.example`: local secret template. Copy it to `.env` and fill it on your Mac.
- `local/com.meixu.cloudcheckin.onepoint3acres.plist.example`: macOS launchd template for daily scheduling.

## One-time setup

```bash
git clone https://github.com/Meixu-Chen/CloudCheckin.git
cd CloudCheckin
cp .env.local.example .env
```

Edit `.env` locally and fill:

```bash
ONEPOINT3ACRES_COOKIE='your cookie'
TWOCAPTCHA_APIKEY='your 2captcha api key'
```

`TELEGRAM_TOKEN` and `TELEGRAM_CHAT_ID` can stay empty.

## Test once

```bash
bash local/run-onepoint3acres.sh
```

The script writes logs to `logs/onepoint3acres.log`.

## Run every day on macOS

The template is set to run at 10:00 local Mac time every day.

```bash
mkdir -p ~/Library/LaunchAgents
cp local/com.meixu.cloudcheckin.onepoint3acres.plist.example ~/Library/LaunchAgents/com.meixu.cloudcheckin.onepoint3acres.plist
sed -i '' "s#__REPO_PATH__#$(pwd)#g" ~/Library/LaunchAgents/com.meixu.cloudcheckin.onepoint3acres.plist
launchctl unload ~/Library/LaunchAgents/com.meixu.cloudcheckin.onepoint3acres.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.meixu.cloudcheckin.onepoint3acres.plist
```

To run it immediately without waiting for the next scheduled time:

```bash
launchctl start com.meixu.cloudcheckin.onepoint3acres
```

To stop the schedule:

```bash
launchctl unload ~/Library/LaunchAgents/com.meixu.cloudcheckin.onepoint3acres.plist
```

## Notes

- Keep `.env` local. Do not commit it.
- If the run fails because the cookie expired, refresh the cookie in `.env`.
- If captcha or risk control fails, do not add aggressive retries. Let it fail and inspect the log.
