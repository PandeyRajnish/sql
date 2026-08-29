# Query data with SELECT

[← All topics](../README.md)

First topic: choose a database, write comments, retrieve rows with `SELECT` / `FROM`, filter with `WHERE`, sort with `ORDER BY`, summarise with `GROUP BY`, filter groups with `HAVING`, and drop duplicates with `DISTINCT`.

---

## Visual cheat sheet — `SELECT` / `FROM` (no filter)

You **write** SQL top-to-bottom, but SQL Server **runs** it in a different order.  
Forgetting this is why `WHERE score > 100` works even though `score` appears in `SELECT` — the engine already knows the column from `FROM` before it builds the result list.

### What you type (reading order)

```sql
SELECT first_name, country, score   -- ① you write this first
FROM customers;                     -- ② you write this second
```

### What actually runs (execution order)

```
┌─────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers          ← find the table      │
│           ↓                                             │
│  STEP 2   SELECT first_name,      ← pick columns        │
│           country, score          (build result set)    │
└─────────────────────────────────────────────────────────┘
```

**Memory hook:** **F**rom first, **S**elect second — **F** before **S** in the alphabet, and in the engine.

```mermaid
flowchart TD
    A["① FROM customers<br/><i>Which table?</i>"] --> B["② SELECT columns<br/><i>Which columns to show?</i>"]
    B --> C["Result rows returned to you"]
```

---

## Full clause order (save for later topics)

When you add `WHERE`, `ORDER BY`, etc., the **written** order and **execution** order diverge more:

| You write (top → bottom) | Engine runs (actual order)   |
| ------------------------ | ---------------------------- |
| `SELECT`                 | 5. `SELECT`                  |
| `FROM`                   | 1. **`FROM`** ← always first |
| `WHERE`                  | 2. `WHERE`                   |
| `GROUP BY`               | 3. `GROUP BY`                |
| `HAVING`                 | 4. `HAVING`                  |
| `ORDER BY`               | 6. `ORDER BY`                |

**One-line mnemonic:** **F**rom **W**here **G**roup **H**aving **S**elect **O**rder → **FWGHSO**

For this folder you need the full path: **FROM → WHERE → GROUP BY → HAVING → SELECT (DISTINCT) → ORDER BY**.

---

## Visual cheat sheet — `WHERE` (filter rows)

`WHERE` **narrows** the rows **before** SQL Server decides which columns to show.  
Think of it as a gate: every row from the table must pass the condition, or it is dropped.

### What you type (reading order)

```sql
SELECT *                    -- ① you write this first
FROM customers              -- ② you write this second
WHERE country = 'Germany';  -- ③ you write this third
```

### What actually runs (execution order)

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers                                         │
│           ↓  load all rows from the table                        │
│                                                                  │
│  STEP 2   WHERE country = 'Germany'                              │
│           ↓  keep only rows that pass the test  ← FILTER HERE    │
│                                                                  │
│  STEP 3   SELECT *                                               │
│           ↓  pick columns from the rows that survived            │
└──────────────────────────────────────────────────────────────────┘
```

**Memory hook:** **F**rom → **W**here → **S**elect → **FWS** (filter in the middle, before you "select" what to show).

```mermaid
flowchart TD
    A["① FROM customers<br/><i>All rows from table</i>"] --> B["② WHERE condition<br/><i>Keep matching rows only</i>"]
    B --> C["③ SELECT columns<br/><i>Build final result</i>"]
    C --> D["Filtered rows returned to you"]

    style B fill:#fff3cd,stroke:#856404
```

### Filter funnel (mental picture)

```
  customers table          WHERE score != 0          SELECT *
  ┌───┬───┬───┐            ┌───┬───┬───┐            ┌───┬───┬───┐
  │ A │ 0 │ ✗ │  ──────►   │   │   │   │  ──────►   │ B │85 │ ✓ │
  │ B │85 │ ✓ │            │ B │85 │ ✓ │            │ C │42 │ ✓ │
  │ C │42 │ ✓ │            │ C │42 │ ✓ │            └───┴───┴───┘
  └───┴───┴───┘            └───┴───┴───┘
  3 rows loaded              2 rows pass gate         columns picked
