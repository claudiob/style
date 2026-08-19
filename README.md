# Coding guidelines

Three tiers: what holds in any language, what holds in Ruby, what holds in a Rails
app. A rule lives in the widest tier it is true in.

**[Principles](#principles)**

**[Ruby](#ruby)** · [Methods](#methods) · [Objects](#objects) · [Files and comments](#files-and-comments) ·
[Layout](#layout) · [RuboCop](#rubocop) · [Gems](#gems)

**[Rails](#rails)** · [The Rails Way](#the-rails-way) · [Database](#database) · [Models](#models) ·
[Queries](#queries) · [Views](#views) · [System tests](#system-tests) · [Config](#config)

---

# Principles

True whatever the language.

### Encrypt personal data

Databases are compromised—don’t store your customers’ phone, email, last name, street in plain text.
By default, don’t include them in tables that show many records at once.
When displayed on a screen, mask personal data until asked for.

### Code optimistically

Write code that is a pleasure to read.
Writing something new? Look for similar code nearby first.
Never leave a method nobody calls.
Never rescue an error that has not occurred.

### Tell, don’t ask through

The law of Demeter: call methods on yourself and what you hold, not on what those hand back.
Two calls on the same object in one expression are the tell: the second is nearly always unneeded.

### Say it short

Between two versions carrying the same meaning, pick the shorter name.
Your fingers will thank you every time they will type a model, controller, route, test.
Cut the restatement, don’t explain why a rule is a good idea.

### Write good English

Respect acronyms and inflections: API, PIN, ZIP code, OpenAI.
Don’t Titleize Sentences and favor curly quotes as apostrophes.
Prefer color, license, normalize over colour, licence, normalise.

### Don’t overtest

A test that can be deleted while coverage holds is a test to delete.
Never test code you don’t own: libraries and frameworks are already tested.
Probe public interfaces, not private methods, nor the data.
Fixtures are minimal and explicit. Specs are independent and order-agnostic.

### Communicate through git

Small, focused commits. Imperative subjects ('Add', not 'Added') and *why* in the body.
Don’t code in main: create a branch with a short name using lowercase and underscores.
No trailers naming who wrote a commit: git already has an author field for that.
Keep a linear history. Never `git merge` or `--no-ff`: `git rebase main` and fix the conflicts,

---

# Ruby

### Prefer many files to long files

No code file over 100 lines, blank and comment lines counted.
Exempt: prose (`.md`, `.txt`), markup (`.html`, `.erb`), data, migrations, vendored code.
Enforce with `git ls-files` so a green run before `git add` proves nothing.

### No metaprogramming

Don’t call a method by name at runtime, nor define, fetch or set one that way.
The one exception is an explicit instruction. Existing uses are not permission to add another.

### No static typing

Never write type signatures, never add a typing tool. Delete `sig/` created by `bundle gem`.
No RBS, Sorbet, `sig/`, `# typed:` sigils, `srb` nor `tapioca`.

### Publish as little as possible

Public methods are a promise kept for every caller there will ever be.
Every method that can be made private must be made private.
Two public methods that a caller must use together can be replaced by one.

### Collect with map, not into an empty array

- A loop gathering one thing per item is `map`. Naming an empty array, walking with
  `each` and pushing into it takes three lines to say what one says, and names the
  array before anyone knows what goes in it.
- Folding into something that is not one per item — a hash, a grouping, a count — is
  `each_with_object`: it hands the accumulator to the block and ignores the block’s
  answer, so a guard clause or a `push` cannot quietly break it.
- `inject` is for a fold whose answer is one value: a sum, a minimum, a merge. Using it
  to gather a list means threading the accumulator through every branch and leaning on
  `<<` answering the array — true until someone adds a condition.
- `map` doing a little work along the way is fine where the collection is the result
  somebody asked for. Where the work is the point and the list is incidental, say so
  with `each_with_object` or a plain `each`.

### Hand back the enumerable, not the loop

- A method taking a block only to run `collection.each(&)` has chosen the caller’s loop
  for it. Hand the enumerable back and let whoever asked pick `each`, `map`, `find`, or
  `take(2)` — the last of which the block form cannot express at all.
- So `def upcoming_visits = fetch_them`, and the caller writes
  `upcoming_visits.each { ... }`. Not `def each_upcoming_visit(&)`.
- `each_` in a method name is the tell. The exception is a producer with no collection
  to hand over, which yields as it goes.

### Prefer a lazy enumerator

- Where a collection can be walked lazily, walk it lazily. An `Enumerator` hands over
  one item at a time, so a page is fetched when the page before it runs out, and a
  caller that wants three costs one request rather than all of them.
- Produce lazily too: `Enumerator.new { |yielder| ... }` rather than filling an array
  and handing it back.
- `.to_a` gives the whole advantage away, and usually walks the collection twice.
- The catch: lazy work happens where the enumerator is finally walked, not where it was
  written. A lock, a transaction, or credentials to write back with are gone by then,
  so the walk belongs inside whatever holds them.

## Methods

### Take the smallest thing you use

- A method handed an object it only ever reaches one part of should have been handed
  that part. `contact_of(visit)` opening with `client = visit.client` wanted
  `contact_of(client)`, and the caller wanted `contact_of visit.client`.
- A signature is a claim about what the method depends on. Taking the whole object
  claims it depends on the whole object.
- The tell is a first line that unwraps the argument. Reaching for two or three parts
  is different — that method does want the object.

### Name what you pass on

- A method taking `**attributes` only to hand the bag to the next one tells its reader
  nothing: which keys are admissible, and which are used, live in a caller somewhere
  else. Name every keyword the method actually takes.
- Splatting a hash you hold into a call that names its keywords is fine — the names are
  right there. It is *accepting* a bag and forwarding it that hides them, and a bag
  forwarded twice hides them twice over.
- Where naming them all reads badly, the method is telling you it takes too many. Split
  it, or hand over an object that knows what it holds.


### A name that asks must not answer with a change

- `claimed_by`, `matching`, `find_for` — a name that reads like a query has to stay one.
  A lookup that also writes hides the write behind a word nobody expects it in.
- Where both happen, say both: the branch that finds the record, and beneath it the
  line that updates it, in the open.

### Don’t wrap an instance variable in an accessor

- An `attr_reader` for a variable only the class itself reads adds a method to the
  public surface and buys nothing. Read the variable.

## Objects

### Objects, not services

- Behavior belongs to the object that owns the data, not to a class named after a verb.
  `Service.new(params).call(options)` is two lines of ceremony around a method that
  wanted to live on a model.
- Never instantiate a class to call its `call`. A `call` method should not exist: name
  the method after what it does — `provider.import_visits`, not
  `VisitImporter.new(provider).call`.
- Too much for one class is a concern, or a second object with a name and a life of its
  own — never a procedure wearing a class as a coat.

### Extract to an owner, not out of the way

- A file over the length limit is a question about ownership, not a request to move
  lines somewhere else. Cutting behavior into `Sync`, `Importer`, `Handler` gets under
  the cap and leaves a procedure wearing a class as a coat.
- Ask which object holds the data the behavior decides on, and move it there. The test:
  the new home has a name someone who does not write code would recognize — a visit, a
  location, a contact. Not a visit sync.

### Name a class for the system it speaks to

- A class that has to know a third party’s shapes says so in its name:
  `Contact::Jobber`, not `Contact::Imported`. The name is what licenses the knowledge,
  and what tells the next reader which file changes when that third party does.
- Named honestly, it can take the foreign object whole — and the translation layer
  built to keep those shapes out can go.

### Give siblings the same shape

- Classes doing the same kind of work — find-or-create across three models, one
  endpoint per resource — read alike, down to the order of the branches and the name of
  the private method that assembles the attributes.
- The point is not tidiness. Once they match, the one that differs is saying something
  true about the domain, and it can be seen without reading the others beside it.

### Let the structure hold the rule

- Prefer an arrangement where a rule cannot be broken over one where every method
  remembers it. A model that refuses its own bad input answers nil, and whatever sits
  above it finds nothing to attach: nobody checks, so nobody can forget to.
- A rule kept by calling things in the right order, or by a comment saying what has to
  happen first, is a rule waiting for the next edit.

### List concerns alphabetically, on one line

- `include Emailable, Phonable` — one `include` carries the whole list. Give each its
  own statement only when the single line will not fit, and keep the order when you do.
- `Style/MixinGrouping`, `EnforcedStyle: grouped`. Its default is `separated`, which
  demands the opposite, so the setting is not optional.
- `include A, B` inserts them in reverse, so `A` ends up ahead of `B` in `ancestors`.
  That only matters when both define the same method, which two concerns extracted for
  being distinct features should not.


## Files and comments

### Comment every public declaration

- One line before every public class, module, constant and method saying what it is
  for. What it is for, not what the code shows.
- Never comment a private one — it earns its explanation from its name and its caller.
- Inside a body, comment *why*, never *what*.
- One line, not two. Where a YARD tag already says it, a prose line above says it twice
  — keep the tag and drop the prose.
- A comment that keeps growing is paying interest on a design that does not explain
  itself. Shorten the design first; the comment goes with it.

### The long version goes in the commit message

- When one line will not hold everything worth saying, the rest belongs in the commit
  message. Keep the line, move the essay.
- The two are read at different times. Somebody reading the method wants to know what
  it is for, right now, in one line. Somebody asking why it is like that is already in
  `git log`, where the answer keeps its context: what it replaced, what was tried, what
  was ruled out.
- A comment ages against the code it sits above; a message stays true, because it
  describes the change it shipped with.

### Name non-trivial regular expressions

- A pattern not obvious at a glance gets a named constant on the class that owns the
  rule, commented with what it accepts and rejects.
- Trivial patterns used once stay inline.

## Layout

### Layout

- Two-space indentation, no tabs. No trailing whitespace, newline at EOF.
- `snake_case` for methods and variables, `CamelCase` for classes,
  `SCREAMING_SNAKE_CASE` for constants. Predicates end in `?`, dangerous variants in `!`.
- `do...end` for multi-line blocks, `{...}` for single-line.
- Prefer `&.`, `||=`, `Array()`, `Hash#fetch` with a default, and keyword arguments past
  two parameters.
- Inline a method body on one line in exactly two cases: an empty body, `def show; end`,
  and an endless method, `def advice_params = params.expect(advice: [:content])`.

### One return at most, and only at the top

- The one `return` is the case a method refuses before any work starts. Past that line
  the method runs to its end. `unless` for simple negatives, never `unless ... else`.
- A second `return` in the middle is branching by another name, and `if`/`elsif` says it
  where a reader sees all the branches at once:

```ruby
def import_visit(visit)                          # not: return ... if ours
  if ours = provider.visits.find_by(jid: visit.id)
    ours.update schedule_of(visit)
  elsif location = location_of(visit)
    provider.visits.create! attributes_of(visit).merge(location: location)
  end
end
```

### Lines at most 100 characters

- Split long strings across lines rather than running over.
- Markup is exempt: a URL or a long class list does not wrap usefully.

### Single quotes by default

- Double quotes only where the string needs them: interpolation or an escape.
- `Style/StringLiterals` and `Style/StringLiteralsInInterpolation`, both
  `single_quotes`.

### Never freeze strings

- No `# frozen_string_literal: true`, in any file, including generated ones.
- Never `.freeze` a string. Array and hash constants are still worth freezing.
- Where a constant only names something, prefer a symbol — immutable already.
- `Style/FrozenStringLiteralComment` is `never`; `Style/MutableConstant` is off, since
  it demands `.freeze` on string constants and cannot skip them.

### Trailing comma on a multiline literal

- The last entry ends with a comma, so adding one touches one line. The closing brace
  goes on its own line — `, }` reads worse than either alternative.
- This is also what decides how to break a literal that spans lines only because it is
  long: give it the closing line.
- `Style/TrailingCommaInHashLiteral` and `...InArrayLiteral`, both
  `EnforcedStyleForMultiline: consistent_comma`. Not `comma`, which forbids it unless
  every entry sits on its own line.

### Indent `when` inside a `case`

- `when` and `else` sit one level in from `case` and `end`:

```ruby
case params[:list]
  when 'unread' then Contact.with_unread
  else Contact.all
end
```

- `Layout/CaseIndentation` with `EnforcedStyle: end` **and** `IndentOneStep: true`.
  Neither alone is enough. `Layout/ElseAlignment` then follows.

### As few parentheses as possible

- Omit them on a call’s arguments; keep the inner ones, where parsing needs them:
  `Object.const_set class_name, Class.new(Base)`.
- `Style/MethodCallWithArgsParentheses`, `EnforcedStyle: omit_parentheses`. The cop is
  off by default, so it needs `Enabled: true` too.
- The exception is the call *in* a condition — after `if`, whether it opens a block or
  trails as a modifier. Two things happen on that line, so the condition’s call keeps
  its parentheses and the reader can see where the argument ends and the branch begins:

```ruby
if @vertical.update(vertical_params)
params[:status] = :matched if params.delete(:engaged)
```

- A call *before* a modifier `if` is not part of the condition, so it still omits them:

```ruby
update_column :status, :matched if params.delete(:engaged)
```

- Same for the rest of the family — `unless`, `while`, `until`, and a ternary’s
  condition.
- The cop cannot express this, and inline disables cost more than they buy. Decline the
  cop instead, with the exception as the reason beside it, and hold the rule in review.

### Outdent visibility modifiers

- `private` sits at the level of `class`, and the methods under it keep the normal
  indent, so it reads as a divider.
- `Layout/AccessModifierIndentation`, `EnforcedStyle: outdent`.

## RuboCop

### Keep RuboCop current

- `AllCops: NewCops: enable`. Fix what a new release surfaces; never pin.
- Enabling every new cop is not accepting every new cop. Decline one outright, in
  `.rubocop.yml`, with the reason beside it.
- `SuggestExtensions: false`. An extension we are declining is off, not merely ignored.

## Gems

### Gemfile and gemspec

- Alphabetical, one block, no blank lines — those read as separate groups.
- Never `~>`. Use `>=` only where a minimum is genuinely required, otherwise no
  constraint at all.
- Every gem carries a trailing comment saying what would break without it — not what
  the gem is. Same for `add_dependency`.

### What a gem always ships

- `bin/console` and `bin/setup`: one to try the library in a REPL, one to get a clone
  working in a single command.
- A `CHANGELOG.md`, written before the release is made. Every entry says which of three
  it is — **fix**, **feature**, **breaking change** — because that is what tells a
  reader whether they can take it, and it is what picks the version: patch, minor,
  major. Numbering first is how a minor release quietly breaks somebody.
- Keep an `## [Unreleased]` heading, so a release is a rename rather than an act of
  remembering.

### A gem’s README says how to install it

- Every gem we publish follows Semantic Versioning, and its README carries a `How to
  install` section: the system install (`gem install <name>`), then the Gemfile line
  pinned to the current major (`gem '<name>', '~> 2.0'`), then the sentence saying why
  that pin is safe — `~> major.minor` means `bundle update` never crosses a breaking
  change.
- Keep the snippet current: a major release updates the pin in the same commit.
- This does not soften "never use `~>`". That rule binds *our* Gemfiles and gemspecs
  naming what we depend on; the README line is advice to hosts pinning *us*.

### Git ignores a built gem

- `*.gem` is gitignored. `rake build` puts one under `/pkg/`, ignored already, but
  `gem build` leaves it in the working directory where `git add -A` sweeps up a
  megabyte of binary release artifact.
- Nothing is lost: `spec.files` reads `git ls-files`, so a build is never packaged
  inside the next one either way.
- Delete the built `.gem` once `gem push` has taken it. Left behind, it is a stale
  build of a version that may since have been amended, waiting to be pushed again.

### A gem’s page draws its mark once

- A gem that gets a GitHub Page with colors and artwork of its own gets the whole icon
  set in the same breath — the browser’s, iOS’, and the avatar GitHub and the social
  networks show. A page whose tab is a blank sheet and whose repository is a gray
  identicon is half built.
- One drawing answers all of them: an `icon.svg` beside `index.html` holding the mark at
  the scale a tab can carry, and a `build-icons.sh` that renders the rest from it. Run
  it after editing the SVG and commit what changes. Never touch a PNG by hand, or the
  set drifts apart one file at a time.
- What each service asks for: `favicon.ico` holding 16, 32 and 48, which a browser
  reaches for when the page links nothing; `favicon-96x96.png` for the tab;
  `apple-touch-icon.png` at 180 for a home-screen bookmark;
  `web-app-manifest-192x192.png` and `-512x512.png` named in `site.webmanifest`; and
  `avatar.png` at 1024 for GitHub and every social network, since they all crop a
  square themselves.
- Corners are the one thing that varies: iOS masks a bookmark and every avatar is shown
  round, so those two render from an SVG whose `rx` is 0. A corner rounded twice reads
  as a mistake.
- Adapt the drawing, never the rendering. What a 16-pixel tab cannot carry — a halo, a
  sparkle — comes out of the SVG, so every size says the same thing at the fidelity it
  can hold.
- `rsvg-convert` and `magick` do the rendering, named in a comment at the top of the
  script, since a machine without them fails at the first line.

### A release is not done until the page says so

- A gem with a GitHub Page has two places that state its API, and a release that
  updates only one leaves the other lying. Push to RubyGems and update `gh-pages` in
  the same breath — the version it names, the methods it lists, the examples it shows.
- The page is what somebody reads before they install anything, so a stale one costs
  more than no page at all: it teaches an API the gem no longer has.
- Checklist, none of it optional: `CHANGELOG.md`, `README.md`, the version constant,
  the tag, RubyGems, `gh-pages`.

---

# Rails

True in a Rails app.

## The Rails Way

### The Rails Way

- Reach for a framework feature before writing infrastructure.
- Fat model, skinny controller. A controller does routing, authorization, params and
  rendering — nothing else.
- The seven standard actions. Nested resources or a new controller over a custom
  action, and a second-level controller for a nested route rather than a branch in the
  first.
- Strong parameters; never pass raw `params` to a model.
- Scopes for reusable queries. No query logic in a controller or a view.
- Never put a method in a controller that only a view calls, and never `helper_method`
  to expose one. A view’s needs belong in a helper or the template.
- Active Job for anything slow or external, declared with `performs` so the caller
  reads as a method rather than as a job.
- Secrets in credentials or ENV, never committed.

### Follow REST

- Endpoints are CRUD on resources. Where an action does not map to a verb, add a
  resource rather than a custom action.

```ruby
resources :cards do          # not: post :close, post :reopen
  resource :closure
end
```

### Target current Rails

- Target either the latest release of Rails or the `main` branch of `rails/rails`.
  Write against current APIs only.
- Never add a version check, shim or fallback for an older Rails or Ruby.

## Database

### PostgreSQL, always

- When a stand-alone app needs a database it is PostgreSQL. Never MySQL, never SQLite,
  even where SQLite would be less setup.
- A dummy app that exists only to test a gem is the exception, and may use SQLite. It
  is a fixture rather than an app: nobody deploys it, a gem serves every adapter
  anyway, and proving that on a second one — with no server to run — is worth more than
  the fixture resembling the apps. Say in the gem what such a dummy states portably in
  place of what PostgreSQL alone offers.

### Validations and constraints together

- The database is the last line of defense: null constraints, unique indexes, foreign
  keys, check constraints.
- A constraint the model does not also state is one the browser cannot show. Add the
  validator too.
- Migrations are reversible, and one that has shipped is never edited.

### Keep a table’s columns in a meaningful order

- Creating a table, or adding a column to one, is a chance to say how the table reads.
  Appending to the end is a decision not to think.
- The order, left to right:
  1. `type`, where a hierarchy is told apart by one.
  2. Any non-null enum — a `status` and its like.
  3. The other non-null attributes, counter caches aside.
  4. The non-null foreign keys.
  5. The counter caches, whatever they are declared as.
  6. The indexed columns.
  7. Everything else.
  8. The dates and times, Rails’ own timestamps last of all.
- What a record is comes before what it points at, and both come before what it counts.
- A screen that draws a table’s columns inherits this order, so getting it right is
  worth more than the schema’s own tidiness.
- PostgreSQL cannot move a column, so an order settled late costs a rebuild: a second
  table in the right order, the rows poured across, then every index and foreign key
  named again. Cheap while a table is young, which is the reason to decide early.

### An enum is a Postgres type

- Native type, not an integer and not a bare string: `create_enum :job_status,
  Job::STATUSES`, then `t.enum :status, enum_type: :job_status, default: :draft,
  null: false`.
- The names live in a constant on the model, one per line with a comment saying what
  that state means, and the migration reads the same constant so the two cannot drift.
- An array column is `t.text :urls, array: true, default: [], null: false` — always an
  array, so nothing has to check for nil first.

### Emails are citext

- A plaintext email column is `citext`, never `string`: that is what makes comparison
  and a unique index agree that `Ada@` and `ada@` are one address. Run
  `enable_extension 'citext'` before the first one. Nothing else is then needed — no
  `LOWER(email)` index, no downcasing on the way in.
- An *encrypted* email column is not citext, since it holds ciphertext. Normalize in
  Rails instead, always with both options:
  `encrypts :email, deterministic: true, downcase: true`.

### Prefer `up_only` in migrations

- A step that runs only on the way up is `up_only { backfill }`, never
  `reversible { |direction| direction.up { backfill } }`. The short form has been
  Rails’ since 5.2, it says what it means, and it leaves no down branch to read past.
- `reversible` keeps its place where a migration genuinely writes both directions.

## Models

### Both sides of an association

- A `belongs_to` gets the matching `has_many`. Reading a foreign key from one side only
  is half the model.
- `dependent:` follows what the child requires: `:destroy` where it cannot exist
  without the parent, `:nullify` where the association is optional.
- `:destroy`, not `:restrict_with_error`. An admin deleting a record is entitled to the
  tree under it, and the cascade exists so nobody dismantles it by hand.
- `has_many` takes one name, unlike `validates`. `has_many :counties, :markets` reads
  `:markets` as a scope and fails much later with `undefined method 'arity'`.
- Neither side helps against `delete_all`, which is raw SQL and skips callbacks.

### Count through the association, not the counter cache

- `service.bands.size`, not `service.bands_count`. A counter cache is an optimization
  of the SQL, and a view has no business knowing which optimizations the schema happens
  to carry.
- The association reads as what it means, and it is the same line whether a counter
  cache exists, is added later, or is taken away.
- `size` is the method that makes this work: it takes the cached column where there is
  one, counts where there is not, and reads the records where they are already loaded.
- Where the association cannot answer — no association at all, or a `has_many :through`,
  where `size` would issue a query per row — the column stays. Say so where it is used.

### Encryption that a query can still find

- A column that is queried or must stay unique needs `deterministic: true`.
  Non-deterministic ciphertext differs every write, silently defeating both a unique
  index and a uniqueness validation — they pass while duplicates pile up.
- It is not conditional on the column being queried *today*. Switching later means
  re-encrypting every row.
- `downcase: true` is what keeps a unique index honest: without it two spellings
  encrypt to two values.
- Never constrain the *shape* of an encrypted value in the database: it holds
  ciphertext, so only nullability and uniqueness still mean anything. Shape belongs to
  the model.

### Phone numbers

- A `phone` column holds exactly ten digits, `null: false`, unique. The database cannot
  check the shape, since the value is encrypted.
- The shape is the model’s, in a concern that normalizes and validates:

```ruby
NORTH_AMERICAN_PHONES = /\A[2-9]\d{2}[2-9]\d{6}\z/

normalizes :phone, with: ->(phone) { phone.delete('^0-9').delete_prefix '1' }

with_options format: { with: NORTH_AMERICAN_PHONES, message: '...' } do
  validates :phone, allow_nil: true
end
```

- The concern is `allow_nil`, so whether a phone is *required* is the including model’s
  call.

### Ask the validators, not the schema

- What a value may be is the model’s business. A length validator gives a field its
  `maxlength`, a format validator its `pattern`, a numericality validator its keyboard.
  Never read `columns_hash` for a limit or a type.
- The two disagree more often than it looks: a `limit: 5` column with no length
  validator accepts four characters, and an encrypted column’s limit describes
  ciphertext.
- Where no validator can answer — `date` vs `time` vs `datetime` — ask
  `type_for_attribute`, so an `attribute` override counts.

### Shared behavior becomes a concern

- Two classes declaring the same behavior word for word: extract a module. A second
  identical declaration is the threshold; anticipating one is not.
- Name it after the feature, not the classes: `Emailable`, `Phonable`.
- Only what they genuinely share moves. Where one requires what the other allows, the
  requirement stays behind.
- Include alphabetically, on one line — see
  [List concerns alphabetically](#list-concerns-alphabetically-on-one-line).

### A new kind of value is an Active Record type

- When a page has to tell two columns of the same type apart — money from a share of
  it, both `decimal(10,2)` — the answer is a custom Active Record type:
  `Price < ActiveRecord::Type::Decimal` reporting `def type = :price`, registered with
  `ActiveRecord::Type.register`, and the model saying `attribute :hourly_rate, :price`.
- Everything downstream then asks `type_for_attribute`, so the rule for a price applies
  exactly where a `:price` type is what answers — never by guessing from a column’s
  name. `hourly_rate` is money and `commission_rate` is not.
- Give migrations the same word by extending `TableDefinition` with a column method
  that delegates to the type it is a kind of. Rails keeps `define_column_methods`
  private, so write the method out rather than reaching for it.
- Keep the type’s `precision` and `scale` equal to the column’s. A type promising five
  digits over a `decimal(4, 2)` puts a `max` in the browser that the database will
  refuse.
- Register with a block, so a type under `app/types/` is autoloaded when a model first
  asks rather than during boot.

## Queries

### Treat an extra query as a defect

- Rendering a page issues as few queries as it can, and the count does not grow with
  the page. Eager-load every association a page will name.
- Ask whether a relation has records *and then loop over it* with one query, not two:
  the check that loads the rows the loop needs is right, the one that adds a probing
  `SELECT` is not.
- Assert the count in a test, so a later edit cannot quietly add one back.

### Order every paginated relation

- Paging a relation with no order is not paging. Postgres may return rows any way it
  likes, and an updated row moves to the end of the table, so a page can repeat a row
  it showed or skip one it did not.

### Select only the columns a query displays

- A query built to display something fetches those columns and no others. The count of
  queries is one cost; the width of each is another.
- Where the columns are not known — a generic view handed a whole record — select
  everything on purpose.

### Cache a query or a fragment that repeats

- Reach for `Rails.cache` wherever the same rows would be read or the same markup
  re-rendered. Cache the table, not the pagination around it.
- Key a fragment on the *relation* — `cache records do` — never a hand-rolled string:
  Rails digests the SQL and versions it by row count and newest `updated_at`, so
  nothing has to expire it.
- That version costs a `SELECT COUNT(*), MAX(updated_at)`, and it is the price of never
  serving a stale menu. Keying on `cache_key` alone queries nothing but never notices a
  new row — only behind an `expires_in`.
- A list with no relation behind it has no version to check, so key it on a digest of
  the list itself. A fixed string goes stale the moment the list changes, and silently.
- A cache that is off in tests is a cache nobody tests:
  `config.cache_store = :memory_store` for test.

## Views

### Pass locals to partials explicitly

- A partial never reads a controller’s instance variables. Declare strict locals on its
  first line — `<%# locals: (resources:, pagy:) %>` — and pass them at the call site.
- A partial taking no locals gets no comment at all. Never write `<%# locals: () %>`.
- A template rendered by an action may read instance variables. The rule is about
  partials, which should not depend on who rendered them.
- Rails enforces it: omit a declared local and the render raises rather than quietly
  drawing a blank.
- Where two branches need different locals, write `if`/`else` rather than
  `render cond ? 'a' : 'b'` — one call cannot pass the right locals to both.

### Every endpoint is Turbo-enabled

- Assume a Turbo visit. A redirect out of the app needs `allow_other_host: true`, a
  redirect after a non-GET needs `status: :see_other`, and a link that must break out
  of a frame needs `data: { turbo_frame: '_top' }`.

### Match Bootstrap with `field_error_proc`

- Wherever Bootstrap is the CSS framework, set `config.action_view.field_error_proc`.
  Rails’ default wraps a rejected field in `<div class='field_with_errors'>`, which
  Bootstrap styles not at all: no red border, and the message nowhere on the page.
- The proc adds `is-invalid` to the control and follows it with a
  `<small class='invalid-feedback'>`, which is the pair Bootstrap needs — its
  `.is-invalid ~ .invalid-feedback` reveals one only next to the other.
- Guard on the control’s class, not on the tag’s type. A label carries `form-label` and
  falls straight through, and so does anything without a `form-control`. Guarding on
  the tag class instead leaves `html_tag.index 'form-control'` nil for every other kind
  of tag, and `insert nil` raises.
- The proc is `instance_exec`’d on the view, so `tag` and `safe_join` are in scope — no
  need to write markup as a string. Which is just as well: `insert` on a SafeBuffer
  escapes what it is given, so an attribute spliced in by hand arrives as `&#39;`.

## System tests

### One system test, many assertions

- A system test pays for a browser before it asserts anything. Two files walking the
  same page to check two features pay it twice; one test that walks it once and asserts
  both pays it once, and reads as the sitting a user actually has.
- Group by the page somebody is on rather than by the feature somebody is building:
  open it, do the thing, assert what changed, do the next thing.
- What the sharing exposes is worth the merge on its own. A fixture that only worked
  against an empty database, or a wait that only passed because nothing had happened
  yet, fails the moment a step runs before it — and it was lying in the split test all
  along.

### Run system tests headless where CI says so

- A system test runs headless where `CI` is set in the environment, and opens a browser
  where it is not: `headless: !!ENV['CI']`. That one variable decides it — never a
  second one of its own, and never a default the code carries whatever the machine says.
- A machine that should never see a window says so once, by exporting `CI=1`. A window
  opening mid-run steals focus, and a suite nobody can leave running is a suite nobody
  runs.
- The prefix binds to one command: `CI=1 bin/rails db:reset && bin/rake` sets it for the
  reset alone and leaves the tests headed. Export it, or put it in front of the command
  that actually runs them.

### No indefinite article in an interpolated string

- Never write `a %{model}` or `an %{model}`. Sound decides, not spelling — an hour, an
  honest agent, a user, a European market, a one-off — and acronyms split it again: a
  ZIP, an SMS, an API.
- Nothing computes it. `ActiveSupport::Inflector` has no article method; the gems that
  add one guess from spelling and guess wrong in public.
- It would not survive translation: an article is per-language and usually per-gender.
- Write the copy so the question never comes up. `Select…`, not `Select a State…`, since
  the label already names the field; `without its job`, not `without a job`.

## Config

### Keep render lines out of the logs

- `config.action_view.logger = nil`. One `Rendered ...` line per partial buries the
  request that matters.
- Everything else stays: the request, the SQL, and the timing line.
- A rule for apps we write. A gem never touches a host’s logging.
