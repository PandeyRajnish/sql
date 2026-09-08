# Combine tables with joins

[← All topics](../README.md)

A **join** puts columns from **two (or more) tables into one result**, matching rows that belong together. This folder starts with **no join** — two separate queries, two separate grids — then one `.sql` file per join type. **INNER JOIN** keeps matching rows only. **LEFT** / **RIGHT** keep one side. **FULL JOIN** keeps **every** row from both sides, with `NULL` where there is no match.

---

## Visual cheat sheet — no join vs a join

Without a join you **read each table on its own**. With a join you **stitch them** using a shared key (usually `customers.id` = `orders.customer_id`).

| Term | Short definition |
| --- | --- |
| No join | Two `SELECT`s → **two result sets**. Tables are not combined. |
| Join | One `SELECT` with `JOIN` → **one result**. Columns from both tables sit on the same row. |
| Key | The column that says “this order belongs to that customer” |
| Left table | The table named in `FROM` |
| Right table | The table named after `JOIN` |

**Memory hook:** No join = **N**ot glued. Two windows. A join = **one** window, extra columns.

```mermaid
flowchart LR
    subgraph nojoin ["No join — this file"]
        C1["SELECT * FROM customers"] --> R1["Result 1: customers only"]
        O1["SELECT * FROM orders"] --> R2["Result 2: orders only"]
    end

    subgraph inner ["INNER JOIN — inner-join.sql"]
        C2["FROM customers"] --> J["INNER JOIN orders ON key"]
        J --> R3["One result: matching rows only"]
    end

    subgraph leftj ["LEFT JOIN — left-join.sql"]
        C3["FROM customers"] --> L["LEFT JOIN orders ON key"]
        L --> R4["All customers + matching orders"]
    end

    subgraph rightj ["RIGHT JOIN — right-join.sql"]
        C4["FROM customers"] --> R["RIGHT JOIN orders ON key"]
        R --> R5["All orders + matching customers"]
    end

    subgraph fullj ["FULL JOIN — full-join.sql"]
        C5["FROM customers"] --> F["FULL JOIN orders ON key"]
        F --> R6["All customers and all orders"]
    end
```

---

## Visual cheat sheet — no join (two results)

`no-join.sql` runs **two independent queries**. SQL Server returns **two grids**. Nothing is matched. Nothing is filtered by the other table.

| Term | Short definition |
| --- | --- |
| Two statements | Two `SELECT`s, two result tabs in SSMS |
| `SELECT * FROM customers` | Every customer column, every customer row |
| `SELECT * FROM orders` | Every order column, every order row |
| No `ON` clause | No rule that ties a customer to an order |

### What you type (from `no-join.sql`)

```sql
/* Retrieve all the data from customers and orders
   in two different results */

SELECT *
FROM customers;

SELECT *
FROM orders;
```

### What actually happens

```
┌──────────────────────────────────────────────────────────────────┐
│  QUERY 1   FROM customers → SELECT *                             │
│            ↓  result set A  (customers only)                     │
│                                                                  │
│  QUERY 2   FROM orders → SELECT *                                │
│            ↓  result set B  (orders only)                        │
│                                                                  │
│  NOT A JOIN  no matching, no extra columns, no dropped rows      │
└──────────────────────────────────────────────────────────────────┘
```

The second statement does **not** see the first. Order of the two queries only changes which grid appears first.

**Memory hook:** Two `SELECT`s = **two** answers. A join is still **one** `SELECT`.

```mermaid
flowchart TD
    A["① SELECT * FROM customers"] --> B["Grid 1 — customers"]
    C["② SELECT * FROM orders"] --> D["Grid 2 — orders"]

    B -.-> E["No shared row<br/>No ON customer_id"]
    D -.-> E
```

### Two-grid picture — `no-join.sql`

```
  Result 1 — customers              Result 2 — orders
  ┌────┬───────────┬─────────┐      ┌────┬─────────────┬────────────┐
  │ id │ first_name│ country │      │ id │ customer_id │ order_date │
  │  1 │ Maria     │ Germany │      │  1 │           1 │ 2024-01-10 │
  │  2 │ Max       │ USA     │      │  2 │           1 │ 2024-02-03 │
  │  3 │ Ann       │ UK      │      │  3 │           2 │ 2024-03-15 │
  └────┴───────────┴─────────┘      └────┴─────────────┴────────────┘
  you see people                    you see orders
  you do not see who bought what in one row
```