```

### Examples from `where-clause.sql`

| Goal | Condition | Notes |
| --- | --- | --- |
| Score is not zero | `WHERE score != 0` | `!=` means "not equal" |
| Country is Germany | `WHERE country = 'Germany'` | Text values need **single quotes** `'...'` |
| Fewer columns + filter | `SELECT first_name, country` + `WHERE country = 'Germany'` | `WHERE` still runs **before** `SELECT` |

### Common comparison operators

| Operator | Meaning | Example |
| --- | --- | --- |
| `=` | equal to | `country = 'Germany'` |
| `!=` or `<>` | not equal to | `score != 0` |
| `>` `<` `>=` `<=` | greater / less (or equal) | `score > 100` |

**Rule:** Numbers without quotes (`0`, `100`). Text with single quotes (`'Germany'`).

---

## Visual cheat sheet — `ORDER BY` (sort rows)

`ORDER BY` **sorts the finished result**. It does not filter. It does not pick columns. It runs **last**.

| Term | Short definition |
| --- | --- |
| `ORDER BY` | Sort the result set after it is built |
| `ASC` | Ascending — lowest → highest / A → Z (**default**) |
| `DESC` | Descending — highest → lowest / Z → A |
| Nested `ORDER BY` | Sort by the first column, then use the next as a **tie-breaker** |

Always write `ASC` or `DESC` even though `ASC` is the default — it is easier to read.

### What you type (reading order)

```sql
SELECT *                     -- ① you write this first
FROM customers               -- ② you write this second
ORDER BY score DESC;         -- ③ you write this last
```

### What actually runs (execution order)

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers                                         │
│           ↓  load rows                                           │
│                                                                  │
│  STEP 2   SELECT *                                               │
│           ↓  pick columns (build the result)                     │
│                                                                  │
│  STEP 3   ORDER BY score DESC                                    │
│           ↓  sort that result  ← SORT HERE (last)                │
└──────────────────────────────────────────────────────────────────┘
```

**Not** `FROM` → `ORDER BY` → `SELECT`. You sort the **result**, not the table. Proof: a `SELECT` alias works in `ORDER BY` (SELECT already ran), but that same alias fails in `WHERE` (WHERE runs before SELECT).

```sql
SELECT first_name AS name
FROM customers
ORDER BY name;   -- works  → SELECT happened, then ORDER BY
```

**Memory hook:** **F**rom → **S**elect → **O**rder → **FSO**. With a filter: **F**rom → **W**here → **S**elect → **O**rder → **FWSO**.

```mermaid
flowchart TD
    A["① FROM customers<br/><i>Load the table</i>"] --> B["② SELECT columns<br/><i>Build the result</i>"]
    B --> C["③ ORDER BY<br/><i>Sort the result</i>"]
    C --> D["Sorted rows returned to you"]

    style C fill:#d1ecf1,stroke:#0c5460
```

### Sort picture — `ORDER BY score DESC`

```
  unsorted result              ORDER BY score DESC
  ┌────────┬───────┐           ┌────────┬───────┐
  │ Anna   │    42 │           │ Ben    │   100 │  ← highest first
  │ Ben    │   100 │  ──────►  │ Cara   │    85 │
  │ Cara   │    85 │           │ Anna   │    42 │  ← lowest last
  └────────┴───────┘           └────────┴───────┘
```

`ASC` is the same picture flipped: `42` then `85` then `100`.

### Nested sort — `country ASC, score DESC`

First group by country (A → Z). Then, **inside each country**, highest score first.

```
  unsorted                 ① country ASC              ② then score DESC
  ┌─────────┬─────┐        ┌─────────┬─────┐          ┌─────────┬─────┐
  │ USA     │  10 │        │ Germany │  42 │          │ Germany │  85 │
  │ Germany │  42 │  ───►  │ Germany │  85 │   ───►   │ Germany │  42 │
  │ USA     │ 100 │        │ USA     │  10 │          │ USA     │ 100 │
  │ Germany │  85 │        │ USA     │ 100 │          │ USA     │  10 │
  └─────────┴─────┘        └─────────┴─────┘          └─────────┴─────┘
                           countries grouped          tie-breaker inside group
```

### Examples from `order-by.sql`

| Goal | Clause |
| --- | --- |
| Highest score first | `ORDER BY score DESC` |
| Lowest score first | `ORDER BY score ASC` |
| Country A→Z, then highest score | `ORDER BY country ASC, score DESC` |

**Rule:** Left column is the main sort. Each extra column only breaks ties.

