Tournament Manager (Ruby on Rails)

Tournament Manager is a Rails 7 backend for organizing sports tournaments. It includes models for Tournaments, Teams, Players, and Games, defining relationships via ActiveRecord associations. Business logic handles tournament progression, game outcomes, and stat aggregation. Model-level validations enforce data integrity (e.g. presence/uniqueness of key fields). Advanced Rails features like enum attributes are used for status codes and roles, mapping symbolic states to integers with generated query methods.

Key Features:

* Tournament Formats: Supports single-elimination (knockout) and round-robin formats, including double round-robin (each team plays all others twice). The scheduling logic automatically generates matchups based on the chosen format and number of teams.

* Automated Brackets: In knockout play, the loser of each game is immediately eliminated and the winner is programmatically seeded into the next round. Successive rounds are filled automatically until a final champion is determined.

* Authentication & Authorization: Uses Devise for secure user auth (with Google OAuth2 integration). Pundit provides an object-oriented authorization layer, with policy classes (e.g. TournamentPolicy) that govern who can view or modify each resource.

* Background Jobs & Mailers: Employs Sidekiq for background processing (configured as the :sidekiq ActiveJob queue adapter). Long-running tasks—such as sending emails or recalculating standings—are enqueued as jobs. Emails (via ActionMailer) use deliver_later, causing Rails to queue them through Sidekiq.

* Stat Tracking: A SingleStat model records individual game statistics (goals, assists, cards, etc.). Callbacks update aggregate stats after each game, automatically computing team and player totals. This keeps leaderboards and box scores in sync without manual intervention.

* Data Integrity: Strong ActiveRecord validations guard against invalid data at the model level. Enumerated fields (enum) define allowed values (e.g. match result states, tournament stages), yielding convenient query scopes and predicate methods. This combination of enums and validations ensures that only valid, well-formed records are persisted.

Architecture and Domain Logic

The core domain includes Tournaments, Teams, Players, and Games. For example, a Tournament has many Games and participating teams, and a Game belongs to two teams and records a winner. ActiveRecord associations (has_many, belongs_to) are used extensively to model these relations. Tournament scheduling is implemented in service objects or model callbacks that generate game rounds from the list of teams. As each game is scored, its winner is automatically advanced into the next round’s fixture (standard single-elimination logic), with losers eliminated from further play.

Authentication and Authorization Details

User authentication is handled by Devise. In addition to standard database logins, Google OAuth2 is integrated via OmniAuth (omniauth-google-oauth2), allowing users to sign in with Google accounts for a seamless login experience. Authorization is enforced with Pundit. For each model (e.g. Game, Tournament), corresponding policy classes define methods that check the current user’s role and permissions. This policy-driven approach cleanly separates access rules from business logic, ensuring only authorized users can perform sensitive actions (like editing a tournament or entering match scores).

Asynchronous Processing

Background tasks are managed with Sidekiq. The Rails config sets config.active_job.queue_adapter = :sidekiq so all ActiveJob jobs run in Sidekiq workers. For instance, when a game result is submitted, an ActiveJob might enqueue tasks to recalculate standings or send notifications. Email notifications (match reminders, results) are sent with ActionMailer using deliver_later, which queues the email in Sidekiq rather than sending synchronously. This asynchronous design prevents slow operations from blocking web requests and improves overall responsiveness.
