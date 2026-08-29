# SQL Server

Practice scripts for SQL Server, organized by topic so each lesson stays in its own folder.

## Folder layout

```text
sql-server/
├── README.md
├── .gitignore
├── .gitattributes
├── query-data-select/     # USE, comments, SELECT, FROM
└── (add the next topic folder here)
```

Put every new topic in its own folder at the repo root. Keep related `.sql` files together in that folder.

## Add a new topic

1. Create a folder named in kebab-case, for example `filtering-where` or `joins`.
2. Copy `templates/topic-readme.md` into that folder as `README.md` and fill it in.
3. Copy `templates/query.sql` as a starting script, or add your own `.sql` files.
4. Keep one idea per file when you can, with a short comment at the top describing what it does.

Suggested order as you go:

| Folder | Topic |
| --- | --- |
| `query-data-select` | `USE`, comments, `SELECT`, `FROM` |
| `filtering-where` | `WHERE`, comparison and logical operators |
| `sorting-order-by` | `ORDER BY`, `TOP`, `OFFSET` / `FETCH` |
| `joins` | `INNER`, `LEFT`, `RIGHT`, `FULL`, `CROSS` |
| `grouping-aggregates` | `GROUP BY`, `HAVING`, aggregate functions |
| `subqueries-cte` | subqueries, CTEs |
| `data-modify` | `INSERT`, `UPDATE`, `DELETE` |
| `tables-constraints` | `CREATE TABLE`, keys, constraints |

Those extra folders are not created yet. Add each one when you start that topic.

## GitHub

This repo is ready to track on GitHub:

- `.gitignore` keeps backups, database files, and secrets out of git
- each topic folder is a self-contained set of scripts
- this README is the landing page on GitHub

When you want this on GitHub, say so and we can create the remote and push.