---

## Visual cheat sheet — `GROUP BY` (collapse rows)

`GROUP BY` **combines rows that share the same value** into one row, then **aggregates** a column for that group.

| Term | Short definition |
| --- | --- |
| `GROUP BY col` | One output row per distinct value of `col` |
| Aggregate | A calc over the group: `SUM`, `COUNT`, `AVG`, `MIN`, `MAX` |
| `SUM(score)` | Add the scores inside the group |
| `COUNT(id)` | Count customers (non-null `id`s) in the group |
| `AS alias` | Rename the result column (`total_score`) |
| Extra `GROUP BY` columns | Finer groups — each unique **pair** (country + name) |

**Golden rule:** every `SELECT` column is either in `GROUP BY` **or** inside an aggregate. `SELECT first_name` with `GROUP BY country` alone will fail.

### What you type (reading order)

```sql
SELECT
    country,            -- ① you write this first (category)
    SUM(score)          --    and the aggregate
FROM customers          -- ② you write this second
GROUP BY country;       -- ③ you write this third
```

### What actually runs (execution order)

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers                                         │
│           ↓  load rows                                           │
│                                                                  │
│  STEP 2   GROUP BY country                                       │
│           ↓  bucket rows that share a country  ← GROUP HERE      │
│                                                                  │
│  STEP 3   SELECT country, SUM(score)                             │
│           ↓  one row per bucket + the total                      │
└──────────────────────────────────────────────────────────────────┘
```

`ORDER BY` still runs **after** `SELECT` if you add it. `WHERE` still runs **before** `GROUP BY` (filter rows, then group).

**Memory hook:** **F**rom → **G**roup → **S**elect → **FGS**. With a filter: **FWGSO**.

```mermaid
flowchart TD
    A["① FROM customers<br/><i>Load the table</i>"] --> B["② GROUP BY country<br/><i>One bucket per country</i>"]
    B --> C["③ SELECT country, SUM(score)<br/><i>One row + total per bucket</i>"]
    C --> D["Summarised rows returned to you"]

    style B fill:#e2d5f1,stroke:#6f42c1
```

### Collapse picture — `GROUP BY country` + `SUM(score)`

```
  customers (detail)              GROUP BY country
  ┌─────────┬───────┐             ┌─────────┬────────────┐
  │ Germany │    85 │             │ Germany │  85+42=127 │  ← 1 row
  │ Germany │    42 │   ──────►   │ USA     │ 100+10=110 │  ← 1 row
  │ USA     │   100 │             └─────────┴────────────┘
  │ USA     │    10 │             many rows → few rows
  └─────────┴───────┘
```

### Two aggregates — `SUM` and `COUNT`

```
  Germany bucket                  SELECT result
  ┌─────────┬───────┐             ┌─────────┬─────────────┬─────────────────┐
  │ Germany │    85 │   ──────►   │ Germany │ total_score │ total_customers │
  │ Germany │    42 │             │         │     127     │        2        │
  └─────────┴───────┘             └─────────┴─────────────┴─────────────────┘
```

### Extra grouping column — `GROUP BY country, first_name`

Finer buckets. `Germany + Anna` and `Germany + Ben` stay **two** rows, not one.

```
  GROUP BY country                GROUP BY country, first_name
  ┌─────────┬─────┐               ┌─────────┬────────┬─────┐
  │ Germany │ 127 │   ──────►     │ Germany │ Anna   │  85 │
  │ USA     │ 110 │               │ Germany │ Ben    │  42 │
  └─────────┴─────┘               │ USA     │ Cara   │ 100 │
                                  └─────────┴────────┴─────┘
  coarse (one per country)        fine (one per country + name)
```

### Examples from `group-by.sql`

| Goal | What to write |
| --- | --- |
| Total score per country | `SELECT country, SUM(score) ... GROUP BY country` |
| Total score per country **and** name | `GROUP BY country, first_name` (both columns in `SELECT` too) |
| Score total + customer count | `SUM(score) AS total_score, COUNT(id) AS total_customers` |

**Rule:** `GROUP BY` answers “per what?” — per country, or per country and name. Aggregates answer “what number for that group?”

---

## Visual cheat sheet — `WHERE` vs `HAVING` (two filters)

Two gates, two moments:

| Term | Short definition |
| --- | --- |
| `WHERE` | Filter **rows** **before** grouping |
| `HAVING` | Filter **groups** **after** aggregation |
| `AVG(score)` | Average of `score` inside the group |
| `HAVING AVG(score) > 430` | Keep only groups whose average is above 430 |

`HAVING` needs `GROUP BY`. `WHERE` cannot use `SUM` / `AVG` / `COUNT` — those numbers do not exist yet.

### What you type (reading order)

```sql
SELECT
    country,
    AVG(score) AS avg_score   -- ① you write this first
