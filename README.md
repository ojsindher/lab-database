# Laboratory Database Management

Database schema for managing laboratory experiments, samples, and analyses.

## Repository Structure
```
lab-data-management/
├── docs/
│   ├── ERD.md
├── schema/
│   ├── 01_create_tables.sql
│   ├── 02_create_views.sql
│   ├── 03_sample_queries.sql
├── .gitignore
└── README.md
└── .DS_Store
```

## Assumptions
1. Only one scientist is defining an experiment
2. Only one piece of equipment is used for a process
3. Only one instrument is used in an analyses
4. The first view assumes that the processes with sequence order = 1 are the only ones that extract the quantity from the batch.
5. The carbon content trend view assumes an analysis result with the parameter 'Carbon Content'.

## Features
- Track experiments and processes
- Manage sample collection and analysis
- Monitor equipment calibration
- Compare material batches
- Analysis result tracking

## Requirements
- PostgreSQL 14+

## Setup

1. Create database:
```sql
CREATE DATABASE lab_management;
```

2. Run the schema files in order:
```bash
psql -d lab_management -f schema/01_create_tables.sql
psql -d lab_management -f schema/02_create_views.sql
```

3. Run example queries:
```bash
psql -d lab_management -f schema/03_sample_queries.sql
```

## Example Queries
See `schema/03_sample_queries.sql` for example queries including:
- Batches with remaining quantity
- Carbon content trend analysis
- Batch comparisons
- Equipment calibration status
