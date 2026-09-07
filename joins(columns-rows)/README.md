# Combine tables with joins

[← All topics](../README.md)

A **join** puts columns from **two (or more) tables into one result**, matching rows that belong together. This folder starts with **no join** — two separate queries, two separate grids — then one `.sql` file per join type as you add them.

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

    subgraph later ["A join — later files"]
        C2["FROM customers"] --> J["JOIN orders ON key"]
        J --> R3["One result: columns from both"]
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
| Customer name **and** their order on **one row** | ✗ two grids | ✓ `JOIN … ON` |
| Customers who never ordered | ✓ still in grid 1 | depends on join type |

**Rule:** need one combined grid → use a join. Need two independent lists → two `SELECT`s (this file).

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
| **INNER JOIN** | Only rows that **match** on both sides | `inner-join.sql` |
| **LEFT JOIN** | All left rows + matches (unmatched left → `NULL` on the right) | `left-join.sql` |
| **RIGHT JOIN** | All right rows + matches (unmatched right → `NULL` on the left) | `right-join.sql` |
| **FULL JOIN** | All rows from **both**; `NULL` where there is no match | `full-join.sql` |
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

---

## Quick reminders

- **Two `SELECT`s** — two result sets. That is **no join**.
- **One `SELECT` + `JOIN` + `ON`** — one result; columns from both tables on the same row.
- **`SELECT * FROM customers`** then **`SELECT * FROM orders`** — full dump of each table, no matching.
- You **cannot** answer “who bought what?” in a single grid until you join.
- **INNER** = matches only. **LEFT** / **RIGHT** = keep that side even without a match. **FULL** = keep both sides. **CROSS** = every pairing.
- Add **one `.sql` file per join**, then a cheat sheet for that file on this page.
