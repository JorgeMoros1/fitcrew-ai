-- FitCrew strength_sessions seed data
-- Jorge's training log Apr 2025 - Mar 2026
-- load_kg field stores original recorded values (lbs for machines/dumbbells)

BEGIN TRANSACTION;

INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-21', 'Barbell bench press', 1, 10, 70, '35 each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-21', 'Dumbbell overhead press', 1, 11, 35, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-21', 'Incline press machine', 1, 6, 45, 'plate each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-21', 'Lateral raises', 1, 7, 22.5, 'shit reps');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-21', 'Dips weighted', 1, 7, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-21', 'Tricep cable push forward', 1, 10, 36, '35/37.5');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-24', 'Incline press machine', 1, 11, 55, 'plate+10 each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-24', 'Dumbbell overhead press', 1, 11, 35, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-24', 'Chest fly machine', 1, 10, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-24', 'Lateral raises', 1, 10, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-24', 'Chest press machine', 1, 10, 110, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-24', 'Dips weighted', 1, 8, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-24', 'Tricep cable push forward', 2, 10, 40, '37.5x12/42.5x9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-26', 'Pull ups', 3, 9, 0, 'BW 10/10/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-26', 'T-bar row', 1, 12, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-26', 'Lat pulldown', 1, 8, 60, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-26', 'Straight bar curl', 1, 12, 40, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-28', 'Dumbbell overhead press', 1, 13, 37.5, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-28', 'Chest press machine', 1, 10, 90, 'stack');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-28', 'Lateral raises', 1, 10, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-28', 'Chest fly machine', 1, 10, 11, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-28', 'Incline press machine', 1, 7, 55, 'plate+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-28', 'Dips weighted', 1, 10, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-28', 'Tricep cable push', 1, 11, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-30', 'Pull ups', 3, 10, 0, 'BW 13/11/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-30', 'T-bar row', 1, 11, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-30', 'Lat pulldown narrow diagonal', 1, 10, 120, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-04-30', 'Incline bench curls', 1, 10, 20, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-01', 'Incline press machine', 1, 9, 70, 'plate+25 each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-01', 'Dumbbell overhead press', 1, 9, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-01', 'Chest fly machine', 2, 12, 10, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-01', 'Lateral raises', 1, 10, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-01', 'Chest press machine', 1, 10, 110, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-01', 'Dips weighted', 1, 10, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-07', 'Incline press machine', 1, 10, 70, 'plate+25 each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-07', 'Dumbbell overhead press', 1, 10, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-07', 'Chest fly machine', 1, 9, 27.5, 'corner machine');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-07', 'Lateral raises', 1, 8, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-07', 'Chest press machine', 1, 9, 120, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-07', 'Dips weighted', 1, 8, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-08', 'Pull ups', 3, 10, 3, 'BW/BW/+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-08', 'T-bar row', 1, 10, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-08', 'Lat pulldown narrow diagonal', 1, 10, 120, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-08', 'Incline bench curls', 1, 10, 20, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-08', 'Rope cable curls', 1, 10, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-11', 'Incline press machine', 1, 9, 70, 'plate+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-11', 'Dumbbell overhead press', 1, 7, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-11', 'Lateral raises', 1, 11, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-11', 'Chest press machine', 1, 8, 110, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-11', 'Dips weighted', 1, 10, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-12', 'Pull ups', 4, 7, 9, '+25/+25/+10/BW');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-12', 'T-bar row', 1, 13, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-12', 'Lat pulldown narrow diagonal', 1, 10, 120, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-12', 'Rope cable curls', 1, 12, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-14', 'Incline press machine', 4, 9, 70, 'plate+25 4 sets');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-14', 'Dumbbell overhead press', 1, 10, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-14', 'Chest fly machine', 4, 9, 30, 'at rows 4 sets');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-14', 'Lateral raises', 1, 12, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-14', 'Dips weighted', 1, 10, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-16', 'Pull ups', 3, 6, 23, '+45/+25/BW 5/5/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-16', 'T-bar row', 1, 14, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-16', 'Lat pulldown narrow diagonal', 1, 11, 120, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-16', 'Rope cable curls', 1, 10, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-18', 'Incline dumbbell press', 4, 11, 50, 'per hand 5 incline');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-18', 'Dumbbell overhead press', 1, 7, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-18', 'Chest fly machine', 4, 10, 11, '4 sets');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-18', 'Tricep cable push forward', 4, 10, 42.5, '4 sets');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-19', 'Pull ups', 3, 12, 0, 'BW 19/10/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-19', 'T-bar row', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-19', 'Lat pulldown narrow diagonal', 1, 11, 120, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-19', 'Rope cable curls', 1, 10, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-21', 'Incline dumbbell press', 4, 11, 50, 'per hand form check');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-21', 'Dumbbell overhead press', 1, 8, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-21', 'Chest fly machine', 4, 13, 27.5, 'corner machine');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-21', 'Tricep cable push forward', 1, 12, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-22', 'Pull ups', 3, 9, 8, '+25/BW/BW 7/11/10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-22', 'T-bar row', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-22', 'Rope cable curls', 1, 6, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-28', 'Incline press machine', 4, 12, 55, 'plate+10 back from vacation');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-28', 'Dumbbell overhead press', 1, 8, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-28', 'Lateral raises', 1, 12, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-28', 'Tricep cable push forward', 4, 14, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-29', 'Pull ups', 3, 11, 8, 'BW16/+25x7/BW10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-29', 'T-bar row', 1, 8, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-29', 'Lat pulldown narrow diagonal', 1, 10, 120, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-05-29', 'Rope cable curls', 1, 6, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-01', 'Incline press machine', 4, 12, 55, 'plate+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-01', 'Dumbbell overhead press', 1, 8, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-01', 'Lateral raises', 1, 14, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-01', 'Tricep cable push forward', 4, 20, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-02', 'Pull ups', 2, 14, 0, 'BW 17/11');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-02', 'Lat pulldown narrow diagonal', 1, 11, 120, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-04', 'Incline dumbbell press', 4, 10, 45, '30deg incline');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-04', 'Smith machine overhead press', 2, 9, 35, '35x5 warmup/25x13');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-04', 'Chest fly machine', 4, 11, 30, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-04', 'Tricep cable push forward', 4, 20, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-05', 'Pull ups', 3, 10, 7, '+10/+10/BW 12/8/10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-05', 'T-bar row wider grip', 1, 15, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-05', 'Lat pulldown narrow diagonal', 1, 10, 140, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-05', 'Rope cable curls', 1, 10, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-16', 'Pull ups', 3, 9, 0, 'BW 11/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-16', 'T-bar row wider grip', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-16', 'Lat pulldown narrow diagonal', 1, 8, 140, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-19', 'Pull ups', 3, 11, 0, 'BW 15/10/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-19', 'T-bar row wider grip', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-19', 'Lat pulldown narrow diagonal', 1, 8, 140, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-23', 'Incline dumbbell press', 1, 10, 60, 'per hand 30deg');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-23', 'Smith machine overhead press', 1, 10, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-23', 'Chest fly machine', 1, 8, 30, 'row machines');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-23', 'Tricep cable push down', 1, 12, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-24', 'Pull ups', 3, 9, 0, 'BW 14/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-24', 'T-bar row wider grip', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-24', 'Lat pulldown dropset', 3, 7, 140, '160/140/120');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-26', 'Incline dumbbell press', 2, 8, 57, '55x10/60x7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-26', 'Smith machine overhead press', 1, 11, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-26', 'Tricep cable push down', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-27', 'Pull ups', 3, 10, 7, '+10/+10/BW');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-27', 'T-bar row wider grip', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-06-27', 'Lat pulldown narrow diagonal', 1, 10, 140, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-08', 'Incline dumbbell press', 1, 10, 47.5, 'per hand after gap');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-08', 'Smith machine overhead press', 1, 8, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-08', 'Tricep cable push down', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-09', 'Pull ups', 3, 10, 3, '+10/BW/BW 13/8/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-09', 'T-bar row wider grip', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-09', 'Lat pulldown narrow', 1, 12, 140, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-11', 'Incline press machine', 1, 9, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-11', 'Dumbbell overhead press', 1, 13, 42.5, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-11', 'Lateral raises', 1, 15, 17.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-11', 'Tricep cable push down', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-14', 'Pull ups', 3, 9, 8, 'BW17/+10x8/BW6');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-14', 'T-bar row wider grip', 1, 8, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-14', 'Lat pulldown narrow parallel', 1, 12, 140, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-16', 'Incline press machine', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-16', 'Smith machine overhead press', 1, 10, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-16', 'Lateral raises', 1, 20, 20, 'half reps shoulder pain');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-16', 'Tricep cable push down', 1, 12, 57.5, 'bit of left elbow pain noted');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-22', 'Pull ups', 3, 9, 7, '+10/BW/BW 12/10/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-22', 'Lat pulldown narrow diagonal', 1, 8, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-24', 'Barbell bench press', 1, 5, 135, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-24', 'Dumbbell overhead press', 1, 10, 42.5, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-24', 'Tricep cable push down', 1, 12, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-25', 'Pull ups', 3, 11, 8, '+25x7/BWx15/BWx10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-25', 'Lat pulldown narrow diagonal', 1, 8, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-28', 'Incline dumbbell press', 1, 10, 42.5, 'fixing form narrow elbows');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-28', 'Smith machine overhead press', 1, 11, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-28', 'Chest fly machine', 1, 12, 32.5, 'corner');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-28', 'Tricep cable push down', 1, 12, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-29', 'Pull ups', 3, 12, 5, '+10x15/BWx13/BWx8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-29', 'T-bar row wider grip', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-29', 'Lat pulldown narrow diagonal', 1, 10, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-07-29', 'Cable curl', 1, 10, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-05', 'Incline press machine', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-05', 'Smith machine overhead press', 1, 10, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-05', 'Chest fly machine', 1, 14, 32.5, 'corner');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-05', 'Lateral raises', 1, 10, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-05', 'Tricep cable push down', 2, 12, 46, '42.5 then 50');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-06', 'Pull ups', 3, 9, 12, '+25/+10/BW');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-06', 'T-bar row wider grip', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-06', 'Lat pulldown narrow diagonal', 1, 10, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-11', 'Chest press machine', 1, 10, 110, 'Tampa');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-11', 'Dumbbell overhead press', 1, 11, 40, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-11', 'Chest fly machine', 1, 10, 37.5, 'corner');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-11', 'Lateral raises', 1, 12, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-12', 'Pull ups', 3, 12, 0, 'BW 17/10/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-12', 'T-bar row wider grip', 1, 10, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-12', 'Lat pulldown narrow diagonal', 1, 8, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-14', 'Preacher curl', 1, 10, 15, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-14', 'Dumbbell overhead press', 1, 10, 45, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-14', 'Dips BW', 1, 15, 0, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-14', 'Lateral raises', 1, 12, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-18', 'Chest press machine flat wide', 2, 7, 92, '2 plates then 2+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-18', 'Shoulder press machine', 1, 10, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-18', 'Cable lateral raises', 1, 10, 10, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-18', 'Tricep cable push forward', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-19', 'Pull ups muscle up attempts', 1, 8, 0, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-19', 'T-bar row', 1, 6, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-19', 'Lat pulldown', 1, 5, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-20', 'Squat', 3, 3, 215, '205x5 warmup 225x1 failed second');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-20', 'Smith machine RDL', 1, 10, 45, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-20', 'Hip thrust', 1, 10, 135, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-21', 'Dumbbell overhead press', 1, 10, 42.5, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-21', 'Tricep press machine', 1, 10, 130, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-21', 'Preacher curl', 1, 10, 15, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-21', 'Cable lateral raises', 1, 10, 10, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-21', 'Tricep cable push down', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-24', 'Chest press cable machine', 1, 8, 45, 'apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-24', 'Smith machine overhead press', 1, 7, 45, 'apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-24', 'Chest fly', 1, 8, 35, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-24', 'Lateral raises', 1, 10, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-24', 'Tricep cable pull up', 1, 10, 40, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-25', 'Pull ups weighted', 3, 6, 20, '+25x7/+25x5/+10x7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-25', 'High row machine', 1, 6, 115, '2 plates+25 per side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-25', 'T-bar row', 1, 8, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-25', 'Bicep curl machine', 1, 7, 90, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-26', 'Squat', 2, 4, 210, '205x5/215x4');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-26', 'Hip thrust', 1, 10, 135, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-26', 'Dumbbell RDL', 1, 10, 42.5, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-27', 'Barbell bench press', 2, 7, 125, '115x8/135x6');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-27', 'Standing overhead press', 1, 10, 10, 'light');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-27', 'Dips weighted', 1, 10, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-27', 'Chest fly', 1, 12, 10, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-27', 'Lateral raises', 1, 18, 17.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-28', 'Lat pulldown shoulder width', 1, 8, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-28', 'Seated row individual grips', 1, 8, 60, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-28', 'Reverse fly machine', 1, 10, 85, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-28', 'T-bar row', 1, 12, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-28', 'EZ bar curl', 1, 15, 15, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-31', 'Incline chest press', 1, 6, 70, '45+25 apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-31', 'Smith machine overhead press', 1, 6, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-31', 'Chest fly', 1, 7, 14, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-31', 'Lateral raises', 1, 10, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-08-31', 'Tricep cable pull up', 1, 10, 40, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-02', 'Lat pulldown wide grip', 1, 7, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-02', 'Low row machine', 1, 7, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-02', 'High row machine', 1, 6, 115, '2 plates+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-02', 'Reverse fly machine', 1, 7, 100, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-02', 'EZ bar curl', 1, 8, 20, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-03', 'Squat', 4, 4, 208, 'warmup/135/185/205x2/225x3/185x6');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-03', 'Hip thrust', 1, 10, 135, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-03', 'Smith machine RDL', 1, 10, 45, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-04', 'Incline dumbbell press', 1, 12, 45, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-04', 'Overhead press machine', 1, 10, 45, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-04', 'Lateral raises', 1, 10, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-04', 'Dips machine', 1, 10, 150, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-05', 'Pull ups narrow grip', 1, 10, 0, 'apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-05', 'High pull machine', 1, 10, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-05', 'Low row', 1, 10, 90, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-05', 'Incline bench dumbbell curls', 1, 10, 20, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-09', 'Incline chest press', 1, 6, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-09', 'Smith machine overhead press', 1, 5, 50, '45+5');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-09', 'Chest fly', 1, 9, 14, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-09', 'Lateral raises', 1, 10, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-09', 'Tricep cable pull up', 1, 10, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-10', 'Lat pulldown wide grip', 1, 7, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-10', 'T-bar row wide grip', 1, 6, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-10', 'High row machine', 1, 6, 115, '2 plates+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-10', 'EZ bar curl', 1, 7, 25, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-11', 'Squat', 1, 4, 225, 'top set RPE 8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-11', 'Smith machine RDL', 1, 10, 45, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-11', 'Hip thrust', 1, 5, 245, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-16', 'Incline chest press', 1, 6, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-16', 'Overhead press machine', 1, 5, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-16', 'Lateral raises', 1, 10, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-16', 'Tricep cable pull up', 1, 10, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-17', 'Lat pulldown wide grip', 2, 6, 170, '180 then 160');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-17', 'Low row machine', 1, 7, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-17', 'T-bar row wide grip', 1, 7, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-17', 'Reverse fly machine', 1, 7, 100, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-17', 'EZ bar curl', 1, 8, 20, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-22', 'Incline chest press', 1, 7, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-22', 'Overhead press machine', 1, 6, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-22', 'Lateral raises', 1, 12, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-22', 'Tricep cable pull up', 1, 11, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-23', 'Lat pulldown wide grip', 1, 7, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-23', 'Low row machine', 1, 7, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-23', 'T-bar row wide grip', 1, 8, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-23', 'Reverse fly machine', 1, 8, 100, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-23', 'EZ bar curl', 1, 8, 25, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-26', 'Incline dumbbell press', 1, 12, 50, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-26', 'Smith machine overhead press', 1, 12, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-26', 'Lateral raises', 1, 15, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-26', 'Dips machine', 1, 11, 165, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-29', 'Lat pulldown', 1, 10, 140, 'apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-29', 'High pull machine', 1, 13, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-29', 'Incline bench dumbbell curls', 1, 10, 25, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-30', 'Incline chest press', 1, 7, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-30', 'Overhead press machine', 1, 8, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-30', 'Lateral raises', 1, 11, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-09-30', 'Tricep cable pull up', 1, 11, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-06', 'Lat pulldown wide grip', 1, 8, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-06', 'Low row machine', 1, 8, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-06', 'T-bar row wide grip', 1, 5, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-06', 'EZ bar curl', 1, 8, 25, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-07', 'Overhead press machine', 1, 7, 60, '45+15');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-07', 'Incline chest press', 1, 6, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-07', 'Lateral raises', 1, 8, 25, '+partials');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-07', 'Tricep cable pull up', 1, 12, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-09', 'Lat pulldown', 1, 12, 140, 'apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-09', 'High pull machine', 1, 13, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-09', 'Rope hammer curl', 1, 10, 40, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-10', 'Incline dumbbell press', 1, 12, 50, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-10', 'Overhead press machine', 1, 12, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-10', 'Chest fly machine', 1, 13, 37, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-10', 'Lateral raises', 1, 10, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-10', 'Dips weighted', 1, 12, 25, 'upright tricep focus');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-13', 'Lat pulldown wide grip', 1, 6, 180, 'tough');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-13', 'Low row machine', 1, 9, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-13', 'Preacher curl', 1, 10, 15, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-13', 'Rope hammer curl', 1, 14, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-14', 'Overhead press machine', 1, 9, 60, '45+15');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-14', 'Incline chest press', 1, 8, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-14', 'Lateral raises', 1, 8, 27.5, '+partials');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-14', 'Tricep cable pull up', 1, 12, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-14', 'Chest fly machine', 1, 10, 43, 'near entrance');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-16', 'Incline dumbbell press', 1, 13, 55, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-16', 'Lateral raises', 1, 15, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-16', 'T-bar row', 1, 12, 60, '45+15');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-16', 'Rope tricep push down', 1, 12, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-16', 'Rope hammer curl', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-21', 'Incline chest press', 1, 7, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-21', 'Overhead press machine', 1, 8, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-21', 'Lateral raises', 1, 12, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-21', 'Tricep cable pull up', 1, 12, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-23', 'Lat pulldown wide grip', 1, 8, 165, '160+mass');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-23', 'T-bar row wide grip', 1, 9, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-23', 'Preacher curl', 1, 12, 15, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-23', 'Rope hammer curl', 1, 15, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-24', 'Incline dumbbell press', 1, 13, 55, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-24', 'Overhead press machine', 1, 13, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-24', 'Lateral raises', 1, 14, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-24', 'Dips weighted', 1, 12, 25, 'upright tricep focus');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-28', 'Pull ups', 3, 10, 0, 'BW 14/9/6');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-28', 'T-bar row', 1, 10, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-28', 'Rope hammer curl', 1, 15, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-29', 'Incline chest press', 1, 9, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-29', 'Overhead press machine', 1, 11, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-29', 'Lateral raises', 1, 11, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-29', 'Tricep cable pull up', 1, 12, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-31', 'Lat pulldown', 1, 7, 175, 'fatigued');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-31', 'Incline dumbbell press', 1, 13, 50, 'max was 50lb');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-10-31', 'Lateral raises', 1, 10, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-04', 'Lat pulldown wide grip', 1, 9, 165, '160+mass');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-04', 'T-bar row wide grip', 1, 9, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-04', 'Preacher curl', 1, 11, 20, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-04', 'Rope hammer curl', 1, 8, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-05', 'Incline dumbbell press', 2, 10, 60, '55x14/65x6');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-05', 'Dumbbell overhead press', 2, 6, 47, '50x5/45x7 per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-05', 'Chest fly machine', 1, 8, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-05', 'Tricep cable push forward', 1, 10, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-07', 'Pull ups', 3, 9, 7, '+10x12/+10x9/BWx7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-07', 'Low row', 1, 11, 70, '45+25');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-07', 'Preacher curl', 1, 12, 20, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-07', 'Rope hammer curl', 1, 8, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-10', 'Incline press machine', 1, 10, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-10', 'Overhead press machine', 1, 12, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-10', 'Chest fly near entrance', 1, 12, 40, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-10', 'Lateral raises', 1, 14, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-10', 'Dips weighted', 1, 12, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-11', 'Lat pulldown', 1, 7, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-11', 'T-bar row wide grip', 1, 9, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-11', 'Rope hammer curl', 1, 8, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-13', 'Incline chest press', 1, 5, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-13', 'Dumbbell overhead press', 1, 7, 50, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-13', 'Chest fly near entrance', 1, 7, 47, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-13', 'Lateral raises', 1, 7, 25, '+partials');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-13', 'Tricep cable push down', 1, 9, 57.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-14', 'Pull ups', 3, 8, 10, '+20x8/+10x9/BWx8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-14', 'Low row', 1, 10, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-14', 'Preacher curl', 1, 10, 22.5, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-14', 'Rope hammer curl', 1, 9, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-17', 'Incline dumbbell press', 1, 10, 60, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-17', 'Dumbbell overhead press', 1, 10, 45, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-17', 'Dips BW lower chest', 1, 17, 0, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-17', 'Lateral raises', 1, 15, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-17', 'Tricep push down', 1, 15, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-18', 'Lat pulldown', 1, 8, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-18', 'T-bar row wide grip', 1, 9, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-18', 'Rope hammer curl', 1, 9, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-18', 'Dumbbell bicep curls', 1, 10, 30, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-20', 'Incline chest press', 1, 7, 90, '2 plates PR');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-20', 'Overhead press machine', 2, 6, 62, '45+25x4.5/45+15x7.5');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-20', 'Chest fly near entrance', 1, 10, 47, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-20', 'Lateral raises', 1, 8, 27.5, '+partials');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-20', 'Tricep cable push down', 1, 11, 57.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-21', 'Pull ups', 3, 9, 10, '+20x10/+20x6.5/BWx11');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-21', 'Low row', 1, 11, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-21', 'Bicep curl machine', 1, 11, 9, 'hoist stack');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-11-21', 'Dumbbell hammer curl', 1, 12, 32.5, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-03', 'Incline chest press', 1, 8, 80, '1 plate+35 back from vacation');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-03', 'Overhead press machine', 1, 7, 55, '45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-03', 'Lateral raises', 1, 10, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-03', 'Tricep cable push down', 1, 11, 57.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-04', 'Lat pulldown', 1, 7, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-04', 'T-bar row wide grip', 1, 8, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-04', 'Preacher curl', 1, 10, 20, 'per side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-04', 'Rope hammer curl', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-07', 'Incline dumbbell press', 1, 12, 50, 'slow eccentric apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-07', 'Dumbbell overhead press', 1, 13, 45, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-07', 'Lateral raises', 1, 15, 22.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-07', 'Tricep push down', 1, 13, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-08', 'Pull ups', 3, 8, 12, '+25x8/+10x8/BWx8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-08', 'Low row', 1, 12, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-08', 'Preacher curl', 1, 15, 15, 'per side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-08', 'Rope hammer curl', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-10', 'Incline chest press', 1, 7, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-10', 'Overhead press machine', 1, 8, 60, '45+15');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-10', 'Lateral raises', 1, 10, 27.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-10', 'Tricep cable push down', 1, 15, 57.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-11', 'Lat pulldown', 1, 9, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-11', 'T-bar row wide grip', 1, 10, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-11', 'Reverse fly machine', 1, 8, 115, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-11', 'Preacher curl', 1, 9, 22.5, 'per side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-11', 'Rope hammer curl', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-12', 'Incline dumbbell press', 1, 10, 65, 'per hand shaky short ROM apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-12', 'Smith machine overhead press', 1, 8, 45, 'each side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-12', 'Lateral raises', 1, 10, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-16', 'Overhead press machine', 1, 11, 60, '45+15');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-16', 'Incline chest press', 1, 6, 90, '2 plates maybe tired');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-16', 'Lateral raises', 1, 10, 27.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-16', 'Tricep cable push down', 1, 10, 65, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-17', 'Lat pulldown', 1, 8, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-17', 'Reverse fly machine', 1, 7, 120, '100 better');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-17', 'T-bar row wide grip', 1, 10, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-17', 'Rope hammer curl', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-18', 'Incline dumbbell press', 1, 10, 50, 'apt gym accessory');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-18', 'Lateral raises', 1, 15, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-19', 'Incline dumbbell press', 1, 10, 60, 'clean full ROM no shake');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-19', 'Overhead press machine', 1, 9, 60, '45+15');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-19', 'Lateral raise machine', 1, 10, 60, 'stack');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-19', 'Tricep push down rope', 1, 8, 60, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-23', 'Pull ups', 3, 9, 12, '+25x8/+10x10/BWx10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-23', 'Low row', 1, 14, 80, '45+35');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-23', 'Preacher curl machine', 1, 15, 35, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-23', 'Rope hammer curl', 1, 11, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-24', 'Incline chest press', 1, 10, 55, 'new loaded machine 45+10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-24', 'Smith machine overhead press', 1, 7, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-24', 'Tricep cable push down', 1, 16, 57.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-24', 'Lateral raises', 1, 8, 30, '+partials');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-24', 'Chest fly machine', 1, 8, 100, 'near hip thrust');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-26', 'Lat pulldown', 1, 8, 180, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-26', 'Reverse fly machine', 1, 12, 100, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-26', 'T-bar row wide grip', 1, 11, 90, '2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-26', 'Rope hammer curl', 1, 10, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-30', 'Incline dumbbell press', 1, 10, 60, 'cruise');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-30', 'Dumbbell overhead press', 1, 7, 50, 'per hand cruise');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-30', 'Lateral raises', 1, 10, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-30', 'Tricep push down rope', 1, 10, 42.5, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-31', 'Pull ups', 3, 10, 0, 'BW 16/9/6 cruise');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-31', 'Low row machine stack', 1, 8, 160, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2025-12-31', 'Dumbbell bicep curls', 1, 10, 30, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-04', 'Tricep press machine', 1, 10, 175, 'cruise');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-04', 'Dumbbell overhead press', 1, 8, 50, 'per hand');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-04', 'Chest press machine', 1, 7, 100, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-04', 'Lateral raises', 1, 10, 25, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-07', 'Incline dumbbell press', 1, 10, 60, 'elbow conscious');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-07', 'Lat pulldown', 1, 8, 170, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-07', 'Lateral raise machine', 1, 12, 40, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-07', 'Rope tricep pulldown', 1, 12, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-07', 'Chest support seated row', 1, 9, 140, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-08', 'Lat pulldown', 3, 8, 180, '9/7/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-08', 'T-bar row wide neutral', 3, 8, 90, '2 plates 9/7/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-08', 'Reverse chest fly', 3, 8, 100, '10/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-09', 'Incline dumbbell press', 3, 9, 60, '3x 10/8/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-09', 'Overhead press machine', 3, 8, 60, '3x per side 8/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-09', 'Chest fly machine', 3, 11, 115, '3x 12/10/10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-09', 'Lateral raises dumbbell', 2, 12, 20, 'stopped slight elbow pain');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-09', 'Tricep rope pulldown', 3, 11, 50, '3x 12/10/10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-12', 'Lat pulldown', 3, 8, 173, '3x 180x9/7/160x8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-12', 'Chest support seated row', 3, 8, 147, '3x 150x10/10/140x4');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-12', 'Reverse chest fly', 3, 10, 100, '3x 12/9/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-12', 'Rope hammer curl', 3, 12, 35, 'felt irritation not pain');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-13', 'Chest press machine', 3, 12, 45, 'apt gym 13/12/10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-13', 'Smith machine overhead press', 3, 9, 45, 'apt gym 10/9/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-13', 'Cable chest fly', 3, 9, 35, 'per side 10/10/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-13', 'Rope tricep pulldown', 3, 10, 50, '11/10/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-13', 'Lateral raises', 3, 11, 20, '13/10/10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-15', 'Lat pulldown narrow', 3, 8, 180, '3x 9/7/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-15', 'T-bar row wide', 3, 10, 90, '3x 11/10/8 2 plates');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-15', 'Reverse chest fly', 3, 9, 100, '3x 11/9/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-15', 'Rope face pulls', 2, 12, 20, '2x 12/12');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-15', 'Rope hammer curls', 2, 12, 40, '2x 12/12');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-16', 'Incline dumbbell press', 1, 8, 65, 'per hand apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-16', 'Smith machine overhead press', 1, 9, 45, 'per side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-16', 'Lateral raises', 1, 12, 20, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-16', 'Chest fly machine', 1, 9, 50, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-20', 'Lat pulldown neutral single handles', 3, 11, 140, '3x 13/12/9 apt gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-20', 'Sitting cable row', 3, 10, 100, '3x 12/10/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-20', 'Rope face pulls', 3, 11, 38, '3x 35x16/11/45x10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-20', 'Rope hammer curls', 3, 10, 35, '3x 13/9/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-23', 'Chest press machine flat', 3, 8, 90, '2 plates 10/5/plate+25x8 miami gym');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-23', 'Overhead press machine', 3, 8, 80, '3x 45+35x10/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-23', 'Chest fly machine', 3, 7, 130, '3x 130x8/6/115x7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-23', 'Lateral raise machine', 3, 10, 40, '3x 12/9/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-23', 'Dips machine', 3, 10, 175, '3x 10/10/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-26', 'Pull ups narrow neutral', 1, 11, 0, 'elbow conscious Miami YouFit');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-26', 'Low row machine', 1, 10, 70, '45+25 per side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-26', 'High row machine', 1, 9, 70, 'per side');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-26', 'Rope hammer curls', 1, 11, 45, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-26', 'Reverse fly machine', 1, 10, 90, '');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-27', 'Chest press machine', 3, 9, 70, '45+25ps 10/9/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-27', 'Dumbbell overhead press', 3, 9, 50, 'per hand 10/10/8 left elbow pain putting down');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-27', 'Double cable chest fly', 3, 9, 36, '32ps x12/40ps x6/32ps x8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-27', 'Lateral raises dumbbell', 3, 8, 25, '10/8/6 +partials');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-27', 'Rope cable pulldown', 3, 10, 50, '55x12/9/47x12');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-29', 'Incline press machine', 4, 9, 80, '45+35 10/6/8/10 warmup sets');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-29', 'Overhead press machine', 3, 9, 55, '45+10 10/8/8 lower due to elbow');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-29', 'Chest fly machine', 3, 8, 130, '3x 10/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-29', 'Lateral raise machine', 3, 9, 50, '3x 11/9/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-29', 'Tricep rope push down', 3, 9, 55, '60x7/50x11/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-30', 'Lat pulldown neutral handles', 3, 8, 170, '3x 175x9/7/160x7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-30', 'T-bar row neutral inclined', 3, 6, 82, '2pl x6/45+35x6/45+25x7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-30', 'Reverse fly machine', 3, 9, 97, '100x9/90x10/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-30', 'Rope hammer curl', 1, 0, 0, 'LEFT ELBOW PAIN STOPPED - injury onset');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-01-30', 'High row machine', 2, 10, 90, '2 plates 12/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-22', 'Lat pulldown neutral', 3, 11, 120, '3x 13/11/10 return from injury');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-22', 'Low cable row', 3, 9, 70, '3x 9/8/8 2sec squeeze slow neg');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-22', 'Reverse cable fly', 3, 12, 7.5, 'per side 14/12/11');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-24', 'Cable chest press machine', 3, 10, 30, 'apt gym 11/10/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-24', 'Overhead cable chest press', 3, 10, 15, 'per side 11/9/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-24', 'Lateral raises', 1, 10, 20, 'bailed small pain');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-24', 'Tricep cable push down', 3, 10, 40, '12/10/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-25', 'Lat pulldown neutral', 3, 9, 130, 'apt gym 11/9/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-25', 'Sitting cable row', 3, 9, 80, '10/8/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-25', 'Reverse cable fly', 3, 12, 7.5, 'per side 14/12/11');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-25', 'Rope hammer curls slow', 2, 12, 8.75, '7.5x15/10x10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-27', 'Incline chest press machine', 3, 8, 70, '45+25 9/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-27', 'Overhead press machine', 3, 9, 55, '45+10 11/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-27', 'Lateral raise machine', 3, 9, 50, '11/10/8');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-02-27', 'Rope push down', 3, 9, 43, '50x9/40x10/9 pressure noted');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-02', 'Lat pulldown narrow MAG', 3, 8, 160, '9/8/6');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-02', 'T-bar row', 3, 9, 62, '45+25x9/7/45+10x10');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-02', 'Reverse fly machine', 3, 8, 87, '90x7/80x9/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-02', 'Rope hammer curl', 2, 10, 15, 'elbow tension not pain');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-04', 'Incline chest press machine', 3, 8, 70, '45+25 10/8/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-04', 'Flat chest press machine', 1, 8, 45, 'didnt like machine');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-04', 'Lateral raise machine', 3, 10, 50, '12/9/9');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-04', 'Chest fly machine', 3, 9, 100, '12/9/7');
INSERT INTO strength_sessions (date, exercise, sets, reps, load_kg, notes) VALUES ('2026-03-04', 'Rope push down', 2, 15, 40, '17/14');

