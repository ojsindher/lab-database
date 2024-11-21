-- Remaining batch quantity
CREATE OR REPLACE VIEW remaining_batch_quantity AS
WITH process_quantity_used AS (
    SELECT 
        mb.batch_id,
        mb.material_type,
        mb.quantity_received,
        mb.units,
        pt.sequence_order,
        COALESCE(SUM(p.quantity_used), 0) AS total_quantity_used
    FROM 
        material_batches mb
    JOIN experiments e ON e.batch_id = mb.batch_id
    JOIN processes p ON p.experiment_id = e.experiment_id
    JOIN process_types pt ON pt.process_type_id = p.process_type_id
    WHERE pt.sequence_order = 1
    GROUP BY 
        mb.batch_id, 
        mb.material_type, 
        mb.quantity_received, 
        mb.units,
        pt.sequence_order
)
SELECT 
    batch_id,
    material_type,
    quantity_received,
    total_quantity_used,
    (quantity_received - total_quantity_used) AS remaining_quantity,
    units
FROM 
    process_quantity_used;

-- Carbon Content Trend View
CREATE OR REPLACE VIEW carbon_content_trend AS
WITH carbon_sample_analyses AS (
    SELECT 
        e.experiment_id,
        e.batch_id,
        pt.sequence_order,
        pt.name AS process_name,
        s.collection_point,
        CAST(ar.value AS NUMERIC) AS carbon_content,
        ar.timestamp AS analysis_timestamp
    FROM experiments e
    JOIN processes p ON p.experiment_id = e.experiment_id
    JOIN process_types pt ON pt.process_type_id = p.process_type_id
    JOIN samples s ON s.process_id = p.process_id
    JOIN sample_analyses sa ON sa.sample_id = s.sample_id
    JOIN analysis_results ar ON ar.analysis_id = sa.analysis_id
    WHERE ar.parameter_name = 'Carbon Content'
),
aggregated_carbon_analyses AS (
    SELECT 
        experiment_id,
        batch_id,
        sequence_order,
        process_name,
        collection_point,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY carbon_content) AS carbon_content,
        MIN(analysis_timestamp) AS first_analysis_timestamp,
        MAX(analysis_timestamp) AS last_analysis_timestamp
    FROM 
        carbon_sample_analyses
    GROUP BY 
        experiment_id,
        batch_id,
        sequence_order,
        process_name,
        collection_point
)
SELECT 
    experiment_id,
    batch_id,
    sequence_order,
    process_name,
    collection_point,
    carbon_content,
    first_analysis_timestamp,
    last_analysis_timestamp,
    -- Previous process carbon content
    LAG(carbon_content) OVER (
        PARTITION BY batch_id, process_name
        ORDER BY sequence_order, 
        CASE collection_point 
            WHEN 'start' THEN 1 
            WHEN 'middle' THEN 2 
            WHEN 'end' THEN 3 
            ELSE 4 
        END
    ) AS previous_process_carbon_content,
    -- Next process carbon content
    LEAD(carbon_content) OVER (
        PARTITION BY batch_id, process_name
        ORDER BY sequence_order, 
        CASE collection_point 
            WHEN 'start' THEN 1 
            WHEN 'middle' THEN 2 
            WHEN 'end' THEN 3 
            ELSE 4 
        END
    ) AS next_process_carbon_content,
    -- Absolute change in carbon content
    carbon_content - LAG(carbon_content) OVER (
        PARTITION BY batch_id, process_name
        ORDER BY sequence_order, 
        CASE collection_point 
            WHEN 'start' THEN 1 
            WHEN 'middle' THEN 2 
            WHEN 'end' THEN 3 
            ELSE 4 
        END
    ) AS carbon_content_change,
    -- Percentage change in carbon content
    CASE 
        WHEN LAG(carbon_content) OVER (
            PARTITION BY batch_id, process_name
            ORDER BY sequence_order, 
            CASE collection_point 
                WHEN 'start' THEN 1 
                WHEN 'middle' THEN 2 
                WHEN 'end' THEN 3 
                ELSE 4 
            END
        ) = 0 THEN NULL
        ELSE ROUND(
            (carbon_content - LAG(carbon_content) OVER (
                PARTITION BY batch_id, process_name
                ORDER BY sequence_order, 
                CASE collection_point 
                    WHEN 'start' THEN 1 
                    WHEN 'middle' THEN 2 
                    WHEN 'end' THEN 3 
                    ELSE 4 
                END
            )) / LAG(carbon_content) OVER (
                PARTITION BY batch_id, process_name
                ORDER BY sequence_order, 
                CASE collection_point 
                    WHEN 'start' THEN 1 
                    WHEN 'middle' THEN 2 
                    WHEN 'end' THEN 3 
                    ELSE 4 
                END
            ) * 100, 
            2
        )
    END AS carbon_content_change_percentage
FROM 
    aggregated_carbon_analyses
ORDER BY 
    experiment_id,
    batch_id,
    process_name,
    sequence_order,
    CASE collection_point 
        WHEN 'start' THEN 1 
        WHEN 'middle' THEN 2 
        WHEN 'end' THEN 3 
        ELSE 4 
    END;

-- Instrument Calibration Status View
CREATE VIEW instrument_calibration_status AS
SELECT 
    li.instrument_id,
    li.unique_identifier,
    li.last_calibration_date,
    li.next_calibration_date,
    CASE 
        WHEN li.next_calibration_date <= CURRENT_TIMESTAMP 
        THEN 'OVERDUE'
        WHEN li.next_calibration_date <= CURRENT_TIMESTAMP + INTERVAL '7 days'
        THEN 'DUE_SOON'
        ELSE 'VALID'
    END as calibration_status,
    CURRENT_TIMESTAMP - li.last_calibration_date as time_since_calibration
FROM laboratory_instruments li;
