# @ISSUE
 - I: resource creation fails with undefined method 'join' for 2:fixnum

# @TODO
  - T: DASHBOARD:
    - refresh 30s (stop refresh/resume refresh)
    - kiosk mode (reduce sidebar to icons) if 15s idle
    - refresh login button (gem func)
    - Clocks: UTC, US West, US East, APAC (digital)
    - Dashboard split into two divs: Checks (left), Alerts (right)
    - All users:
      - Graph for checks in the last hour (group events by name where kind = check)
      - Checks currently info(white)/warn(yellow)/crit(red) (sorted by severity DESC, group by see above)
      - Checks failing (name: check_failed)
      - Graph alerts sent in the last hour
      - Last 5 Alerts sent
    - Admins:
      - Datasources without workers
      - Workers that did not respond within the last 120s


  - T: team_id in header after user info (Team id: 1) (needs to be in payload first)
  - T: silence this alert for x seconds function (provided by gem)
  - T: expiration warning in header (15m before logout)
  - T: settings (to enable pw change)
  - T: about (version, github urls, contributors, license)
  - T: konami code (unicorn theme?!)
  - T: maybe somehow info texts on inputs (explaining shit)
  - T: add rake-attack (with redis_store) to web (rate limit logins here as well!)
  - T: remove edit/create buttons if you are not allowed to do that (mapping role from payload against action)
  - T: on relation fields, query for the select options (e.g. on checks, field datasource: Cafmal::Datasource.list)

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
  - I: password digest as datetime, should be string (needed for manual admin reset of user pw)
  - T: show error page if api cannot be reached
  - T: view events: filter for timeframe (age, duration, e.g. show me 7200s ago, the events for 3600s)
  - T: filter deleted events by default (checkbox on top of table to enable "show deleted")
  - T: if fieldname_includes "severity": input select info, warning, critical, error
  - T: alert creation fails with "undefined method join for 1:Fixnum" form.html.haml:5
      this might also happen on other resources with fixnums. The alert is created in API
  - T: error handling is a mess. rely on http status codes.
  - T: checkboxes are not send, if not marked on edit/create (also leads to failing changes because booleans are missing)
  - I: login form says "save ..."
  - T: delete function (provided by gem)
  - T: doclink in checks
  - I: RBAC user.id==team.id does not work on API (grrr!), users can see alerts from different teams

# @FARFARAWAY
  - F: import/export client
  - F: Availablity exporter
  - F: more datasource types
  - F: ticket alert
  - F: combine checks (if check avgRequests fails && freeMemory fails: create event)
