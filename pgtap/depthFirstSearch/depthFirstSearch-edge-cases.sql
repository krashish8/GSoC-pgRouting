\i setup.sql

SELECT plan(72);



-- 0 edge, 0 vertex tests

PREPARE q1 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table
WHERE id > 18;

-- Graph is empty - it has 0 edge and 0 vertex
SELECT is_empty('q1', 'q1: Graph with 0 edge and 0 vertex');

-- 0 edge, 0 vertex tests (directed)

PREPARE depthFirstSearch2 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    5
);

PREPARE depthFirstSearch3 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    ARRAY[5]
);

PREPARE depthFirstSearch4 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    ARRAY[2, 5]
);

PREPARE depthFirstSearch5 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    5, max_depth => 2
);

PREPARE depthFirstSearch6 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    ARRAY[5], max_depth => 2
);

PREPARE depthFirstSearch7 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    ARRAY[2, 5], max_depth => 2
);

SELECT is_empty('depthFirstSearch2', '2: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch3', '3: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch4', '4: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch5', '5: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch6', '6: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch7', '7: Graph with 0 edge and 0 vertex -> Empty row is returned');

-- 0 edge, 0 vertex tests (undirected)

PREPARE depthFirstSearch8 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    5, directed => false
);

PREPARE depthFirstSearch9 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    ARRAY[5], directed => false
);

PREPARE depthFirstSearch10 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    ARRAY[2, 5], directed => false
);

PREPARE depthFirstSearch11 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    5, max_depth => 2, directed => false
);

PREPARE depthFirstSearch12 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    ARRAY[5], max_depth => 2, directed => false
);

PREPARE depthFirstSearch13 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q1',
    ARRAY[2, 5], max_depth => 2, directed => false
);

SELECT is_empty('depthFirstSearch8', '8: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch9', '9: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch10', '10: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch11', '11: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch12', '12: Graph with 0 edge and 0 vertex -> Empty row is returned');
SELECT is_empty('depthFirstSearch13', '13: Graph with 0 edge and 0 vertex -> Empty row is returned');





-- vertex not present in graph tests

PREPARE q14 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table;

-- pgRouting Sample Data
SELECT isnt_empty('q14', 'q14: pgRouting Sample Data');

-- vertex not present in graph tests (directed)

PREPARE depthFirstSearch14 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    -10
);

PREPARE depthFirstSearch15 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[-10]
);

PREPARE depthFirstSearch16 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[20, -10]
);

PREPARE depthFirstSearch17 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    -10, max_depth => 2
);

PREPARE depthFirstSearch18 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[-10], max_depth => 2
);

PREPARE depthFirstSearch19 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[20, -10], max_depth => 2
);

SELECT is_empty('depthFirstSearch14', '14: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch15', '15: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch16', '16: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch17', '17: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch18', '18: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch19', '19: Vertex not present in graph -> Empty row is returned');

-- vertex not present in graph tests (undirected)

PREPARE depthFirstSearch20 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    -10, directed => false
);

PREPARE depthFirstSearch21 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[-10], directed => false
);

PREPARE depthFirstSearch22 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[20, -10], directed => false
);

PREPARE depthFirstSearch23 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    -10, max_depth => 2, directed => false
);

PREPARE depthFirstSearch24 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[-10], max_depth => 2, directed => false
);

PREPARE depthFirstSearch25 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[20, -10], max_depth => 2, directed => false
);

SELECT is_empty('depthFirstSearch20', '20: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch21', '21: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch22', '22: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch23', '23: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch24', '24: Vertex not present in graph -> Empty row is returned');
SELECT is_empty('depthFirstSearch25', '25: Vertex not present in graph -> Empty row is returned');






-- negative depth tests

PREPARE depthFirstSearch26 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    4, max_depth => -3
);

PREPARE depthFirstSearch27 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[4], max_depth => -3
);

PREPARE depthFirstSearch28 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[4, 20], max_depth => -3
);

PREPARE depthFirstSearch29 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    4, max_depth => -3, directed => false
);

PREPARE depthFirstSearch30 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[4], max_depth => -3, directed => false
);

PREPARE depthFirstSearch31 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q14',
    ARRAY[4, 20], max_depth => -3, directed => false
);

