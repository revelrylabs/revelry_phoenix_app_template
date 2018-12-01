# Production Release Checklist

**NOTE**: Please remember to check that all relevant items whenever a production release occurs

## General

* [x] This checklist is checked into the project repo as RELEASE_CHECKLIST.md. You're not currently just reading it off of the Wiki.

## Heroku

* [ ] Dyno tier is "Professional"
* [ ] Postgres tier is "Standard" (typical) or "Premium" (atypical)
* [ ] Postgres backups are turned on
* [ ] NewRelic is "Wayne" or higher
* [ ] Papertrail is "Choklad" or higher
* [ ] Rollbar project created
* [ ] All needed environment variables set
* [ ] Dead Man's Snitch is "The Lone Snitch" or higher
* [ ] Dead Man's Snitch is configured to check at least daily (Change this item if schedule should be different)
* [ ] Dead Man's Snitch sends alert emails to support@revelry.co
