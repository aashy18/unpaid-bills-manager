-- Real-time Setup for Unpaid Bills Manager
-- Run these SQL commands in your Supabase SQL Editor

-- Step 1: Enable Realtime for all tables
-- This tells Supabase to broadcast changes for these tables

ALTER PUBLICATION supabase_realtime ADD TABLE unpaid_bills;
ALTER PUBLICATION supabase_realtime ADD TABLE vendor_customers;  
ALTER PUBLICATION supabase_realtime ADD TABLE deleted_customers;

-- Step 2: Create updated_at triggers (if not already exists)
-- This ensures the updated_at timestamp is always updated

CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the trigger to each table
DROP TRIGGER IF EXISTS handle_unpaid_bills_updated_at ON unpaid_bills;
CREATE TRIGGER handle_unpaid_bills_updated_at
  BEFORE UPDATE ON unpaid_bills
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

DROP TRIGGER IF EXISTS handle_vendor_customers_updated_at ON vendor_customers;
CREATE TRIGGER handle_vendor_customers_updated_at
  BEFORE UPDATE ON vendor_customers
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();

-- Step 3: Create deleted_at trigger for deleted_customers
CREATE OR REPLACE FUNCTION handle_deleted_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.deleted_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS handle_deleted_customers_deleted_at ON deleted_customers;
CREATE TRIGGER handle_deleted_customers_deleted_at
  BEFORE INSERT ON deleted_customers
  FOR EACH ROW
  EXECUTE FUNCTION handle_deleted_at();

-- Step 4: Verify Realtime is enabled
-- You can check this by running:
SELECT * FROM pg_publication_tables WHERE pubname = 'supabase_realtime';

-- Expected output should show your three tables:
-- unpaid_bills
-- vendor_customers  
-- deleted_customers

-- Step 5: Test Realtime (optional)
-- Insert a test record to verify realtime works:
-- INSERT INTO unpaid_bills (id, name, balance) VALUES ('test-realtime', 'Realtime Test', 100.00);
-- Then delete it: DELETE FROM unpaid_bills WHERE id = 'test-realtime';

-- Your application should now receive real-time updates!