SELECT throws_ok('depthFirstSearch26', 'P0001', 'Negative value found on ''max_depth''', '26: Negative max_depth throws');
SELECT throws_ok('depthFirstSearch27', 'P0001', 'Negative value found on ''max_depth''', '27: Negative max_depth throws');
SELECT throws_ok('depthFirstSearch28', 'P0001', 'Negative value found on ''max_depth''', '28: Negative max_depth throws');
SELECT throws_ok('depthFirstSearch29', 'P0001', 'Negative value found on ''max_depth''', '29: Negative max_depth throws');
SELECT throws_ok('depthFirstSearch30', 'P0001', 'Negative value found on ''max_depth''', '30: Negative max_depth throws');
SELECT throws_ok('depthFirstSearch31', 'P0001', 'Negative value found on ''max_depth''', '31: Negative max_depth throws');





-- 1 vertex tests

PREPARE q32 AS
SELECT id, source, 2 AS target, cost, reverse_cost
FROM edge_table
WHERE id = 2;

-- Graph with only vertex 2
SELECT set_eq('q32', $$VALUES (2, 2, 2, -1, 1)$$, 'q32: Graph with only vertex 2');

-- 1 vertex tests (directed)

PREPARE depthFirstSearch33 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q32',
    2
);

PREPARE depthFirstSearch34 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q32',
    ARRAY[2]
);

PREPARE depthFirstSearch35 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q32',
    2, max_depth => 2
);

PREPARE depthFirstSearch36 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q32',
    ARRAY[2], max_depth => 2
);

SELECT set_eq('depthFirstSearch33', $$VALUES (1, 0, 2, 2, -1, 0, 0)$$, '33: One row with node 2 is returned');
SELECT set_eq('depthFirstSearch34', $$VALUES (1, 0, 2, 2, -1, 0, 0)$$, '34: One row with node 2 is returned');
SELECT set_eq('depthFirstSearch35', $$VALUES (1, 0, 2, 2, -1, 0, 0)$$, '35: One row with node 2 is returned');
SELECT set_eq('depthFirstSearch36', $$VALUES (1, 0, 2, 2, -1, 0, 0)$$, '36: One row with node 2 is returned');

-- 1 vertex tests (undirected)

PREPARE depthFirstSearch37 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q32',
    2, directed => false
);

PREPARE depthFirstSearch38 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q32',
    ARRAY[2], directed => false
);

PREPARE depthFirstSearch39 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q32',
    2, max_depth => 2, directed => false
);

PREPARE depthFirstSearch40 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q32',
    ARRAY[2], max_depth => 2, directed => false
);

SELECT set_eq('depthFirstSearch37', $$VALUES (1, 0, 2, 2, -1, 0, 0)$$, '37: One row with node 2 is returned');
SELECT set_eq('depthFirstSearch38', $$VALUES (1, 0, 2, 2, -1, 0, 0)$$, '38: One row with node 2 is returned');
SELECT set_eq('depthFirstSearch39', $$VALUES (1, 0, 2, 2, -1, 0, 0)$$, '39: One row with node 2 is returned');
SELECT set_eq('depthFirstSearch40', $$VALUES (1, 0, 2, 2, -1, 0, 0)$$, '40: One row with node 2 is returned');





-- 2 vertices tests

PREPARE q41 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table
WHERE id = 5;

-- Graph with vertices 3 and 6 and edge from 3 to 6
SELECT set_eq('q41', $$VALUES (5, 3, 6, 1, -1)$$, 'q41: Graph with two vertices 3 and 6 and edge from 3 to 6');

-- 2 vertices tests (directed)

PREPARE depthFirstSearch42 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    3
);

PREPARE depthFirstSearch43 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    ARRAY[3]
);

PREPARE depthFirstSearch44 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    6
);

PREPARE depthFirstSearch45 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    ARRAY[6]
);

PREPARE depthFirstSearch46 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    3, max_depth => 1
);

PREPARE depthFirstSearch47 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    3, max_depth => 0
);

SELECT set_eq('depthFirstSearch42', $$VALUES (1, 0, 3, 3, -1, 0, 0), (2, 1, 3, 6, 5, 1, 1)$$, '42: Two rows are returned');
SELECT set_eq('depthFirstSearch43', $$VALUES (1, 0, 3, 3, -1, 0, 0), (2, 1, 3, 6, 5, 1, 1)$$, '43: Two rows are returned');
SELECT set_eq('depthFirstSearch44', $$VALUES (1, 0, 6, 6, -1, 0, 0)$$, '44: One row is returned');
SELECT set_eq('depthFirstSearch45', $$VALUES (1, 0, 6, 6, -1, 0, 0)$$, '45: One row is returned');
SELECT set_eq('depthFirstSearch46', $$VALUES (1, 0, 3, 3, -1, 0, 0), (2, 1, 3, 6, 5, 1, 1)$$, '46: Two rows are returned');
SELECT set_eq('depthFirstSearch47', $$VALUES (1, 0, 3, 3, -1, 0, 0)$$, '47: One row is returned');