COMMIT;


-- Strength injuries seed
BEGIN TRANSACTION;

INSERT INTO strength_injuries (date_onset, body_part, affected_movements, severity, status) VALUES
  ('2026-01-30', 'medial elbow left', 'rope hammer curls, heavy pushdowns, heavy isolation elbow flexion/extension, overhead with pain on lockout', 3, 'active');

COMMIT;


-- Shared context seed
UPDATE shared_context SET
  current_phase = 'lean_bulk',
  goal = 'hypertrophy',
  body_weight_kg = NULL,
  active_injuries = '[{"body_part": "medial elbow left", "severity": 3, "status": "active", "affected_movements": "rope hammer curls, heavy pushdowns, heavy isolation elbow flexion/extension"}]',
  training_frequency = '4-5 days per week'
WHERE id = 1;


-- Strength summary seed
BEGIN TRANSACTION;

INSERT INTO strength_summary (content, updated_at) VALUES ('Jorge is an intermediate lifter training 4-5 days/week on a Push/Pull/Legs split (autoregulated, not rigid calendar). Primary goal is hypertrophy with a lean bulk phase as of March 2026.

TRAINING STYLE: Tracks numbers precisely, performance-driven, progressive overload oriented. Moderate rest periods, straight sets. Willing to train through mild tension but risk-aware. Abandons exercises that don''t feel right mechanically.

CURRENT CAPACITY (March 2026):
- Incline press machine: 45+25 per side x 10/8/7 (3 sets) — rebuilding from injury, previously hit 2 plates (90lb/side) x 7 in Nov 2025
- Lat pulldown: 160 x 9/8/6 narrow MAG — previously 180 x 9 in Jan 2026
- Overhead press machine: 45+10 per side x 11/8/7 — PR context: 45+25 attempted Nov 2025
- T-bar row: 45+25 x 9/7, 45+10 x 10 — previously 2 plates x 9 in Jan 2026
- Reverse fly: 90 x 7, 80 x 9/7 — previously 115 x 8 in Dec 2025
- Dumbbell overhead press: 45s x 7 (per hand) — previously 50s attempted
- Lateral raises: 50 stack x 12/9/9 (machine)
- Rope hammer curl: 15lb x 10 (severely reduced due to elbow injury)

INJURY HISTORY: Medial elbow irritation (left) onset 1/30/2026 after heavy pull session. Stopped rope hammer curls due to pain. 3+ week upper body pause. Cautious return started 2/22/2026. Late-stage remodeling as of March 2026. Compounds tolerated well, heavy isolation elbow flexion/extension still aggravates. Neutral grip preference. History of shoulder tension 7/16/2025 (resolved).

PROGRAM HISTORY:
- Apr-May 2025: PPL building phase, good progression
- Jun-Jul 2025: Continued building, lat pulldown progressed to 160-180
- Aug 2025: Added squat (225x3 PR 9/11), experimented with legs
- Sep-Nov 2025: Peak strength phase — incline press 2 plates x 7 (11/20 PR), lat pulldown 180 for reps, OHP machine 45+25 attempted
- Dec 2025: Maintenance/cruise over vacation periods
- Jan 2026: Return to structured 3-set format, elbow irritation building
- 1/30/2026: LEFT ELBOW PAIN — stopped training upper
- Feb 2026: Return to training with load modulation
- Mar 2026: Rebuilding — pressing ~95% capacity, pulling ~90%, isolation ~60-70%

GYMS USED: Normal gym (primary), apartment gym (secondary), YouFit Miami, Tampa, cruise ship. Exercises vary by available equipment.

COMPOUND LIFT PEAKS (historical):
- Incline press machine: 2 plates (90/side) x 7 reps (Nov 2025) — PEAK
- Lat pulldown: 180 x 9 (Jan 2026) — PEAK
- Pull ups weighted: +25lb x 8 reps (Nov 2021 comparable)
- T-bar row: 2 plates x 9 (Nov 2025) — PEAK
- Squat: 225 x 4 (Sep 2025) — only trained intermittently
- Barbell bench: 135 x 6 (Aug 2025)

OPEN ITEMS: Continue elbow rehab protocol. Monitor rope hammer curl tolerance. Next milestone: return incline press to 2 plates for reps, lat pulldown back to 175-180.', datetime('now'));

COMMIT;