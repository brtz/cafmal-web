# @ISSUE
 - I: login form says "save ..."
 - I: alert creation fails with "undefined method join for 1:Fixnum" form.html.haml:5

      this might also happen on other resources with fixnums. The alert is created in API
 - I: checkboxes are not send, if not marked on edit/create (also leads to failing changes because booleans are missing)
 - I: password digest as datetime, should be string (needed for manual admin reset of user pw)
 - I: error handling is a mess. rely on http status codes.

# @TODO

 - T: if fieldname_includes "severity": input select info, warning, critical, error
 - T: delete function (provided by gem)
 - T: filter deleted events by default (checkbox on top of table to enable "show deleted")
 - T: view events: filter for timeframe (age, duration, e.g. show me 7200s ago, the events for 3600s)
 - T: team_id in header after user info (Team id: 1) (needs to be in payload first)
 - T: silence this alert for x seconds function (provided by gem)
 - T: expiration warning in header (15m before logout)
 - T: settings (to enable pw change)
 - T: about (version, github urls, contributors, license)
 - T: current time in header (utc!)
 - T: konami code (unicorn theme?!)
 - T: maybe somehow info texts on inputs (explaining shit)

# @OUTOFSCOPE
 - T: sidekiq workers
 - T: sidekiq alerters
 - T: cli
 - T: Dockerfiles
 - T: full compose example
 - T: manual
 - T: product page
 - T: maybe travis ci for API

# @DONE
 - T: doclink in checks
 - I: RBAC user.id==team.id does not work on API (grrr!), users can see alerts from different teams

# @FARFARAWAY
 - F: import/export client
 - F: Availablity exporter
 - F: more datasource types
 - F: ticket alert
 - F: combine checks (if check avgRequests fails && freeMemory fails: create event)
