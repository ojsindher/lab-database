-- Query 1: How did the carbon content trend from one process to the next?
SELECT * FROM carbon_content_trend
WHERE experiment_id = 1  -- Replace with your experiment ID
ORDER BY collection_time;

-- Query 2: Can the data from the combustion analyzer be trusted?
SELECT *
FROM instrument_calibration_status
WHERE unique_identifier LIKE '%combustion%';

-- Query 3: Compare current batch with previous batch
SELECT 
    e.experiment_id,
    mb1.batch_number as current_batch,
    mb2.batch_number as comparison_batch,
    pt.name as process_type,
    ar1.value as current_result,
    ar2.value as previous_result,
    ((ar1.value::decimal - ar2.value::decimal) / ar2.value::decimal * 100) 
    as percentage_difference
FROM experiments e
JOIN material_batches mb1 ON e.batch_id = mb1.batch_id
JOIN material_batches mb2 ON e.comparison_batch_id = mb2.batch_id
JOIN processes p ON e.experiment_id = p.experiment_id
JOIN process_types pt ON p.process_type_id = pt.process_type_id
JOIN samples s ON p.process_id = s.process_id
JOIN sample_analyses sa ON s.sample_id = sa.sample_id
JOIN analysis_results ar1 ON sa.analysis_id = ar1.analysis_id
JOIN analysis_results ar2 ON sa.analysis_id = ar2.analysis_id
WHERE ar1.parameter_name = ar2.parameter_name
ORDER BY e.experiment_id, pt.name;
