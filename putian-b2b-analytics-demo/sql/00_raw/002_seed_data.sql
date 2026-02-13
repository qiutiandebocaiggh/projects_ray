-- Putian demo: seed (simulated) data

INSERT INTO raw_customers VALUES
('C001','Nanjing Public Security Bureau','gov','Nanjing'),
('C002','Henan University','edu','Kaifeng'),
('C003','Yangshan Port Ops Co.','enterprise','Shanghai'),
('C004','BFA Forum Center','enterprise','Hainan');

INSERT INTO raw_projects VALUES
('P001','C001','2022-04-01',520000.00,'delivered'),
('P002','C002','2022-04-15',180000.00,'in_progress'),
('P003','C003','2022-05-01',760000.00,'won'),
('P004','C004','2022-05-10',240000.00,'lost');

INSERT INTO raw_payments VALUES
('PMT001','P001','2022-04-10',200000.00),
('PMT002','P001','2022-05-20',320000.00),
('PMT003','P002','2022-04-25',60000.00),
('PMT004','P003','2022-05-20',100000.00);

INSERT INTO raw_milestones VALUES
('M001','P001','Site Survey','2022-04-03','2022-04-03'),
('M002','P001','Cable Installation','2022-04-20','2022-04-23'),
('M003','P001','Acceptance','2022-05-15','2022-05-16'),
('M004','P002','Site Survey','2022-04-20','2022-04-21'),
('M005','P002','Cable Installation','2022-05-05',NULL),
('M006','P003','Site Survey','2022-05-05','2022-05-05');
