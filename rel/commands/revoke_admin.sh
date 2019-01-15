#!/bin/sh

release_ctl eval --mfa "AppTemplate.ReleaseTasks.revoke_admin/1" --argv -- "$@"