Maria’s orders exist in grid 2 (`customer_id = 1`), but grid 1 never shows `order_date`. You must look with your eyes across two results.

### What you **cannot** do with no join

| Goal | No join | A join (later file) |
| --- | --- | --- |
| List every customer | ✓ `SELECT * FROM customers` | ✓ (and more columns) |
| List every order | ✓ `SELECT * FROM orders` | ✓ |
| Customer name **and** their order on **one row** | ✗ two grids | ✓ `INNER JOIN … ON` |
| Customers who never ordered | ✓ still in grid 1 | ✗ INNER JOIN drops them · ✓ LEFT JOIN keeps them with `NULL` orders |

**Rule:** need one combined grid → use a join. Need two independent lists → two `SELECT`s (this file).

---

## Visual cheat sheet — `INNER JOIN` (matches only)

`INNER JOIN` builds **one result**. It keeps a pair of rows only when the `ON` key matches on **both** sides. Customers with no orders disappear. Orders with no matching customer disappear.

| Term | Short definition |
| --- | --- |
| `INNER JOIN` | Combine tables; keep **matching** rows only |
| `ON a = b` | The match rule (here: customer id = order’s `customer_id`) |
| Left table | Named in `FROM` |
| Right table | Named after `JOIN` |
| Alias | Short name for a table (`customers AS c`) |
| Qualify | `c.id` / `o.order_id` — say **which** table the column is from |
| Filter effect | No match → row is gone. INNER JOIN **combines and filters**. |

For `INNER JOIN`, **table order does not matter**. `FROM customers JOIN orders` and `FROM orders JOIN customers` return the same matches (column order in `SELECT` still follows what you list).

### What you type (best practice from `inner-join.sql`)

```sql
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
INNER JOIN orders AS o
    ON c.id = o.customer_id;
```

Same matches, tables swapped — still INNER:

```sql
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders AS o
INNER JOIN customers AS c
    ON c.id = o.customer_id;
```

### What actually happens

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers AS c                                    │
│           ↓  load customers                                      │
│                                                                  │
│  STEP 2   INNER JOIN orders AS o                                 │
│           ON c.id = o.customer_id                                │
│           ↓  keep only pairs that match  ← FILTER + COMBINE      │
│                                                                  │
│  STEP 3   SELECT c.id, c.first_name, o.order_id, o.sales         │
│           ↓  one row per matching pair                           │
└──────────────────────────────────────────────────────────────────┘
```

**Memory hook:** **INNER** = **IN** both tables. No partner → not in the result.

```mermaid
flowchart TD
    A["① FROM customers AS c"] --> B["② INNER JOIN orders AS o<br/>ON c.id = o.customer_id"]
    B --> C["Keep matching pairs only"]
    C --> D["③ SELECT columns from both"]
    D --> E["One grid — who bought what"]

    style B fill:#d4edda,stroke:#155724
```

### Match picture — only customers who ordered

```
  customers              orders                    INNER JOIN result
  ┌────┬───────┐         ┌──────────┬─────┬──────┐ ┌────┬───────┬──────────┬───────┐
  │  1 │ Maria │ ●───────│ order 10 │  1  │  90  │ │  1 │ Maria │       10 │    90 │
  │  1 │ Maria │ ●───────│ order 11 │  1  │  40  │ │  1 │ Maria │       11 │    40 │
  │  2 │ Max   │ ●───────│ order 12 │  2  │  15  │ │  2 │ Max   │       12 │    15 │
  │  3 │ Ann   │    ✗    │          │     │      │ └────┴───────┴──────────┴───────┘
  └────┴───────┘         │ order 99 │ 99  │  50  │ Ann gone (no order)
                         └──────────┴─────┴──────┘ order 99 gone (no customer)
  one customer × two orders → two result rows (Maria twice)