FROM customers                -- ②
WHERE score != 0              -- ③  row filter
GROUP BY country              -- ④
HAVING AVG(score) > 430;      -- ⑤  group filter
```

### What actually runs (execution order)

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers                                         │
│           ↓  load rows                                           │
│                                                                  │
│  STEP 2   WHERE score != 0                                       │
│           ↓  drop individual rows  ← ROW FILTER                  │
│                                                                  │
│  STEP 3   GROUP BY country                                       │
│           ↓  bucket remaining rows                               │
│                                                                  │
│  STEP 4   HAVING AVG(score) > 430                                │
│           ↓  drop whole countries  ← GROUP FILTER                │
│                                                                  │
│  STEP 5   SELECT country, AVG(score)                             │
│           ↓  show the groups that survived                       │
└──────────────────────────────────────────────────────────────────┘
```

**Memory hook:** **W**here = **w**hen still rows. **H**aving = **h**as been grouped. **FWGHSO**.

```mermaid
flowchart TD
    A["① FROM customers<br/><i>All rows</i>"] --> B["② WHERE score != 0<br/><i>Drop score-0 customers</i>"]
    B --> C["③ GROUP BY country<br/><i>One bucket per country</i>"]
    C --> D["④ HAVING AVG(score) > 430<br/><i>Drop countries with a low average</i>"]
    D --> E["⑤ SELECT country, avg_score<br/><i>Show surviving groups</i>"]

    style B fill:#fff3cd,stroke:#856404
    style D fill:#f8d7da,stroke:#721c24
```

### Two-gate picture (from `having-where-filter.sql`)

```
  customers              WHERE score != 0         GROUP BY + AVG          HAVING AVG > 430
  ┌─────────┬─────┐      ┌─────────┬─────┐        ┌─────────┬─────┐       ┌─────────┬─────┐
  │ Germany │   0 │ ✗    │ Germany │ 500 │        │ Germany │ 500 │ ✓     │ Germany │ 500 │
  │ Germany │ 500 │ ✓    │ USA     │ 200 │        │ USA     │ 250 │ ✗     └─────────┴─────┘
  │ USA     │ 200 │ ✓    │ USA     │ 300 │        └─────────┴─────┘        USA dropped as a group
  │ USA     │ 300 │ ✓    └─────────┴─────┘        Germany 500, USA (200+300)/2
  └─────────┴─────┘      0-score row gone
       row gate                 then group                    then group gate
```

`WHERE` never sees `AVG`. `HAVING` never sees the dropped `score = 0` row — it was already gone.

### `WHERE` vs `HAVING` (pick one)

| Question | Use |
| --- | --- |
| Drop **customers** (score is 0) | `WHERE score != 0` |
| Drop **countries** (average is too low) | `HAVING AVG(score) > 430` |

Wrong: `WHERE AVG(score) > 430` — aggregation has not run yet.

### Example from `having-where-filter.sql`

| Goal | Clause |
| --- | --- |
| Ignore zero scores | `WHERE score != 0` |
| Average per country | `GROUP BY country` + `AVG(score)` |
| Keep high-average countries only | `HAVING AVG(score) > 430` |

**Rule:** filter **rows** with `WHERE`, filter **groups** with `HAVING`.

---

## Visual cheat sheet — `DISTINCT` (drop duplicates)

`DISTINCT` keeps **each selected value once**. Repeated rows disappear.

| Term | Short definition |
| --- | --- |
| `SELECT DISTINCT col` | Unique list of `col` — each value appears **once** |
| Duplicate | The same selected row appearing more than once |
| Cost | Extra work (sort/hash) — skip it if the data is already unique |

**Habit:** do not add `DISTINCT` “just in case.” Use it when you truly want a unique list.

### What you type (reading order)

```sql
SELECT DISTINCT country   -- ① unique list
FROM customers;           -- ②
```