-- 2 vertices tests (undirected)

PREPARE depthFirstSearch48 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    3, directed => false
);

PREPARE depthFirstSearch49 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    ARRAY[3], directed => false
);

PREPARE depthFirstSearch50 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    6, directed => false
);

PREPARE depthFirstSearch51 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    ARRAY[6], directed => false
);

PREPARE depthFirstSearch52 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    3, max_depth => 1, directed => false
);

PREPARE depthFirstSearch53 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q41',
    3, max_depth => 0, directed => false
);

SELECT set_eq('depthFirstSearch48', $$VALUES (1, 0, 3, 3, -1, 0, 0), (2, 1, 3, 6, 5, 1, 1)$$, '48: Two rows are returned');
SELECT set_eq('depthFirstSearch49', $$VALUES (1, 0, 3, 3, -1, 0, 0), (2, 1, 3, 6, 5, 1, 1)$$, '49: Two rows are returned');
SELECT set_eq('depthFirstSearch50', $$VALUES (1, 0, 6, 6, -1, 0, 0), (2, 1, 6, 3, 5, 1, 1)$$, '50: Two rows are returned');
SELECT set_eq('depthFirstSearch51', $$VALUES (1, 0, 6, 6, -1, 0, 0), (2, 1, 6, 3, 5, 1, 1)$$, '51: Two rows are returned');
SELECT set_eq('depthFirstSearch52', $$VALUES (1, 0, 3, 3, -1, 0, 0), (2, 1, 3, 6, 5, 1, 1)$$, '52: Two rows are returned');
SELECT set_eq('depthFirstSearch53', $$VALUES (1, 0, 3, 3, -1, 0, 0)$$, '53: One row is returned');





-- 3 vertices tests

CREATE TABLE three_vertices_table (
    id BIGSERIAL,
    source BIGINT,
    target BIGINT,
    cost FLOAT,
    reverse_cost FLOAT
);

INSERT INTO three_vertices_table (source, target, cost, reverse_cost) VALUES
    (3, 6, 20, 15),
    (3, 8, 10, -10),
    (6, 8, -1, 12);

PREPARE q54 AS
SELECT id, source, target, cost, reverse_cost
FROM three_vertices_table;

-- Cyclic Graph with three vertices 3, 6 and 8
SELECT set_eq('q54',
    $$VALUES
        (1, 3, 6, 20, 15),
        (2, 3, 8, 10, -10),
        (3, 6, 8, -1, 12)
    $$,
    'q54: Cyclic Graph with three vertices 3, 6 and 8'
);

-- 3 vertices tests (directed)

PREPARE depthFirstSearch55 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q54',
    3
);

PREPARE depthFirstSearch56 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q54',
    6
);

PREPARE depthFirstSearch57 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q54',
    6, max_depth => 1
);

PREPARE depthFirstSearch58 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q54',
    2
);

PREPARE depthFirstSearch59 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q54',
    ARRAY[6, 3, 6]
);

SELECT set_eq('depthFirstSearch55',
    $$VALUES
        (1, 0, 3, 3, -1, 0, 0),
        (2, 1, 3, 6, 1, 20, 20),
        (3, 1, 3, 8, 2, 10, 10)
    $$,
    '55: 3 vertices tests (directed)'
);

SELECT set_eq('depthFirstSearch56',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 3, 1, 15, 15),
        (3, 2, 6, 8, 2, 10, 25)
    $$,
    '56: 3 vertices tests (directed)'
);

SELECT set_eq('depthFirstSearch57',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 3, 1, 15, 15)
    $$,
    '57: 3 vertices tests (directed)'
);

SELECT is_empty('depthFirstSearch58',
    '58: Vertex not present in graph -> Empty row is returned'
);

SELECT set_eq('depthFirstSearch59',
    $$VALUES
        (1, 0, 3, 3, -1, 0, 0),
        (2, 1, 3, 6, 1, 20, 20),
        (3, 1, 3, 8, 2, 10, 10),
        (4, 0, 6, 6, -1, 0, 0),
        (5, 1, 6, 3, 1, 15, 15),
        (6, 2, 6, 8, 2, 10, 25)
    $$,
    '59: 3 vertices tests (directed)'
);

-- 3 vertices tests (undirected)

PREPARE depthFirstSearch60 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q54',
    3, directed => false
);

PREPARE depthFirstSearch61 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q54',
    6, directed => false
);