```

Ann never ordered → dropped. Order `99` has no customer → dropped. Maria ordered twice → **two rows** (that is normal).

### Why not `SELECT *` — `id` twice

```sql
SELECT *
FROM customers
INNER JOIN orders
    ON id = customer_id;   -- ambiguous: both tables have id
```

| Problem | Why it hurts |
| --- | --- |
| `SELECT *` | Every column from **both** tables — `id` appears twice |
| `ON id = customer_id` | SQL Server does not know whose `id` you mean |
| Long names | `customers.first_name` is clear but noisy |

**Habit:** pick the columns you need. Qualify them. Alias the tables.

```sql
SELECT
    customers.id,
    customers.first_name,
    orders.order_id,
    orders.sales
FROM customers
INNER JOIN orders
    ON customers.id = orders.customer_id;
```

Then shorten with aliases (`AS c`, `AS o`) — same query, easier to read.

### Examples from `inner-join.sql`

| Goal | What to write |
| --- | --- |
| Customers **who have** an order | `FROM customers AS c INNER JOIN orders AS o ON c.id = o.customer_id` |
| Name + order id + sales | `SELECT c.id, c.first_name, o.order_id, o.sales` |
| Same matches, `orders` first | `FROM orders AS o INNER JOIN customers AS c ON …` (order of tables does not matter) |
| Avoid duplicate `id` | Do **not** `SELECT *`; list `c.id`, `o.order_id` |

**Rule:** INNER JOIN answers “who has a match?” One result row per matching **pair**, not per customer.

---

## Visual cheat sheet — `LEFT JOIN` (all of the left)

`LEFT JOIN` keeps **every row from the left table** (`FROM`). Matching right-table columns are filled in. If there is no match, those right columns are **`NULL`**. Unmatched right-table rows (orders with no customer) are still dropped.

| Term | Short definition |
| --- | --- |
| `LEFT JOIN` | All left rows + matching right rows |
| Left table | Named in `FROM` — **this side always survives** |
| Right table | Named after `JOIN` — only matches appear; gaps become `NULL` |
| `NULL` on the right | This left row had **no partner** |
| Table order | **Matters.** Swap the tables and you change whose rows are guaranteed |

Unlike `INNER JOIN`, `FROM customers LEFT JOIN orders` is **not** the same as `FROM orders LEFT JOIN customers`.

### What you type (from `left-join.sql`)

```sql
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
LEFT JOIN orders AS o
    ON c.id = o.customer_id;
```

### What actually happens

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers AS c                                    │
│           ↓  load ALL customers  ← LEFT SIDE KEPT                │
│                                                                  │
│  STEP 2   LEFT JOIN orders AS o                                  │
│           ON c.id = o.customer_id                                │
│           ↓  attach matching orders; else NULL  ← PAD GAPS       │
│                                                                  │
│  STEP 3   SELECT c.id, c.first_name, o.order_id, o.sales         │
│           ↓  one row per customer–order pair                     │
│              (or one row with NULL order if none)                │
└──────────────────────────────────────────────────────────────────┘
```

**Memory hook:** **LEFT** = keep the **L**eft. Right is optional. No order → customer still there, order columns empty.

```mermaid
flowchart TD
    A["① FROM customers AS c<br/><i>Every customer</i>"] --> B["② LEFT JOIN orders AS o<br/>ON c.id = o.customer_id"]
    B --> C["Match? attach order"]
    B --> D["No match? order columns NULL"]
    C --> E["③ SELECT columns"]
    D --> E
    E --> F["All customers — with or without orders"]

    style A fill:#d4edda,stroke:#155724
    style D fill:#fff3cd,stroke:#856404
```

### Keep-the-left picture — Ann stays

```
  customers              orders                     LEFT JOIN result
  ┌────┬───────┐         ┌──────────┬─────┬──────┐  ┌────┬───────┬──────────┬───────┐
  │  1 │ Maria │ ●───────│ order 10 │  1  │  90  │  │  1 │ Maria │       10 │    90 │
  │  1 │ Maria │ ●───────│ order 11 │  1  │  40  │  │  1 │ Maria │       11 │    40 │
  │  2 │ Max   │ ●───────│ order 12 │  2  │  15  │  │  2 │ Max   │       12 │    15 │
  │  3 │ Ann   │    ○    │          │     │      │  │  3 │ Ann   │     NULL │  NULL │
  └────┴───────┘         │ order 99 │ 99  │  50  │  └────┴───────┴──────────┴───────┘
                         └──────────┴─────┴──────┘  Ann kept (NULL order)
                                                    order 99 still gone (not on the left)
```

