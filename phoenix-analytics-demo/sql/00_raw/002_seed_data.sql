-- Phoenix demo: seed (simulated) data

INSERT INTO raw_schools VALUES
('S001','Xuzhou No.1 Middle School','Xuzhou'),
('S002','Nanjing Experimental School','Nanjing'),
('S003','Suzhou Foreign Language School','Suzhou');

INSERT INTO raw_students VALUES
('ST001','S001',7,'Class A'),
('ST002','S001',7,'Class A'),
('ST003','S001',8,'Class B'),
('ST004','S002',7,'Class A'),
('ST005','S002',9,'Class C'),
('ST006','S003',8,'Class A');

INSERT INTO raw_orders VALUES
('O001','S001','2021-03-01',1200.00,'paid'),
('O002','S001','2021-03-02',800.00,'paid'),
('O003','S002','2021-03-02',1500.00,'paid'),
('O004','S002','2021-03-03',300.00,'cancelled'),
('O005','S003','2021-03-03',900.00,'paid');

INSERT INTO raw_attendance VALUES
('A001','ST001','2021-03-01',1),
('A002','ST002','2021-03-01',1),
('A003','ST003','2021-03-01',0),
('A004','ST004','2021-03-01',1),
('A005','ST005','2021-03-01',1),
('A006','ST006','2021-03-01',1),
('A007','ST001','2021-03-02',1),
('A008','ST002','2021-03-02',0),
('A009','ST003','2021-03-02',1);
