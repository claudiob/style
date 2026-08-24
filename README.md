# Coding guidelines

**[Read these rules on the web at claudiob.github.io/style](https://claudiob.github.io/style/)** — the live version lays
them out three folders deep, and every rule there carries an **Approve** and a **Reject** button.
Vote on the ones you keep and the ones you would throw out; the tallies below are those votes,
counted.

Thirty rules, ten to a part. A rule lives in the widest part it is true in.

[🧑‍💻 **Principles**](https://claudiob.github.io/style/#principles) · [💎 **Ruby**](https://claudiob.github.io/style/#ruby) · [🛤️ **Rails**](https://claudiob.github.io/style/#rails)

<sub>Vote counts read from the live counters on 24 August 2026. For the current standing, [visit the page](https://claudiob.github.io/style/).</sub>

---

## 🧑‍💻 Principles

*What holds in any language.*

### [Encrypt personal data](https://claudiob.github.io/style/#encrypt-personal-data)

Don’t store your customers’ phone, email, last name, street in plain text.

<img src="https://placehold.co/189x10/27476F/27476F.png" width="189" height="10" alt=""><img src="https://placehold.co/51x10/A82A20/A82A20.png" width="51" height="10" alt=""><br>**79% approve** — 11 approve, 3 reject

### [Code optimistically](https://claudiob.github.io/style/#code-optimistically)

Never write a method nobody calls. Never rescue an error nobody has incurred.

<img src="https://placehold.co/216x10/27476F/27476F.png" width="216" height="10" alt=""><img src="https://placehold.co/24x10/A82A20/A82A20.png" width="24" height="10" alt=""><br>**90% approve** — 9 approve, 1 reject

### [Unchained melody](https://claudiob.github.io/style/#unchained-melody)

Two calls on the same object in one expression are the tell: the second is unneeded.

<img src="https://placehold.co/109x10/27476F/27476F.png" width="109" height="10" alt=""><img src="https://placehold.co/131x10/A82A20/A82A20.png" width="131" height="10" alt=""><br>**45% approve** — 5 approve, 6 reject

### [Say it short](https://claudiob.github.io/style/#say-it-short)

Between two versions carrying the same meaning, always pick the shorter name.

<img src="https://placehold.co/175x10/27476F/27476F.png" width="175" height="10" alt=""><img src="https://placehold.co/65x10/A82A20/A82A20.png" width="65" height="10" alt=""><br>**73% approve** — 8 approve, 3 reject

### [No sleights of hand](https://claudiob.github.io/style/#no-sleights-of-hand)

`claimed_by`, `matching` — methods named like a query must not have any side effect.

<img src="https://placehold.co/240x10/27476F/27476F.png" width="240" height="10" alt=""><br>**100% approve** — 9 approve, 0 reject

### [Shy away from public](https://claudiob.github.io/style/#shy-away-from-public)

Every method that can be private must be private.

<img src="https://placehold.co/240x10/27476F/27476F.png" width="240" height="10" alt=""><br>**100% approve** — 11 approve, 0 reject

### [Document what’s public](https://claudiob.github.io/style/#document-whats-public)

Add a single-line comment above each class/constant/method that is not private.

<img src="https://placehold.co/144x10/27476F/27476F.png" width="144" height="10" alt=""><img src="https://placehold.co/96x10/A82A20/A82A20.png" width="96" height="10" alt=""><br>**60% approve** — 6 approve, 4 reject

### [Communicate through git](https://claudiob.github.io/style/#communicate-through-git)

Small commits with long descriptions (*why* the code was shipped) and linear history.

<img src="https://placehold.co/216x10/27476F/27476F.png" width="216" height="10" alt=""><img src="https://placehold.co/24x10/A82A20/A82A20.png" width="24" height="10" alt=""><br>**90% approve** — 9 approve, 1 reject

### [Sharpen your tests](https://claudiob.github.io/style/#sharpen-your-tests)

Full coverage and not one line more. Never test code you don’t own.

<img src="https://placehold.co/168x10/27476F/27476F.png" width="168" height="10" alt=""><img src="https://placehold.co/72x10/A82A20/A82A20.png" width="72" height="10" alt=""><br>**70% approve** — 7 approve, 3 reject

### [Write good English](https://claudiob.github.io/style/#write-good-english)

Don’t Titleize. It’s ZIP not Zip. It’s license not licence. Respect the apostrophes.

<img src="https://placehold.co/216x10/27476F/27476F.png" width="216" height="10" alt=""><img src="https://placehold.co/24x10/A82A20/A82A20.png" width="24" height="10" alt=""><br>**90% approve** — 9 approve, 1 reject

---

## 💎 Ruby

*What holds in Ruby.*

### [Prefer many to long files](https://claudiob.github.io/style/#prefer-many-to-long-files)

At most 100 lines in a file. At most 100 characters in a line. Comments count.

<img src="https://placehold.co/107x10/27476F/27476F.png" width="107" height="10" alt=""><img src="https://placehold.co/133x10/A82A20/A82A20.png" width="133" height="10" alt=""><br>**44% approve** — 4 approve, 5 reject

### [Stay object-oriented](https://claudiob.github.io/style/#stay-object-oriented)

You don’t need `Service.new.call(params)`. Any method `call` is a code smell.

<img src="https://placehold.co/171x10/27476F/27476F.png" width="171" height="10" alt=""><img src="https://placehold.co/69x10/A82A20/A82A20.png" width="69" height="10" alt=""><br>**71% approve** — 5 approve, 2 reject

### [Resist metaprogramming](https://claudiob.github.io/style/#resist-metaprogramming)

Don’t interpolate method names at runtime. Don’t send. Don’t break the rules.

<img src="https://placehold.co/103x10/27476F/27476F.png" width="103" height="10" alt=""><img src="https://placehold.co/137x10/A82A20/A82A20.png" width="137" height="10" alt=""><br>**43% approve** — 3 approve, 4 reject

### [No static typing](https://claudiob.github.io/style/#no-static-typing)

Ruby does not care what class an object belongs to. Embrace the freedom. 🦆

<img src="https://placehold.co/200x10/27476F/27476F.png" width="200" height="10" alt=""><img src="https://placehold.co/40x10/A82A20/A82A20.png" width="40" height="10" alt=""><br>**83% approve** — 5 approve, 1 reject

### [Take it small](https://claudiob.github.io/style/#take-it-small)

`def foo(bar)` opening with `baz = bar.baz` should have been `foo(bar.baz)`.

<img src="https://placehold.co/240x10/27476F/27476F.png" width="240" height="10" alt=""><br>**100% approve** — 5 approve, 0 reject

### [Don’t splat everywhere](https://claudiob.github.io/style/#dont-splat-everywhere)

Taking `**attributes` only to hand them to a method makes params hard to follow.

<img src="https://placehold.co/200x10/27476F/27476F.png" width="200" height="10" alt=""><img src="https://placehold.co/40x10/A82A20/A82A20.png" width="40" height="10" alt=""><br>**83% approve** — 5 approve, 1 reject

### [Don’t over-accessorize](https://claudiob.github.io/style/#dont-over-accessorize)

No need for `attr_reader :foo` if `@foo` can be used instead.

<img src="https://placehold.co/150x10/27476F/27476F.png" width="150" height="10" alt=""><img src="https://placehold.co/90x10/A82A20/A82A20.png" width="90" height="10" alt=""><br>**62% approve** — 5 approve, 3 reject

### [Return first or never](https://claudiob.github.io/style/#return-first-or-never)

A method can only `return` in its first line of code before any work starts.

<img src="https://placehold.co/120x10/27476F/27476F.png" width="120" height="10" alt=""><img src="https://placehold.co/120x10/A82A20/A82A20.png" width="120" height="10" alt=""><br>**50% approve** — 3 approve, 3 reject

### [Limit the parentheses](https://claudiob.github.io/style/#limit-the-parentheses)

Omit on a call’s arguments; keep the inner ones where parsing needs them.

<img src="https://placehold.co/160x10/27476F/27476F.png" width="160" height="10" alt=""><img src="https://placehold.co/80x10/A82A20/A82A20.png" width="80" height="10" alt=""><br>**67% approve** — 4 approve, 2 reject

### [Make it readable](https://claudiob.github.io/style/#make-it-readable)

Enhance RuboCop for code that is easy to grep and clean to diff:

- Single quotes are the rule; double quotes only for interpolation and escape [[1]](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Style/StringLiterals) [[2]](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Style/StringLiteralsInInterpolation)
- Trailing comma on the last line of multiline literals (closing brace on its line) [[3]](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Style/TrailingCommaInHashLiteral) [[4]](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Style/TrailingCommaInArrayLiteral)
- `when` and `else` sit one level in from `case` and `end` [[5]](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Layout/CaseIndentation)
- `private` sits with `class`; private methods are indented like public ones[[6]](https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Layout/AccessModifierIndentation)

<img src="https://placehold.co/192x10/27476F/27476F.png" width="192" height="10" alt=""><img src="https://placehold.co/48x10/A82A20/A82A20.png" width="48" height="10" alt=""><br>**80% approve** — 4 approve, 1 reject

---

## 🛤️ Rails

*What holds in Rails.*

### [Follow the Rails Way](https://claudiob.github.io/style/#follow-the-rails-way)

Extend with Concern, respect strong params, apply convention over configuration.

Embrace REST: endpoints are CRUD on resources. Add custom resources, never actions.

<img src="https://placehold.co/206x10/27476F/27476F.png" width="206" height="10" alt=""><img src="https://placehold.co/34x10/A82A20/A82A20.png" width="34" height="10" alt=""><br>**86% approve** — 6 approve, 1 reject

### [Live on the edge](https://claudiob.github.io/style/#live-on-the-edge)

Build off the `main` branch of `rails/rails`. Scrap any `~>` from your Gemfile.

Order gems alphabetically and document inline why the app would break without them.

<img src="https://placehold.co/80x10/27476F/27476F.png" width="80" height="10" alt=""><img src="https://placehold.co/160x10/A82A20/A82A20.png" width="160" height="10" alt=""><br>**33% approve** — 2 approve, 4 reject

### [Cache from the start](https://claudiob.github.io/style/#cache-from-the-start)

`Rails.cache` wherever the same rows would be read or the same markup rendered.

Run tests with `config.cache_store = :memory_store` to verify caching works.

<img src="https://placehold.co/160x10/27476F/27476F.png" width="160" height="10" alt=""><img src="https://placehold.co/80x10/A82A20/A82A20.png" width="80" height="10" alt=""><br>**67% approve** — 4 approve, 2 reject

### [Declare explicit locals](https://claudiob.github.io/style/#declare-explicit-locals)

Don’t pass instance variables to partials—use strict `` instead.

<img src="https://placehold.co/200x10/27476F/27476F.png" width="200" height="10" alt=""><img src="https://placehold.co/40x10/A82A20/A82A20.png" width="40" height="10" alt=""><br>**83% approve** — 5 approve, 1 reject

### [Assume Turbo is enabled](https://claudiob.github.io/style/#assume-turbo-is-enabled)

Redirect out of the app with `allow_other_host: true`; after a non-GET with `status: :see_other`; break out of a frame with `data: { turbo_frame: '_top' }`.

<img src="https://placehold.co/120x10/27476F/27476F.png" width="120" height="10" alt=""><img src="https://placehold.co/120x10/A82A20/A82A20.png" width="120" height="10" alt=""><br>**50% approve** — 3 approve, 3 reject

### [Trim database queries](https://claudiob.github.io/style/#trim-database-queries)

Eager-load associations. Check if records exist and loop over them in a single query.

Avoid the cost of `User.all` if all you display is `User.select(:name, :email)`.

<img src="https://placehold.co/240x10/27476F/27476F.png" width="240" height="10" alt=""><br>**100% approve** — 6 approve, 0 reject

### [Migrations go both ways](https://claudiob.github.io/style/#migrations-go-both-ways)

Ensure every migration you write is reversible.

Use `change` before `up`/`down`. Use `up_only` before `reversible { |dir| dir.up }`.

<img src="https://placehold.co/240x10/27476F/27476F.png" width="240" height="10" alt=""><br>**100% approve** — 6 approve, 0 reject

### [Use Active Record types](https://claudiob.github.io/style/#use-active-record-types)

Clarify a `decimal` column `price` stores money with `attribute :price, :amount`.

All you need is to register a new type: `Amount < ActiveRecord::Type::Decimal`.

<img src="https://placehold.co/200x10/27476F/27476F.png" width="200" height="10" alt=""><img src="https://placehold.co/40x10/A82A20/A82A20.png" width="40" height="10" alt=""><br>**83% approve** — 5 approve, 1 reject

### [Query with encryption](https://claudiob.github.io/style/#query-with-encryption)

Invoke `encrypt` on any sensitive data. Add `deterministic: { fixed: false }` to columns that must be queried or kept unique such as: `User.find_by(email:)`.

<img src="https://placehold.co/200x10/27476F/27476F.png" width="200" height="10" alt=""><img src="https://placehold.co/40x10/A82A20/A82A20.png" width="40" height="10" alt=""><br>**83% approve** — 5 approve, 1 reject

### [Harness PostgreSQL](https://claudiob.github.io/style/#harness-postgresql-types)

PostgreSQL offers native types and extensions that play well with Rails:

- `type: :citext` to store case-insensitive strings such as emails
- `array: true` to store an array in a single column
- `create_enum` to declare enums backed by names, not integers

<img src="https://placehold.co/200x10/27476F/27476F.png" width="200" height="10" alt=""><img src="https://placehold.co/40x10/A82A20/A82A20.png" width="40" height="10" alt=""><br>**83% approve** — 5 approve, 1 reject

---

Cast your own vote at **[claudiob.github.io/style](https://claudiob.github.io/style/)**.
