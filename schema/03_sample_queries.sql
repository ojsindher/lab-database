-- Query 1: Select batches that have some remaining quantity.
SELECT batch_id
FROM remaining_batch_quantity
WHERE remaining_quantity > 0;

-- Query 2: How did the carbon content change from one process to the next in an experiment?
SELECT * FROM carbon_content_trend
WHERE experiment_id = 1;  -- Select experiment_id

-- Query 3: Compare two batches
SELECT * FROM batch_carbon_content_comparison 
WHERE batch_1_id = 100 AND batch_2_id = 101;

-- Query 4: Can the data from the combustion analyzer be trusted?
SELECT *
FROM instrument_calibration_status
WHERE unique_identifier LIKE '%combustion%';
