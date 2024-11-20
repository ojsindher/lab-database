-- Carbon Content Trend View
CREATE VIEW carbon_content_trend AS
SELECT 
    e.experiment_id,
    mb.batch_number,
    pt.name as process_step,
    s.collection_time,
    ar.value as carbon_content,
    LAG(ar.value::decimal) OVER (
        PARTITION BY e.experiment_id 
        ORDER BY s.collection_time
    ) as previous_carbon_content,
    CASE 
        WHEN LAG(ar.value::decimal) OVER (
            PARTITION BY e.experiment_id 
            ORDER BY s.collection_time
        ) IS NOT NULL 
        THEN ((ar.value::decimal - LAG(ar.value::decimal) OVER (
            PARTITION BY e.experiment_id 
            ORDER BY s.collection_time
        )) / LAG(ar.value::decimal) OVER (
            PARTITION BY e.experiment_id 
            ORDER BY s.collection_time
        ) * 100)
    END as percentage_change
FROM experiments e
JOIN material_batches mb ON e.batch_id = mb.batch_id
JOIN processes p ON e.experiment_id = p.experiment_id
JOIN process_types pt ON p.process_type_id = pt.process_type_id
JOIN samples s ON p.process_id = s.process_id
JOIN sample_analyses sa ON s.sample_id = sa.sample_id
JOIN analysis_results ar ON sa.analysis_id = ar.analysis_id
WHERE sa.analysis_type = 'total_carbon_content'
ORDER BY e.experiment_id, s.collection_time;

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
