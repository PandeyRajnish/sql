# SQL Server

Practice scripts for SQL Server, organized by topic. Open a topic below to read the notes and jump into the `.sql` files.

## Topics

| # | Topic |
| --- | --- |
| 1 | [Query data with SELECT](query-data-select/README.md) |
| 2 | [Create, alter, and drop tables](ddl/README.md) |
| 3 | [Insert, update, and delete rows](dml/README.md) |
| 4 | [Filter rows with WHERE](filtering-data/README.md) |
| 5 | [Combine tables with joins](<joins(columns-rows)/README.md>) |

### 1. [Query data with SELECT](query-data-select/README.md)

`USE`, comments, `SELECT`, `FROM`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, `DISTINCT`, `TOP`

- [Topic notes](query-data-select/README.md)
- [usedb&comments.sql](query-data-select/usedb%26comments.sql)
- [select&from.sql](query-data-select/select%26from.sql)
- [where-clause.sql](query-data-select/where-clause.sql)
- [order-by.sql](query-data-select/order-by.sql)
- [group-by.sql](query-data-select/group-by.sql)
- [having-where-filter.sql](query-data-select/having-where-filter.sql)
- [distinct.sql](query-data-select/distinct.sql)
- [top.sql](query-data-select/top.sql)

### 2. [Create, alter, and drop tables](ddl/README.md)

`CREATE TABLE`, `ALTER TABLE` (`ADD`, `DROP COLUMN`, `ALTER COLUMN`), `DROP TABLE`

- [Topic notes](ddl/README.md)
- [create-alter-drop.sql](ddl/create-alter-drop.sql)

### 3. [Insert, update, and delete rows](dml/README.md)

`INSERT` (`VALUES` and `SELECT`), `UPDATE`, `DELETE`, `TRUNCATE TABLE`

- [Topic notes](dml/README.md)
- [insert-update-delete.sql](dml/insert-update-delete.sql)

### 4. [Filter rows with WHERE](filtering-data/README.md)

Comparison operators, `AND` / `OR` / `NOT`, `BETWEEN`, `IN`, `LIKE`

- [Topic notes](filtering-data/README.md)
- [filtering-data.sql](filtering-data/filtering-data.sql)

### 5. [Combine tables with joins](<joins(columns-rows)/README.md>)

No join (two separate results), `INNER JOIN` (matches only), `LEFT JOIN` / `RIGHT JOIN` (keep one side), then one file per remaining join type (`FULL`, `CROSS`)

- [Topic notes](<joins(columns-rows)/README.md>)
- [no-join.sql](<joins(columns-rows)/no-join.sql>)
- [inner-join.sql](<joins(columns-rows)/inner-join.sql>)
- [left-join.sql](<joins(columns-rows)/left-join.sql>)
- [right-join.sql](<joins(columns-rows)/right-join.sql>)

## Add a new topic

1. Create a kebab-case folder at the repo root, for example `filtering-where`.
2. Copy [templates/topic-readme.md](templates/topic-readme.md) into that folder as `README.md`.
3. Copy [templates/query.sql](templates/query.sql) or add your own `.sql` files.
4. Add a row and a short section in this README so the new topic is clickable from GitHub.

Keep related files in the same folder. One idea per file when you can, with a short comment at the top.
