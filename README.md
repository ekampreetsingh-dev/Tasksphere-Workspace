# TaskSphere

A responsive, local-first productivity dashboard inspired by the supplied TaskSphere reference. The project is plain HTML, CSS, and JavaScript. It needs no build step.

## Run it

Open `index.html` in a modern browser. For the most predictable behavior (especially imports, clipboard sharing, and Supabase auth), serve this directory from a local static web server such as VS Code Live Server or `python -m http.server 8000`, then open `http://localhost:8000`.

All core interactions work without an account. Data is stored in this browser's local storage. Export a JSON backup regularly if you use local mode. Clearing browser storage clears this local copy. The first-run welcome flow offers a blank board or clearly labeled demo quests; manage demo quests in **Account & preferences**.

## Install and offline use

The project includes a web app manifest, icon, and service worker. Serve it on localhost or HTTPS, then use your browser's **Install app** option to add it to the desktop or home screen. After the first successful visit, the app shell can reopen offline; CDN fonts, icons, and Supabase requests still need internet. Offline changes remain in local storage and queue for later sync.

## Supabase cloud setup

Cloud sync is optional and is not connected until you complete these steps:

1. Create a Supabase project on a plan that suits you.
2. In the Supabase dashboard, open **SQL Editor**, paste the contents of `supabase.sql`, and run it. This creates `public.tasksphere_profiles`, enables and forces row-level security, and grants authenticated users access only to their own profile row.
3. In `script.js`, replace `SUPABASE_URL` with the project's Project URL and `SUPABASE_ANON_KEY` with its publishable/anon key. These are browser-facing values. **Never put a service-role/secret key in this static app.**
4. Serve the app over `http://localhost` or HTTPS. In Supabase **Authentication → URL Configuration**, allow the local URL and your deployed static-site URL as redirect/site URLs. Configure email confirmation and SMTP settings there if you want to use email sign-up beyond the provider defaults.
5. Open **Account & sync**, create an account or sign in, and verify the sidebar status says **Synced**. Test with a second browser/device only after signing in there too.

The app upserts one JSON profile per authenticated user. It contains quests and subtasks, XP/rank input, activity history, focus minutes, companion energy, boss health/week, shield state, themes, bounty claims, and timer settings. Supabase Auth stores credentials; the database policy binds each row to `auth.uid()`. A device keeps its local copy when cloud requests fail, and a later edit or reconnect retries sync. The current implementation is last-write-wins per profile, so avoid editing the same account simultaneously on multiple devices. The SQL row policies were inspected, but live sign-up/sign-in, sync failure, reconnect, and cross-device recovery have not been tested against your Supabase project.

## Included features

- Guided first-run welcome, quick-add button and N shortcut, sample demo quests with safe clear/undo, and a unified quest board with category, priority/XP, estimate, due date, repeat interval, search, keyboard-accessible filters, sorting, inline rename, drag reorder, undoable deletion/completion, and subtasks. Due-soon and overdue states are labeled clearly.
- Linked Pomodoro/focus timer with 15/25/45/60 minute presets, pause/reset, accurate background-tab timing, a locally saved session deadline that restores after closing/reopening the page, focus XP, and tracked minutes; optional gentle minute chime, breathing cue, and distraction-free blurred focus mode with Escape to exit.
- Companion growth stages, mood/energy, energy decay after offline days, feeding, and task/focus reactions.
- Weekly procrastination boss with animated strikes and daily counterattacks, daily three-quest bounty, automatic streak shield, activity heatmap with month/year views, rank progression, and completed quest log.
- Gold earned from quests and bounties; four level-gated, gold-purchasable themes; command palette (Ctrl/Cmd+K); JSON export/import; and shareable/downloadable PNG progress card.
- Local-first storage with a durable latest-snapshot sync queue, retry on reconnect, and optional Supabase Auth plus profile sync.
- Optional synthesized interface sounds with a one-tap mute control and adjustable volume, distinct error/reward/boss cues, user-selectable animation intensity, reduced-motion support, animated quest/reward feedback, and responsive layouts with mobile safe-area spacing.
- Installable web app manifest, custom app icon, and a service-worker-cached offline shell.

## Notes and limitations

- This is a static client app. XP and game state are client-controlled; the database's RLS protects which account can access a profile, but it does not make XP tamper-proof. Use a trusted server/Edge Function with server-side validation if rewards or competitive rankings have real value.
- Offline changes persist locally and the latest full profile snapshot remains queued for retry after reconnect; there is no per-operation merge or concurrent multi-device conflict resolution. Focus sessions use a same-browser saved deadline and completion marker to recover after reload/close and avoid ordinary cross-tab duplicate rewards.
- The share card copies a text summary. Focus sessions continue against a saved local deadline while the app is closed; the browser does not issue an alert while fully closed, but the session is credited when the app is reopened. Supabase sync, authentication email delivery, and production deployment require the setup steps above and have not been claimed or verified here.
- Static CDN dependencies (Supabase JS and Font Awesome) and Google Fonts need an internet connection. Core app styling and behavior still render if the font/icon CDNs are unavailable.
