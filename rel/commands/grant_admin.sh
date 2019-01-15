#!/bin/sh

release_ctl eval --mfa "AppTemplate.ReleaseTasks.grant_admin/1" --argv -- "$@"
