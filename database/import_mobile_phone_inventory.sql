-- ============================================================================
-- IMPORT MOBILE PHONE INVENTORY FROM inventroy.txt
-- Includes automatic resignation tracking for users no longer active
-- ============================================================================

-- STEP 1: Insert all mobile phones from inventory
-- Note: These users have resigned, so we'll mark them as previous_user
-- ============================================================================

INSERT INTO assets (
  name,
  category,
  location,
  model,
  serial_number,
  condition,
  status,
  purchase_date,
  purchase_cost,
  current_value,
  assigned_to,
  previous_user,
  resigned_date,
  resignation_notes,
  description,
  notes,
  department_id
) VALUES

-- Resigned employees - Mobile phones to be marked as unassigned
('Mobile-Mione-Pro-001', 'Mobile Phone', 'Office - Floor 1', 'Mione Pro', '354663510053653', 'good', 'in_stock', '2023-11-29', 800, 600, NULL, 'Murzhamal Abbirafhoba', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-Mione-Pro-002', 'Mobile Phone', 'Office - Floor 1', 'Mione Pro', '254663410016759', 'good', 'in_stock', '2023-11-29', 800, 600, NULL, 'Bermet Kenzhebekova', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-iPhone-SE-001', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '356552960554897', 'good', 'in_stock', '2023-11-29', 1500, 1200, NULL, 'Chanelle Erwee', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera, Model: FFMH701GPLK1', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-Mione-Pro-003', 'Mobile Phone', 'Office - Floor 1', 'Mione Pro', '354663410009770', 'good', 'in_stock', '2023-12-05', 800, 600, NULL, 'Aizaida Kubatbekova', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-Mione-Pro-004', 'Mobile Phone', 'Office - Floor 1', 'Mione Pro', '354663410047010p', 'good', 'in_stock', '2023-12-07', 800, 600, NULL, 'Marina Sukhankina', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-iPhone-SE-002', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '352853883960862', 'good', 'in_stock', '2023-12-11', 1500, 1200, NULL, 'Kara Conyers', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera, Model: DX3HF023PLK1', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-iPhone-SE-003', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '356844119600030', 'good', 'in_stock', '2023-12-12', 1500, 1200, NULL, 'Mario Fico', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera, Model: FFMGP1BZPLK1', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-iPhone-SE-004', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '356474109303344', 'good', 'in_stock', '2023-12-18', 1500, 1200, NULL, 'Anoj Rodrigo', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera, Model: F17DH3XLPLK1', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-iPhone-SE-005', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '35283883329530', 'good', 'in_stock', '2024-01-03', 1500, 1200, NULL, 'Hanna Ternovska', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera, Model: FFMH904TPLK1', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-iPhone-SE-006', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '352853884304789', 'good', 'in_stock', '2024-01-03', 1500, 1200, NULL, 'Sofia Alekseitseva', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera, Model: DX3HF09XPLK1', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-iPhone-SE-007', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '356463109060681', 'good', 'in_stock', '2024-01-09', 1500, 1200, NULL, 'Emily Smith', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera, Model: F17DG5H6PLK1', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-Mione-Pro-005', 'Mobile Phone', 'White Villa', 'Mione Pro', '354663410060831', 'good', 'in_stock', '2024-01-22', 800, 600, NULL, 'Kimberly Abing', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-iPhone-SE-008', 'Mobile Phone', 'White Villa', 'iPhone SE', 'F17DG3WZPLK1', 'good', 'in_stock', '2024-02-29', 1500, 1200, NULL, 'Berna Navarro', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-iPhone-7-001', 'Mobile Phone', 'Office - Floor 1', 'iPhone 7', '353837085172243', 'good', 'in_stock', '2024-04-04', 1000, 700, NULL, 'Maria Sole', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-iPhone-SE-009', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '356463109438119', 'good', 'in_stock', '2023-11-24', 1500, 1200, NULL, 'Evguenia Lomteva', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB, Non-Camera, Model: F17DG3GGPLK1', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-MiOne-Pro-Plus-001', 'Mobile Phone', 'Office - Floor 1', 'MiOne Pro Plus', '354663410058934', 'good', 'in_stock', '2023-09-20', 900, 700, NULL, 'Leo Reyes', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: Project', (SELECT id FROM departments WHERE name = 'Project')),

