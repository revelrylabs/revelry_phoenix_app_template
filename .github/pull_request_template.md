connects to #[issue number]

#### Description: <!-- What changed? Why? -->

#### Reviewer don't-forgets:

- [ ] Test coverage feels appropriate, given potential risk
- [ ] We're not doubling down on already-bad code
- [ ] If there are web UI changes, they don't add anything that could be considered client-side page navigation (unless pre-approved as being necessary by another engineer)
- [ ] If there are web UI changes, they don't add any AJAX form submits (unless pre-approved as being necessary by another engineer)
- [ ] If there are any lint rules disabled, they are disabled per-line, and were (in the reviewer's judgment) appropriate to disable
- [ ] Any new environment variables used in the app are both documented and have been added to both staging and production environments already
- [ ] Potential race conditions are either inconsequential, or the code prevents them from occurring.
- [ ] If this is a UI change that called for screenshots/GIFs, in the reviewer's judgement, they were included
