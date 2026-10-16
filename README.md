# TaskSphere

A responsive, local-first productivity dashboard inspired by the supplied TaskSphere reference. The project is plain HTML, CSS, and JavaScript. It needs no build step.

## Run it

Open `index.html` in a modern browser. For the most predictable behavior (especially imports, clipboard sharing, and Supabase auth), serve this directory from a local static web server such as VS Code Live Server or `python -m http.server 8000`, then open `http://localhost:8000`.

All core interactions work without an account. Data is stored in this browser's local storage. Export a JSON backup regularly if you use local mode. Clearing browser storage clears this local copy.

## Supabase cloud setup

Cloud sync is optional and is not connected until you complete these steps:

1. Create a Supabase project on a plan that suits you.
2. In the Supabase dashboard, open **SQL Editor**, paste the contents of `supabase.sql`, and run it. This creates `public.tasksphere_profiles`, enables and forces row-level security, and grants authenticated users access only to their own profile row.
3. In `script.js`, replace `SUPABASE_URL` with the project's Project URL and `SUPABASE_ANON_KEY` with its publishable/anon key. These are browser-facing values. **Never put a service-role/secret key in this static app.**
4. Serve the app over `http://localhost` or HTTPS. In Supabase **Authentication → URL Configuration**, allow the local URL and your deployed static-site URL as redirect/site URLs. Configure email confirmation and SMTP settings there if you want to use email sign-up beyond the provider defaults.
5. Open **Account & sync**, create an account or sign in, and verify the sidebar status says **Synced**. Test with a second browser/device only after signing in there too.

The app upserts one JSON profile per authenticated user. It contains quests and subtasks, XP/rank input, activity history, focus minutes, companion energy, boss health/week, shield state, themes, bounty claims, and timer settings. Supabase Auth stores credentials; the database policy binds each row to `auth.uid()`. A device keeps its local copy when cloud requests fail, and a later edit or reconnect retries sync. The current implementation is last-write-wins per profile, so avoid editing the same account simultaneously on multiple devices. Cloud sync has not been run against a configured project in this deliverable.

## Included features

- Quest creation with category, priority/XP, estimate, due date, and repeat interval; search, filter, sort, inline rename, drag reorder, delete, and subtasks.
- Linked Pomodoro/focus timer with 15/25/45/60 minute presets, pause/reset, break cycle, focus XP, and tracked minutes.
- Companion growth stages, mood/energy, energy decay after offline days, feeding, and task/focus reactions.
- Weekly procrastination boss with animated strikes and daily counterattacks, daily three-quest bounty, automatic streak shield, activity heatmap with month/year views, rank progression, and completed quest log.
- Gold earned from quests and bounties; four level-gated, gold-purchasable themes; command palette (Ctrl/Cmd+K); JSON export/import; and shareable/downloadable PNG progress card.
- Local-first storage with a durable latest-snapshot sync queue, retry on reconnect, and optional Supabase Auth plus profile sync.
- Optional synthesized interface sounds with a one-tap mute control, distinct error/reward/boss cues, reduced-motion support, animated quest and reward feedback, and responsive layouts with mobile safe-area spacing.

## Notes and limitations

- This is a static client app. XP and game state are client-controlled; the database's RLS protects which account can access a profile, but it does not make XP tamper-proof. Use a trusted server/Edge Function with server-side validation if rewards or competitive rankings have real value.
- Offline changes persist locally and the latest full profile snapshot remains queued for retry after reconnect; there is no per-operation merge or concurrent multi-device conflict resolution.
- The share card copies a text summary. Supabase sync, authentication email delivery, and production deployment require the setup steps above and have not been claimed or verified here.
- Static CDN dependencies (Supabase JS and Font Awesome) and Google Fonts need an internet connection. Core app styling and behavior still render if the font/icon CDNs are unavailable.