Ann never ordered → **kept**, `order_id` and `sales` are `NULL`. Order `99` has no customer → **not** in this result (it lives on the right). Maria still appears twice.

### `INNER` vs `LEFT` (same `ON`)

| | INNER JOIN | LEFT JOIN (`FROM customers`) |
| --- | --- | --- |
| Maria with two orders | two rows | two rows |
| Max with one order | one row | one row |
| Ann with no order | **dropped** | **kept**, right side `NULL` |
| Order 99, no customer | **dropped** | **dropped** (right-only) |

Put `customers` on the left when the question is “**all customers**, plus orders if they have them.”

### Table order is the question

```
  FROM customers LEFT JOIN orders     FROM orders LEFT JOIN customers
  ┌─────────────────────────────┐     ┌─────────────────────────────┐
  │ every customer              │     │ every order                 │
  │ + matching orders           │     │ + matching customers        │
  │ Ann with NULL order    ✓    │     │ Ann (no order)         ✗    │
  │ order 99               ✗    │     │ order 99 with NULL name ✓   │
  └─────────────────────────────┘     └─────────────────────────────┘
```

`left-join.sql` uses `FROM customers … LEFT JOIN orders` because the comment asks for **all customers**, including those without orders.

### Examples from `left-join.sql`

| Goal | What to write |
| --- | --- |
| All customers, plus orders if any | `FROM customers AS c LEFT JOIN orders AS o ON c.id = o.customer_id` |
| Name + order id + sales (NULL if none) | `SELECT c.id, c.first_name, o.order_id, o.sales` |
| Same as INNER but keep non-buyers | Swap `INNER` for `LEFT`; keep `customers` on the left |

**Rule:** LEFT JOIN answers “everything on the left, matches on the right.” The table in `FROM` is the one you refuse to drop.

---

## Visual cheat sheet — `RIGHT JOIN` (all of the right)

`RIGHT JOIN` keeps **every row from the right table** (after `JOIN`). Matching left-table columns are filled in. If there is no match, those left columns are **`NULL`**. Unmatched left-table rows (customers with no orders) are dropped.

| Term | Short definition |
| --- | --- |
| `RIGHT JOIN` | All right rows + matching left rows |
| Right table | Named after `JOIN` — **this side always survives** |
| Left table | Named in `FROM` — only matches appear; gaps become `NULL` |
| `NULL` on the left | This right row had **no partner** |
| Table order | **Matters** — same idea as `LEFT JOIN`, mirrored |
| Prefer `LEFT` | Same result by swapping tables and using `LEFT JOIN` |

`FROM customers RIGHT JOIN orders` keeps **every order**. A customer with no orders (Ann) does **not** appear.

### What you type (from `right-join.sql`)

Peek at both tables first (optional, like `no-join.sql`):

```sql
SELECT * FROM customers;
SELECT * FROM orders;
```

Then the join:

```sql
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
RIGHT JOIN orders AS o
    ON c.id = o.customer_id;
```

Same result with the preferred habit — put the “keep all” table on the **left**:

```sql
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders AS o
LEFT JOIN customers AS c
    ON c.id = o.customer_id;
```

### What actually happens

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers AS c                                    │
│           ↓  start from customers                                │
│                                                                  │
│  STEP 2   RIGHT JOIN orders AS o                                 │
│           ON c.id = o.customer_id                                │
│           ↓  keep ALL orders; pad missing customers with NULL    │
│                                                                  │
│  STEP 3   SELECT c.id, c.first_name, o.order_id, o.sales         │
│           ↓  one row per order (± customer columns)              │
└──────────────────────────────────────────────────────────────────┘
```

**Memory hook:** **RIGHT** = keep the **R**ight. Left is optional. No customer for an order → order stays, customer columns empty.

```mermaid
flowchart TD
    A["① FROM customers AS c"] --> B["② RIGHT JOIN orders AS o<br/>ON c.id = o.customer_id"]
    B --> C["Match? attach customer"]
    B --> D["No match? customer columns NULL"]
    C --> E["③ SELECT columns"]
    D --> E
    E --> F["All orders — with or without a customer"]

    style B fill:#d1ecf1,stroke:#0c5460
    style D fill:#fff3cd,stroke:#856404
