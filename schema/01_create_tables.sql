-- Material Batches
CREATE TABLE material_batches (
    batch_id SERIAL PRIMARY KEY,
    material_type VARCHAR(100),
    supplier_id INTEGER,
    received_date TIMESTAMP,
    quantity_received DECIMAL,
    units VARCHAR(50),
    status VARCHAR(50)
);

-- Scientists
CREATE TABLE scientists (
    scientist_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

-- Process Types
CREATE TABLE process_types (
    process_type_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    standard_duration INTERVAL,
    sequence_order INTEGER,
    requires_temperature_control BOOLEAN,
    requires_atmosphere_control BOOLEAN
);

-- Equipment Types
CREATE TABLE equipment_types (
    equipment_type_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    max_temperature DECIMAL,
    temperature_controlled BOOLEAN,
    atmosphere_controlled BOOLEAN,
    batch_capacity DECIMAL
);

-- Production Equipment
CREATE TABLE production_equipment (
    equipment_id SERIAL PRIMARY KEY,
    equipment_type_id INTEGER REFERENCES equipment_types(equipment_type_id),
    unique_identifier VARCHAR(100) UNIQUE,
    location_id INTEGER,
    installation_date DATE,
    status VARCHAR(50)
);

-- Experiments
CREATE TABLE experiments (
    experiment_id SERIAL PRIMARY KEY,
    scientist_id INTEGER REFERENCES scientists(scientist_id),
    batch_id INTEGER REFERENCES material_batches(batch_id),
    comparison_batch_id INTEGER REFERENCES material_batches(batch_id),
    name VARCHAR(200),
    description TEXT,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    status VARCHAR(50),
    objective TEXT
);

-- Processes
CREATE TABLE processes (
    process_id SERIAL PRIMARY KEY,
    experiment_id INTEGER REFERENCES experiments(experiment_id),
    process_type_id INTEGER REFERENCES process_types(process_type_id),
    equipment_id INTEGER REFERENCES production_equipment(equipment_id),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR(50)
);

-- Samples
CREATE TABLE samples (
    sample_id SERIAL PRIMARY KEY,
    process_id INTEGER REFERENCES processes(process_id),
    collection_time TIMESTAMP,
    collection_point VARCHAR(50),
    status VARCHAR(50)
);

-- Laboratory Instruments
CREATE TABLE laboratory_instruments (
    instrument_id SERIAL PRIMARY KEY,
    instrument_type_id INTEGER,
    unique_identifier VARCHAR(100) UNIQUE,
    last_calibration_date TIMESTAMP,
    next_calibration_date TIMESTAMP,
    status VARCHAR(50)
);

-- Sample Analyses
CREATE TABLE sample_analyses (
    analysis_id SERIAL PRIMARY KEY,
    sample_id INTEGER REFERENCES samples(sample_id),
    instrument_id INTEGER REFERENCES laboratory_instruments(instrument_id),
    analysis_type VARCHAR(100),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR(50)
);

-- Analysis Results
CREATE TABLE analysis_results (
    result_id SERIAL PRIMARY KEY,
    analysis_id INTEGER REFERENCES sample_analyses(analysis_id),
    parameter_name VARCHAR(100),
    value TEXT,
    units VARCHAR(50),
    timestamp TIMESTAMP
);
