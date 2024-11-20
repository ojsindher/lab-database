# Entity Relationship Diagram

```mermaid
erDiagram
    MATERIAL_BATCHES ||--o{ EXPERIMENTS : "used_in"
    SCIENTISTS ||--o{ EXPERIMENTS : "conducts"
    EQUIPMENT_TYPES ||--o{ PRODUCTION_EQUIPMENT : "categorizes"
    PRODUCTION_EQUIPMENT ||--o{ PROCESSES : "used_in"
    PROCESS_TYPES ||--o{ PROCESSES : "defines"
    EXPERIMENTS ||--o{ PROCESSES : "contains"
    PROCESSES ||--o{ SAMPLES : "produces"
    LABORATORY_INSTRUMENTS ||--o{ SAMPLE_ANALYSES : "performs"
    SAMPLES ||--o{ SAMPLE_ANALYSES : "undergoes"
    SAMPLE_ANALYSES ||--o{ ANALYSIS_RESULTS : "generates"

    MATERIAL_BATCHES {
        int batch_id PK
        string material_type
        int supplier_id
        timestamp received_date
        decimal quantity_received
        string units
        string status
    }

    SCIENTISTS {
        int scientist_id PK
        string name
        string email
    }

    PROCESS_TYPES {
        int process_type_id PK
        string name
        string description
        interval standard_duration
        int sequence_order
        boolean requires_temperature_control
        boolean requires_atmosphere_control
    }

    EQUIPMENT_TYPES {
        int equipment_type_id PK
        string name
        string description
        decimal max_temperature
        boolean temperature_controlled
        boolean atmosphere_controlled
        decimal batch_capacity
    }

    PRODUCTION_EQUIPMENT {
        int equipment_id PK
        int equipment_type_id FK
        string unique_identifier UNIQUE
        int location_id
        date installation_date
        string status
    }

    EXPERIMENTS {
        int experiment_id PK
        int scientist_id FK
        int batch_id FK
        string name
        string description
        timestamp start_date
        timestamp end_date
        string status
        string objective
    }

    PROCESSES {
        int process_id PK
        int experiment_id FK
        int process_type_id FK
        int equipment_id FK
        timestamp start_time
        timestamp end_time
        string status
    }

    PROCESS_PARAMETERS {
        int process_parameter_id PK
        int process_id FK
        string parameter_name
        string value
        timestamp timestamp
        string parameter_type
        string units
        boolean is_controlled
    }

    SAMPLES {
        int sample_id PK
        int process_id FK
        timestamp collection_time
        string collection_point
        string status
    }

    LABORATORY_INSTRUMENTS {
        int instrument_id PK
        int instrument_type_id
        string unique_identifier UNIQUE
        timestamp last_calibration_date
        timestamp next_calibration_date
        string status
    }

    SAMPLE_ANALYSES {
        int analysis_id PK
        int sample_id FK
        int instrument_id FK
        string analysis_type
        timestamp start_time
        timestamp end_time
        string status
    }

    ANALYSIS_RESULTS {
        int result_id PK
        int analysis_id FK
        string parameter_name
        string value
        string units
        timestamp timestamp
    }
```
