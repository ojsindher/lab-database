# Entity Relationship Diagram

```mermaid
erDiagram
    scientists ||--o{ experiments : conducts
    scientists ||--o{ samples : collects
    scientists ||--o{ sample_analyses : performs

    experiments ||--o{ processes : contains
    
    processes }o--|| production_equipment : uses
    processes }o--|| process_types : follows
    
    samples }o--|| processes : generated-in
    samples }o--|| sample_collection_points : collected-at
    
    sample_analyses }o--|| samples : analyzes
    sample_analyses }o--|| analysis_types : uses
    sample_analyses }o--|| laboratory_instruments : performed-with
    
    processes }o--o{ process_type_parameters : has
    sample_analyses }o--o{ analysis_parameters : requires
    
    production_equipment }o--|| equipment_types : is-type-of
    production_equipment }o--|| locations : located-at
    
    laboratory_instruments }o--|| instrument_types : is-type-of
    laboratory_instruments }o--|| locations : located-at
    
    instrument_types ||--o{ instrument_analysis_capabilities : supports
    instrument_analysis_capabilities }o--|| analysis_types : capable-of
    
    sample_analyses ||--o{ analysis_results : generates

    % Entities with relationships
    scientists {
        int scientist_id
        string name
        string email
    }
    
    experiments {
        int experiment_id
        int scientist_id
        string name
        string status
    }
    
    processes {
        int process_id
        int experiment_id
        int process_type_id
        int equipment_id
        string status
    }
    
    samples {
        int sample_id
        int process_id
        int collection_point_id
        string sample_identifier
        string status
    }
    
    sample_analyses {
        int analysis_id
        int sample_id
        int analysis_type_id
        int instrument_id
        string status
    }
    
    production_equipment {
        int equipment_id
        int equipment_type_id
        int location_id
        string unique_identifier
        string status
    }
    
    laboratory_instruments {
        int instrument_id
        int instrument_type_id
        int location_id
        string unique_identifier
        string status
    }
