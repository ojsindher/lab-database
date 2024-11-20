# Entity Relationship Diagram

```mermaid
erDiagram
    scientists {
        SERIAL scientist_id PK
        VARCHAR name
        VARCHAR email UNIQUE
        TIMESTAMP created_at
    }

    locations {
        SERIAL location_id PK
        VARCHAR name
        VARCHAR type
        TEXT address
    }

    equipment_types {
        SERIAL equipment_type_id PK
        VARCHAR name
        TEXT description
    }

    production_equipment {
        SERIAL equipment_id PK
        INTEGER equipment_type_id FK
        VARCHAR unique_identifier UNIQUE
        INTEGER location_id FK
        DATE installation_date
        VARCHAR status
    }

    process_types {
        SERIAL process_type_id PK
        VARCHAR name
        TEXT description
    }

    process_type_parameters {
        SERIAL parameter_id PK
        INTEGER process_type_id FK
        VARCHAR parameter_name
        VARCHAR parameter_type
        VARCHAR data_type
        VARCHAR units
        BOOLEAN is_required
    }

    experiments {
        SERIAL experiment_id PK
        INTEGER scientist_id FK
        VARCHAR name
        TEXT description
        TIMESTAMP start_date
        TIMESTAMP end_date
        VARCHAR status
    }

    processes {
        SERIAL process_id PK
        INTEGER experiment_id FK
        INTEGER process_type_id FK
        INTEGER equipment_id FK
        TIMESTAMP start_time
        TIMESTAMP end_time
        VARCHAR status
    }

    process_parameters {
        SERIAL process_parameter_id PK
        INTEGER process_id FK
        INTEGER parameter_id FK
        TEXT value
        TIMESTAMP timestamp
    }

    sample_collection_points {
        SERIAL collection_point_id PK
        VARCHAR name
    }

    samples {
        SERIAL sample_id PK
        INTEGER process_id FK
        INTEGER collection_point_id FK
        INTEGER collected_by FK
        TIMESTAMP collection_time
        VARCHAR sample_identifier UNIQUE
        VARCHAR status
    }

    instrument_types {
        SERIAL instrument_type_id PK
        VARCHAR name
        TEXT description
        INTEGER calibration_frequency_days
    }

    laboratory_instruments {
        SERIAL instrument_id PK
        INTEGER instrument_type_id FK
        VARCHAR unique_identifier UNIQUE
        INTEGER location_id FK
        TIMESTAMP last_calibration_date
        TIMESTAMP next_calibration_date
        VARCHAR status
    }

    analysis_types {
        SERIAL analysis_type_id PK
        VARCHAR name
        TEXT description
        VARCHAR result_type
    }

    instrument_analysis_capabilities {
        SERIAL capability_id PK
        INTEGER instrument_type_id FK
        INTEGER analysis_type_id FK
    }

    analysis_parameters {
        SERIAL parameter_id PK
        INTEGER analysis_type_id FK
        VARCHAR parameter_name
        VARCHAR data_type
        VARCHAR units
        BOOLEAN is_required
    }

    sample_analyses {
        SERIAL analysis_id PK
        INTEGER sample_id FK
        INTEGER analysis_type_id FK
        INTEGER instrument_id FK
        INTEGER performed_by FK
        TIMESTAMP start_time
        TIMESTAMP end_time
        VARCHAR status
    }

    analysis_results {
        SERIAL result_id PK
        INTEGER analysis_id FK
        INTEGER parameter_id FK
        TEXT value
        VARCHAR file_path
        TIMESTAMP timestamp
    }

    scientists ||--o{ experiments : "performs"
    experiments ||--o{ processes : "has"
    processes ||--o{ process_parameters : "sets"
    processes ||--o{ samples : "generates"
    samples ||--o{ sample_analyses : "used in"
    sample_analyses ||--o{ analysis_results : "produces"
    analysis_types ||--o{ analysis_parameters : "defines"
    analysis_types ||--o{ instrument_analysis_capabilities : "supported by"
    process_types ||--o{ process_type_parameters : "has"
    equipment_types ||--o{ production_equipment : "used by"
    instrument_types ||--o{ laboratory_instruments : "includes"
    instrument_types ||--o{ instrument_analysis_capabilities : "supports"
    locations ||--o{ laboratory_instruments : "hosts"
    locations ||--o{ production_equipment : "contains"
```
