-- Supabase Database Setup for Unpaid Bills Manager
-- Run this SQL in your Supabase dashboard: SQL Editor

-- Create unpaid_bills table
CREATE TABLE IF NOT EXISTS unpaid_bills (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  number TEXT,
  balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  payments JSONB DEFAULT '[]'::jsonb,
  credits JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create vendor_customers table
CREATE TABLE IF NOT EXISTS vendor_customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  number TEXT,
  balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  payments JSONB DEFAULT '[]'::jsonb,
  credits JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create deleted_customers table
CREATE TABLE IF NOT EXISTS deleted_customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  number TEXT,
  balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  payments JSONB DEFAULT '[]'::jsonb,
  credits JSONB DEFAULT '[]'::jsonb,
  deleted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  original_table TEXT NOT NULL -- 'unpaid_bills' or 'vendor_customers'
);

-- Enable Row Level Security (RLS)
ALTER TABLE unpaid_bills ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendor_customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE deleted_customers ENABLE ROW LEVEL SECURITY;

-- Create policies to allow all operations (you can restrict later for multi-user)
CREATE POLICY "Enable all operations for all users" ON unpaid_bills
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Enable all operations for all users" ON vendor_customers
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Enable all operations for all users" ON deleted_customers
  FOR ALL USING (true) WITH CHECK (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_unpaid_bills_created_at ON unpaid_bills(created_at);
CREATE INDEX IF NOT EXISTS idx_vendor_customers_created_at ON vendor_customers(created_at);
CREATE INDEX IF NOT EXISTS idx_deleted_customers_deleted_at ON deleted_customers(deleted_at);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_unpaid_bills_updated_at 
  BEFORE UPDATE ON unpaid_bills 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vendor_customers_updated_at 
  BEFORE UPDATE ON vendor_customers 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