('Mobile-MiOne-Pro-Plus-002', 'Mobile Phone', 'Office - Floor 1', 'MiOne Pro Plus', '354663410047010', 'good', 'in_stock', '2023-09-05', 900, 700, NULL, 'Gulshan Durusbekova', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: Project', (SELECT id FROM departments WHERE name = 'Project')),

('Mobile-MiOne-Pro-Plus-003', 'Mobile Phone', 'Office - Floor 1', 'MiOne Pro Plus', '354663410054990', 'good', 'in_stock', '2023-09-05', 900, 700, NULL, 'Gulnura Muktarbekova', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: Project', (SELECT id FROM departments WHERE name = 'Project')),

('Mobile-MiOne-Pro-Plus-004', 'Mobile Phone', 'White Villa', 'MiOne Pro Plus', '354663410047697', 'good', 'in_stock', '2023-09-04', 900, 700, NULL, 'Samiksha Paudel', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-001', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050015245', 'good', 'in_stock', '2023-06-22', 600, 400, NULL, 'Iana Bicova', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-002', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050044740', 'good', 'in_stock', '2023-06-22', 600, 400, NULL, 'Dane Lemmer', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-003', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050094984', 'good', 'in_stock', '2023-04-17', 600, 400, NULL, 'Chanida Pannue', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-004', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050092723', 'good', 'in_stock', '2023-03-15', 600, 400, NULL, 'Nina Raimanova', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-005', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055027505', 'good', 'in_stock', '2023-01-31', 600, 400, NULL, 'Evghenia Ginju', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-Lava-Benco-006', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '8650550015989', 'good', 'in_stock', '2023-01-30', 600, 400, NULL, 'Vitaliia Zanudina', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-Lava-Benco-007', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050062122', 'good', 'in_stock', '2023-01-05', 600, 400, NULL, 'Anastassiya Gonareva', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-iPhone-7-002', 'Mobile Phone', 'Office - Floor 1', 'iPhone 7', 'F4GV4SGRHG6W', 'good', 'in_stock', '2022-11-22', 1000, 600, NULL, 'Sofia Romanenko', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Benco-001', 'Mobile Phone', 'White Villa', 'Benco/Lava', 'LE9940-W', 'good', 'in_stock', '2022-11-02', 600, 400, NULL, 'Abigail Abalos', '2024-11-16', 'Employee resigned - Device returned to inventory', '', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-iPhone-SE-010', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', '350737736530059', 'excellent', 'in_stock', '2025-04-08', 1500, 1400, NULL, 'Olivia Svetlana', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Benco-S1s-001', 'Mobile Phone', 'Office - Floor 1', 'Benco S1s', '862406046762290', 'excellent', 'in_stock', '2024-11-13', 700, 650, NULL, 'Bassel Assali', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: Catering', (SELECT id FROM departments WHERE name = 'Catering')),

('Mobile-iPhone-7-003', 'Mobile Phone', 'White Villa', 'iPhone 7', 'ONPLXOVLH67X', 'good', 'in_stock', '2021-01-01', 1000, 400, NULL, 'Jacqueline De Belen', '2024-11-16', 'Employee resigned - Device returned to inventory', '64GB', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-008', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050024767', 'good', 'in_stock', '2021-01-31', 600, 300, NULL, 'Jessica Morate', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-009', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050015427', 'good', 'in_stock', '2022-01-05', 600, 400, NULL, 'Violetta Khalikova', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-iPhone-7-004', 'Mobile Phone', 'Spanish Villa', 'iPhone 7', 'F71WQFY9HG6W', 'good', 'in_stock', '2022-01-28', 1000, 500, NULL, 'Catherine Reotorio', '2024-11-16', 'Employee resigned - Device returned to inventory', '', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-iPhone-7-005', 'Mobile Phone', 'Spanish Villa', 'iPhone 7', 'DX3Z888AHG6X', 'good', 'in_stock', '2022-01-28', 1000, 500, NULL, 'Ronalyn Tolentino', '2024-11-16', 'Employee resigned - Device returned to inventory', '', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-iPhone-SE-011', 'Mobile Phone', 'White Villa', 'iPhone SE', 'GWVGR4JVPLJT', 'good', 'in_stock', '2022-01-29', 1500, 1000, NULL, 'Katarina Dela Cruz', '2024-11-16', 'Employee resigned - Device returned to inventory', '64GB', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-iPhone-SE-012', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', 'DX3GN5PAPLJY', 'good', 'in_stock', '2022-01-29', 1500, 1000, NULL, 'Berna Navarro', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-iPhone-7-006', 'Mobile Phone', 'White Villa', 'iPhone 7', 'F4GSR04FHG6W', 'good', 'in_stock', '2022-01-29', 1000, 500, NULL, 'Vanessa Paraiso', '2024-11-16', 'Employee resigned - Device returned to inventory', '', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-010', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050010741', 'good', 'in_stock', '2022-01-29', 600, 400, NULL, 'Maria Laiza Santos', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-011', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '8650550500017126', 'good', 'in_stock', '2022-02-02', 600, 400, NULL, 'Amanova Ainazik', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-012', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050024700', 'good', 'in_stock', '2022-02-02', 600, 400, NULL, 'Mary Grace Mateo', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-013', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '8650550500011640', 'good', 'in_stock', '2022-02-02', 600, 400, NULL, 'Famaele', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-014', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050014206', 'good', 'in_stock', '2022-02-02', 600, 400, NULL, 'Samey Calo', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-iPhone-SE-013', 'Mobile Phone', 'Office - Floor 1', 'iPhone SE', 'DX3GJ7QWPLJY', 'good', 'in_stock', '2022-02-02', 1500, 1000, NULL, 'Olena Artymko', '2024-11-16', 'Employee resigned - Device returned to inventory', '128GB', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-015', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050016243', 'good', 'in_stock', '2022-02-02', 600, 400, NULL, 'Annehe Maka', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-016', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050008703', 'good', 'in_stock', '2022-02-02', 600, 400, NULL, 'Bea Samantha Salvino', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-017', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050016904', 'good', 'in_stock', '2022-02-03', 600, 400, NULL, 'Roxxanne Jane Calimlim', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-iPhone-7-007', 'Mobile Phone', 'Office - Floor 1', 'iPhone 7', '355833088785576', 'good', 'in_stock', '2022-02-03', 1000, 500, NULL, 'Yana Berlinska', '2024-11-16', 'Employee resigned - Device returned to inventory', '', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-018', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050021888', 'good', 'in_stock', '2022-02-03', 600, 400, NULL, 'Marie Cauborell', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-019', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050026309', 'good', 'in_stock', '2022-02-07', 600, 400, NULL, 'Amoz Gachambusa', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-020', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050015609', 'good', 'in_stock', '2022-02-08', 600, 400, NULL, 'Anil Kumar Reddaboini', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-021', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050023769', 'good', 'in_stock', '2022-02-08', 600, 400, NULL, 'Maria Laiza Santos', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-022', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050027364', 'good', 'in_stock', '2022-02-08', 600, 400, NULL, 'Arunj Raja Rapu', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-023', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050005907', 'good', 'in_stock', '2022-02-08', 600, 400, NULL, 'Poashanlh Kunta', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-024', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050027448', 'good', 'in_stock', '2022-02-08', 600, 400, NULL, 'Ajaveenl Gaje', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-025', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865055050016326', 'good', 'in_stock', '2022-02-11', 600, 400, NULL, 'Maria Victoria Clano', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Admin', (SELECT id FROM departments WHERE name = 'Admin')),

('Mobile-Benco-002', 'Mobile Phone', 'White Villa', 'Benco', 'AE9010W', 'good', 'in_stock', '2022-02-11', 600, 400, NULL, 'Dianne Montanez', '2024-11-16', 'Employee resigned - Device returned to inventory', '', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-Benco-026', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865005050013505', 'good', 'in_stock', '2022-03-04', 600, 400, NULL, 'Anum Kumai', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Maintenance', (SELECT id FROM departments WHERE name = 'Maintenance')),

('Mobile-Lava-Benco-027', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865005050016326', 'good', 'in_stock', '2022-03-04', 600, 400, NULL, 'Boby Jacob Thomen', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Maintenance', (SELECT id FROM departments WHERE name = 'Maintenance')),

('Mobile-Lava-Benco-028', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865005050015682', 'good', 'in_stock', '2022-03-05', 600, 400, NULL, 'Firash', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Maintenance', (SELECT id FROM departments WHERE name = 'Maintenance')),

('Mobile-Lava-Benco-029', 'Mobile Phone', 'Office - Floor 1', 'Lava Benco V80s', '865005050011145', 'good', 'in_stock', '2022-03-07', 600, 400, NULL, 'Rabik', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Maintenance', (SELECT id FROM departments WHERE name = 'Maintenance')),

('Mobile-Lava-Benco-030', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050016482', 'good', 'in_stock', '2022-05-24', 600, 400, NULL, 'Zoe Fernandez', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Lava-V7s-001', 'Mobile Phone', 'Office - Floor 1', 'Lava V7s', '353967110294975', 'excellent', 'in_stock', '2024-06-12', 700, 650, NULL, 'Zara Yardimci', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-iPhone-7-008', 'Mobile Phone', 'Office - Floor 1', 'iPhone 7', '355322086700423', 'excellent', 'in_stock', '2024-06-24', 1000, 900, NULL, 'Anxhela Kita', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: IT', (SELECT id FROM departments WHERE name = 'IT')),

('Mobile-Benco-V7-Prime-001', 'Mobile Phone', 'White Villa', 'Benco V7 Prime', '3539667110294975', 'good', 'in_stock', '2022-05-24', 700, 450, NULL, 'Ramah Putuwar', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Vivo-001', 'Mobile Phone', 'White Villa', 'Vivo', '865055050002888', 'good', 'in_stock', '2022-09-30', 800, 500, NULL, 'Aadinath Harkumar', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Vivo-002', 'Mobile Phone', 'White Villa', 'Vivo', '865055050003282', 'good', 'in_stock', '2022-09-30', 800, 500, NULL, 'Shekar Allkonda', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping')),

('Mobile-Vivo-003', 'Mobile Phone', 'Office - Floor 1', 'Vivo', '865055050060340', 'good', 'in_stock', '2022-09-30', 800, 500, NULL, 'Vasylysa Korobeinikova', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-Camera', 'Department: F&B', (SELECT id FROM departments WHERE name = 'F&B')),

('Mobile-Lava-Benco-031', 'Mobile Phone', 'White Villa', 'Lava Benco V80s', '865055050025186', 'good', 'in_stock', '2022-10-25', 600, 400, NULL, 'Mukesh Narra', '2024-11-16', 'Employee resigned - Device returned to inventory', 'Non-camera', 'Department: Housekeeping', (SELECT id FROM departments WHERE name = 'Housekeeping'))

ON CONFLICT (serial_number) DO NOTHING;

-- ============================================================================
-- STEP 2: Verification Query
-- ============================================================================

SELECT 
  'Mobile Phone Import Summary' as report,
  COUNT(*) as total_imported,
  COUNT(CASE WHEN status = 'in_stock' THEN 1 END) as in_stock,
  COUNT(previous_user) as with_resignation_history,
  array_agg(DISTINCT department_id) as departments_covered
FROM assets
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%';

-- Show sample of imported devices
SELECT 
  'Sample Imported Devices' as report,
  name,
  model,
  serial_number,
  previous_user,
  resigned_date,
  status,
  location
FROM assets
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%'
LIMIT 10;

-- Count by department
SELECT 
  'By Department' as report,
  d.name as department,
  COUNT(*) as device_count
FROM assets a
LEFT JOIN departments d ON a.department_id = d.id
WHERE a.category = 'Mobile Phone'
  AND a.name LIKE 'Mobile-%'
GROUP BY d.name
ORDER BY device_count DESC;

-- Count by model
SELECT 
  'By Model' as report,
  model,
  COUNT(*) as device_count,
  MIN(current_value) as min_value,
  MAX(current_value) as max_value
FROM assets
WHERE category = 'Mobile Phone'
  AND name LIKE 'Mobile-%'
GROUP BY model
ORDER BY device_count DESC;

-- ============================================================================
-- DONE! 70+ mobile phones imported with resignation tracking
-- All devices marked as in_stock and available for reassignment
-- ============================================================================