PREPARE depthFirstSearch62 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q54',
    6, max_depth => 1, directed => false
);

SELECT set_eq('depthFirstSearch60',
    $$VALUES
        (1, 0, 3, 3, -1, 0, 0),
        (2, 1, 3, 6, 1, 20, 20),
        (3, 2, 3, 8, 3, 12, 32)
    $$,
    '60: 3 vertices tests (undirected)'
);

SELECT set_eq('depthFirstSearch61',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 3, 1, 20, 20),
        (3, 2, 6, 8, 2, 10, 30)
    $$,
    '61: 3 vertices tests (undirected)'
);

SELECT set_eq('depthFirstSearch62',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 3, 1, 20, 20)
    $$,
    '62: 3 vertices tests (undirected)'
);





-- 4 vertices tests

PREPARE q63 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table
WHERE (id >= 10 AND id <= 12)
    OR id = 8;

-- Graph with vertices 5, 6, 10, 11
SELECT set_eq('q63',
    $$VALUES
        (8, 5, 6, 1, 1),
        (10, 5, 10, 1, 1),
        (11, 6, 11, 1, -1),
        (12, 10, 11, 1, -1)
    $$,
    '63: Graph with vertices 5, 6, 10 and 11'
);

-- 4 vertices tests (directed)

PREPARE depthFirstSearch64 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q63',
    5
);

PREPARE depthFirstSearch65 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q63',
    6
);

PREPARE depthFirstSearch66 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q63',
    10
);

PREPARE depthFirstSearch67 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q63',
    11
);

SELECT set_eq('depthFirstSearch64',
    $$VALUES
        (1, 0, 5, 5, -1, 0, 0),
        (2, 1, 5, 6, 8, 1, 1),
        (3, 2, 5, 11, 11, 1, 2),
        (4, 1, 5, 10, 10, 1, 1)
    $$,
    '64: 4 vertices tests (directed)'
);

SELECT set_eq('depthFirstSearch65',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 5, 8, 1, 1),
        (3, 2, 6, 10, 10, 1, 2),
        (4, 3, 6, 11, 12, 1, 3)
    $$,
    '65: 4 vertices tests (directed)'
);

SELECT set_eq('depthFirstSearch66',
    $$VALUES
        (1, 0, 10, 10, -1, 0, 0),
        (2, 1, 10, 5, 10, 1, 1),
        (3, 2, 10, 6, 8, 1, 2),
        (4, 3, 10, 11, 11, 1, 3)
    $$,
    '66: 4 vertices tests (directed)'
);

SELECT set_eq('depthFirstSearch67',
    $$VALUES
        (1, 0, 11, 11, -1, 0, 0)
    $$,
    '67: 4 vertices tests (directed)'
);

-- 4 vertices tests (undirected)

PREPARE depthFirstSearch68 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q63',
    5, directed => false
);

PREPARE depthFirstSearch69 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q63',
    6, directed => false
);

PREPARE depthFirstSearch70 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q63',
    10, directed => false
);

PREPARE depthFirstSearch71 AS
SELECT *
FROM pgr_depthFirstSearch(
    'q63',
    11, directed => false
);

SELECT set_eq('depthFirstSearch68',
    $$VALUES
        (1, 0, 5, 5, -1, 0, 0),
        (2, 1, 5, 6, 8, 1, 1),
        (3, 2, 5, 11, 11, 1, 2),
        (4, 3, 5, 10, 12, 1, 3)
    $$,
    '68: 4 vertices tests (undirected)'
);

SELECT set_eq('depthFirstSearch69',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 5, 8, 1, 1),
        (3, 2, 6, 10, 10, 1, 2),
        (4, 3, 6, 11, 12, 1, 3)
    $$,
    '69: 4 vertices tests (undirected)'
);

SELECT set_eq('depthFirstSearch70',
    $$VALUES
        (1, 0, 10, 10, -1, 0, 0),
        (2, 1, 10, 5, 10, 1, 1),
        (3, 2, 10, 6, 8, 1, 2),
        (4, 3, 10, 11, 11, 1, 3)
    $$,
    '70: 4 vertices tests (undirected)'
);

SELECT set_eq('depthFirstSearch71',
    $$VALUES
        (1, 0, 11, 11, -1, 0, 0),
        (2, 1, 11, 6, 11, 1, 1),
        (3, 2, 11, 5, 8, 1, 2),
        (4, 3, 11, 10, 10, 1, 3)
    $$,
    '71: 4 vertices tests (undirected)'
);


SELECT * FROM finish();
ROLLBACK;
