ALTER TABLE employee ADD PRIMARY KEY (employee_id);
ALTER TABLE shop ADD PRIMARY KEY (shop_id);
ALTER TABLE evaluation ALTER COLUMN employee_id TYPE INTEGER USING employee_id::integer;
ALTER TABLE ONLY evaluation ADD CONSTRAINT evaluation_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employee(employee_id);