```

### Keep-the-right picture — order 99 stays

```
  customers              orders                      RIGHT JOIN result
  ┌────┬───────┐         ┌──────────┬─────┬──────┐   ┌────┬───────┬──────────┬───────┐
  │  1 │ Maria │ ●───────│ order 10 │  1  │  90  │   │  1 │ Maria │       10 │    90 │
  │  1 │ Maria │ ●───────│ order 11 │  1  │  40  │   │  1 │ Maria │       11 │    40 │
  │  2 │ Max   │ ●───────│ order 12 │  2  │  15  │   │  2 │ Max   │       12 │    15 │
  │  3 │ Ann   │    ✗    │          │     │      │   │NULL│ NULL  │       99 │    50 │
  └────┴───────┘         │ order 99 │ 99  │  50  │   └────┴───────┴──────────┴───────┘
                         └──────────┴─────┴──────┘   order 99 kept (NULL customer)
                                                     Ann gone (not on the right)
```

Order `99` has no customer → **kept**, `id` and `first_name` are `NULL`. Ann never ordered → **not** in this result (she lives only on the left).

### `LEFT` vs `RIGHT` (same question, two spellings)

| Goal | RIGHT JOIN | Equivalent LEFT JOIN (prefer this) |
| --- | --- | --- |
| All **orders**, plus customer if any | `FROM customers RIGHT JOIN orders` | `FROM orders LEFT JOIN customers` |
| All **customers**, plus order if any | `FROM orders RIGHT JOIN customers` | `FROM customers LEFT JOIN orders` |

```
  customers RIGHT JOIN orders          orders LEFT JOIN customers
  ┌──────────────────────────────┐     ┌──────────────────────────────┐
  │ every order                  │     │ every order                  │
  │ + matching customers         │  =  │ + matching customers         │
  │ order 99 with NULL name ✓    │     │ order 99 with NULL name ✓    │
  │ Ann                    ✗     │     │ Ann                    ✗     │
  └──────────────────────────────┘     └──────────────────────────────┘
  same rows — only the join keyword and table order differ
```

**Habit from `right-join.sql`:** learn `RIGHT JOIN`, then rewrite it as `LEFT JOIN` with the keep-all table in `FROM`. Teams use `LEFT` more often; one style is easier to read.

### Examples from `right-join.sql`

| Goal | What to write |
| --- | --- |
| All orders, including orphans | `FROM customers AS c RIGHT JOIN orders AS o ON c.id = o.customer_id` |
| Same result with LEFT | `FROM orders AS o LEFT JOIN customers AS c ON c.id = o.customer_id` |
| Peek before joining | `SELECT * FROM customers;` then `SELECT * FROM orders;` |

**Rule:** RIGHT JOIN answers “everything on the right, matches on the left.” Prefer the same meaning with `LEFT JOIN` and the important table first.

---

## Visual cheat sheet — `FULL JOIN` (all of both)

`FULL JOIN` (also written `FULL OUTER JOIN`) keeps **every row from both tables**. Matching pairs sit on one row. A left-only row gets `NULL` on the right. A right-only row gets `NULL` on the left. Nothing is dropped for lack of a partner.

| Term | Short definition |
| --- | --- |
| `FULL JOIN` | All left rows **and** all right rows |
| Match | Both sides filled on one result row |
| Left-only | Right columns are `NULL` (e.g. Ann with no order) |
| Right-only | Left columns are `NULL` (e.g. order 99 with no customer) |
| Table order | **Does not matter** for which rows survive (same as INNER) — you still pick column order in `SELECT` |

Think: **LEFT ∪ RIGHT** — the union of both outer joins on the same `ON` key.

### What you type (from `full-join.sql`)

```sql
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
FULL JOIN orders AS o
    ON c.id = o.customer_id;
