#!/bin/sh

release_ctl eval --mfa "AppTemplate.ReleaseTasks.migrate/0" -- "$@"
