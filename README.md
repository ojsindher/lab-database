# Laboratory Database Management

A simple database schema for managing laboratory experiments, samples, and analyses.

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

## Schema Overview
- Material batch tracking
- Process management
- Equipment tracking
- Sample management
- Analysis results
- Calibration tracking

## Example Queries
See `schema/03_sample_queries.sql` for example queries including:
- Carbon content trend analysis
- Equipment calibration status
- Batch comparisons