```

### What actually happens

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1   FROM customers AS c                                    │
│           ↓  load customers                                      │
│                                                                  │
│  STEP 2   FULL JOIN orders AS o                                  │
│           ON c.id = o.customer_id                                │
│           ↓  matches + left-only + right-only  ← KEEP EVERYONE   │
│                                                                  │
│  STEP 3   SELECT c.id, c.first_name, o.order_id, o.sales         │
│           ↓  one grid with every customer and every order        │
└──────────────────────────────────────────────────────────────────┘
```

**Memory hook:** **FULL** = **F**rom **U**nmatched on **Left** and **Right**. INNER + leftovers from both sides.

```mermaid
flowchart TD
    A["① FROM customers AS c"] --> B["② FULL JOIN orders AS o<br/>ON c.id = o.customer_id"]
    B --> C["Match → both sides filled"]
    B --> D["Left only → right NULL"]
    B --> E["Right only → left NULL"]
    C --> F["③ SELECT columns"]
    D --> F
    E --> F
    F --> G["All customers and all orders"]

    style B fill:#e2d5f1,stroke:#6f42c1
    style D fill:#fff3cd,stroke:#856404
    style E fill:#d1ecf1,stroke:#0c5460
```

### Keep-everyone picture — Ann **and** order 99

```
  customers              orders                       FULL JOIN result
  ┌────┬───────┐         ┌──────────┬─────┬──────┐    ┌────┬───────┬──────────┬───────┐
  │  1 │ Maria │ ●───────│ order 10 │  1  │  90  │    │  1 │ Maria │       10 │    90 │
  │  1 │ Maria │ ●───────│ order 11 │  1  │  40  │    │  1 │ Maria │       11 │    40 │
  │  2 │ Max   │ ●───────│ order 12 │  2  │  15  │    │  2 │ Max   │       12 │    15 │
  │  3 │ Ann   │    ○    │          │     │      │    │  3 │ Ann   │     NULL │  NULL │
  └────┴───────┘         │ order 99 │ 99  │  50  │    │NULL│ NULL  │       99 │    50 │
                         └──────────┴─────┴──────┘    └────┴───────┴──────────┴───────┘
                                                      Ann kept · order 99 kept
```

Ann never ordered → **kept**, order columns `NULL`. Order `99` has no customer → **kept**, customer columns `NULL`. Matches still appear as usual (Maria twice).

### INNER / LEFT / RIGHT / FULL (same `ON`)

| | INNER | LEFT (`customers`) | RIGHT (`orders`) | FULL |
| --- | --- | --- | --- | --- |
| Maria + orders | ✓ | ✓ | ✓ | ✓ |
| Ann, no order | ✗ | ✓ (`NULL` order) | ✗ | ✓ (`NULL` order) |
| Order 99, no customer | ✗ | ✗ | ✓ (`NULL` name) | ✓ (`NULL` name) |

**FULL** is what you get if you could run LEFT and RIGHT and keep every row from both without dropping the unmatched side of either.

### Table order does not change who survives

```
  FROM customers FULL JOIN orders     FROM orders FULL JOIN customers
  ┌─────────────────────────────┐     ┌─────────────────────────────┐
  │ Ann with NULL order    ✓    │  =  │ Ann with NULL order    ✓    │
  │ order 99 with NULL name ✓   │     │ order 99 with NULL name ✓   │
  └─────────────────────────────┘     └─────────────────────────────┘
  same set of rows — column order in SELECT can still differ
```

### Examples from `full-join.sql`

| Goal | What to write |
| --- | --- |
| Every customer and every order | `FROM customers AS c FULL JOIN orders AS o ON c.id = o.customer_id` |
| Name + order (NULLs where unmatched) | `SELECT c.id, c.first_name, o.order_id, o.sales` |

**Rule:** FULL JOIN answers “show me **everyone** on both sides, matched when possible.” Use it when dropping either unmatched side would hide a problem (orphan orders **and** customers who never bought).

---