### What actually runs (execution order)

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers                                         │
│           ↓  load rows                                           │
│                                                                  │
│  STEP 2   SELECT country                                         │
│           ↓  pick the column (Germany, Germany, USA, USA …)      │
│                                                                  │
│  STEP 3   DISTINCT                                               │
│           ↓  drop repeats  ← DEDUPE HERE (part of SELECT)        │
└──────────────────────────────────────────────────────────────────┘
```

`DISTINCT` lives **inside** `SELECT`, after grouping/having, **before** `ORDER BY`.

**Memory hook:** `DISTINCT` = “each value **once**.” Not a filter like `WHERE`. Not a total like `GROUP BY`.

```mermaid
flowchart TD
    A["① FROM customers<br/><i>All customer rows</i>"] --> B["② SELECT country<br/><i>Country on every row</i>"]
    B --> C["③ DISTINCT<br/><i>Keep each country once</i>"]
    C --> D["Unique country list"]

    style C fill:#d4edda,stroke:#155724
```

### Dedupe picture — `SELECT DISTINCT country`

```
  SELECT country                 SELECT DISTINCT country
  ┌─────────┐                    ┌─────────┐
  │ Germany │                    │ Germany │  ← once
  │ Germany │                    │ USA     │  ← once
  │ USA     │         ──────►    └─────────┘
  │ USA     │                    4 rows → 2 rows
  │ USA     │
  └─────────┘
  repeats kept                   repeats gone
```

### Whole-row rule

`DISTINCT` looks at **every column you selected**, as one row.

```
  SELECT DISTINCT country, first_name
  ┌─────────┬────────┐
  │ Germany │ Anna   │  ← kept
  │ Germany │ Ben    │  ← kept (same country, different name)
  │ Germany │ Anna   │  ← dropped (exact pair already seen)
  └─────────┴────────┘
```

Same country twice is fine if the names differ. Only **identical pairs** collapse.

### `DISTINCT` vs `GROUP BY`

| Goal | Use |
| --- | --- |
| Unique list, no totals | `SELECT DISTINCT country` |
| Totals / counts / averages | `GROUP BY country` + `SUM` / `COUNT` / `AVG` |

Do not use `DISTINCT` to hide a bad join. If rows should already be unique, fix the query instead.

### Example from `distinct.sql`

| Goal | What to write |
| --- | --- |
| Unique list of countries | `SELECT DISTINCT country FROM customers` |

**Rule:** need a unique list → `DISTINCT`. Already unique → leave it off.

---

## Files in this folder

| File | What it covers |
| --- | --- |
| [usedb&comments.sql](usedb%26comments.sql) | `USE` and single-line / multi-line comments |
| [select&from.sql](select%26from.sql) | `SELECT *` and selected columns from `customers` and `orders` |
| [where-clause.sql](where-clause.sql) | Filter rows with `WHERE` (`!=`, `=`, text vs numbers) |
| [order-by.sql](order-by.sql) | Sort rows with `ORDER BY` (`ASC`, `DESC`, nested keys) |
| [group-by.sql](group-by.sql) | Collapse rows with `GROUP BY` (`SUM`, `COUNT`, extra keys) |
| [having-where-filter.sql](having-where-filter.sql) | Filter rows with `WHERE`, then groups with `HAVING` |
| [distinct.sql](distinct.sql) | Unique values with `SELECT DISTINCT` |

---

## Quick reminders

- **`USE MyDatabase;`** — tells SQL Server which database to use (run before your query).
- **`SELECT *`** — all columns; **`SELECT col1, col2`** — only the columns you list.
- **`FROM table_name`** — where the rows come from; the engine processes this **first**.
- **`WHERE condition`** — filter rows **after** `FROM`, **before** grouping.
- **`GROUP BY col`** — one row per value of `col`; pair it with `SUM` / `COUNT` / `AVG` (and `AS` aliases). Extra keys make finer groups.
- **`HAVING condition`** — filter **groups** after aggregation (`HAVING AVG(score) > 430`). Not a row filter.
- **`SELECT DISTINCT col`** — unique list; each selected row once. Skip it if data is already unique.
- **`ORDER BY col ASC|DESC`** — sort the result **last**. Nested columns are tie-breakers.
- Comments: `-- one line` or `/* many lines */` — ignored by the engine, for you only.