## Visual cheat sheet — join family (files to add)

Each join **starts from the same two tables** and keeps a different set of rows. Add one `.sql` file per type; add a matching cheat sheet in this README when you do.

```
  customers          orders
  ● 1 Maria          ● order for 1
  ● 2 Max            ● order for 1
  ● 3 Ann            ● order for 2
                     ● order for 99  ← no matching customer

            match on customers.id = orders.customer_id
```

| Join | Keeps | Typical file to add |
| --- | --- | --- |
| **No join** | Two separate results — nothing matched | [no-join.sql](no-join.sql) |
| **INNER JOIN** | Only rows that **match** on both sides | [inner-join.sql](inner-join.sql) |
| **LEFT JOIN** | All left rows + matches (unmatched left → `NULL` on the right) | [left-join.sql](left-join.sql) |
| **RIGHT JOIN** | All right rows + matches (unmatched right → `NULL` on the left) | [right-join.sql](right-join.sql) |
| **FULL JOIN** | All rows from **both**; `NULL` where there is no match | [full-join.sql](full-join.sql) |
| **CROSS JOIN** | Every left row paired with **every** right row (no `ON`) | `cross-join.sql` |

```mermaid
flowchart TD
    N["No join<br/>two grids"] --> I["INNER<br/>matches only"]
    N --> L["LEFT<br/>all customers"]
    N --> R["RIGHT<br/>all orders"]
    N --> F["FULL<br/>all of both"]
    N --> X["CROSS<br/>every combination"]
```

**Memory hook:** Learn **no join** first so you can see what each join **adds**: extra columns, and a rule for which rows survive.

When you add a file, extend **Files in this folder** and drop in a new “Visual cheat sheet” section under that join’s name — same pattern as this page.

---

## Files in this folder

| File | What it covers |
| --- | --- |
| [no-join.sql](no-join.sql) | Two `SELECT`s — customers and orders as **separate** results |
| [inner-join.sql](inner-join.sql) | `INNER JOIN` — matching rows only; aliases; table order does not matter |
| [left-join.sql](left-join.sql) | `LEFT JOIN` — all left rows; `NULL` on the right when there is no match; table order matters |
| [right-join.sql](right-join.sql) | `RIGHT JOIN` — all right rows; `NULL` on the left when there is no match; same as LEFT with tables swapped |
| [full-join.sql](full-join.sql) | `FULL JOIN` — all rows from both sides; `NULL` where unmatched; table order does not drop rows |

---

## Quick reminders

- **Two `SELECT`s** — two result sets. That is **no join**.
- **`INNER JOIN … ON c.id = o.customer_id`** — one result; **matches only**. No order → customer dropped. No customer → order dropped.
- **`LEFT JOIN`** — **all** left rows (`FROM`). No match → right columns are `NULL`. Table order **matters**.
- **`RIGHT JOIN`** — **all** right rows (after `JOIN`). No match → left columns are `NULL`. Table order **matters**.
- **`FULL JOIN`** — **all** left **and** all right rows. Unmatched sides get `NULL`. Ann **and** order 99 both stay.
- **`FROM customers LEFT JOIN orders`** — every customer, including those with no orders. Order-only rows stay out.
- **`FROM customers RIGHT JOIN orders`** — every order, including those with no customer. Customer-only rows stay out.
- **Prefer LEFT** — `orders LEFT JOIN customers` = `customers RIGHT JOIN orders`. Same rows; `LEFT` is the usual style.
- **One customer, two orders** — two result rows (one per pair). Same for INNER, LEFT, RIGHT, and FULL.
- **Table order does not matter** for `INNER JOIN` or `FULL JOIN` (who survives). For LEFT / RIGHT, the “keep all” side is the one you name as left or right.
- **Aliases** — `FROM customers AS c … JOIN orders AS o`. Qualify columns (`c.id`, `o.sales`).
- **Do not `SELECT *`** — both tables have `id`; pick the columns you need.
- **`ON id = customer_id`** is ambiguous. Write `c.id = o.customer_id`.
- **CROSS** = every pairing (no `ON` match rule).
- Add **one `.sql` file per join**, then a cheat sheet for that file on this page.
