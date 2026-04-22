# Supabase Setup Guide for Unpaid Bills Manager

This guide will help you set up Supabase to replace localStorage with cloud database storage for your Unpaid Bills Manager application.

## What is Supabase?

Supabase is an open-source Firebase alternative that provides:
- **Database**: PostgreSQL database with automatic API generation
- **Authentication**: Email/password, social logins, and more
- **Storage**: File storage for images and documents
- **Real-time**: Live data synchronization across devices

## Step 1: Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Click **"Start your project"** or **"Sign Up"**
3. Create an account (GitHub, Google, or email)
4. Click **"New Project"**
5. Choose your organization or create a new one
6. Enter project details:
   - **Project Name**: `unpaid-bills-manager` (or your preferred name)
   - **Database Password**: Create a strong password and save it
   - **Region**: Choose the closest region to your users
7. Click **"Create new project"**
8. Wait for the project to be set up (1-2 minutes)

## Step 2: Get Your Supabase Credentials

1. In your Supabase dashboard, go to **Settings** (gear icon) > **API**
2. Copy the **Project URL** - it looks like: `https://abcdefg.supabase.co`
3. Copy the **anon public** key - it's a long string starting with `eyJ...`

## Step 3: Configure Your Application

1. Open `index.html` in your project
2. Find the Supabase configuration section around line 912
3. Replace the placeholder values:

```javascript
// Replace this:
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';

// With your actual values:
const SUPABASE_URL = 'https://abcdefg.supabase.co'; // Your Project URL
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'; // Your anon key
```

## Step 4: Set Up Database Tables

1. In your Supabase dashboard, go to **Table Editor**
2. Click **"Create a new table"**
3. Create the following tables:

### Table 1: unpaid_bills
```sql
CREATE TABLE unpaid_bills (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  number TEXT,
  balance DECIMAL(10,2) NOT NULL,
  payments JSONB DEFAULT '[]',
  credits JSONB DEFAULT '[]',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Table 2: vendor_customers
```sql
CREATE TABLE vendor_customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  number TEXT,
  balance DECIMAL(10,2) NOT NULL,
  payments JSONB DEFAULT '[]',
  credits JSONB DEFAULT '[]',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Table 3: deleted_customers
```sql
CREATE TABLE deleted_customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  number TEXT,
  balance DECIMAL(10,2) NOT NULL,
  payments JSONB DEFAULT '[]',
  credits JSONB DEFAULT '[]',
  deleted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  original_table TEXT NOT NULL -- 'unpaid_bills' or 'vendor_customers'
);
```

## Step 5: Set Up Authentication (Optional but Recommended)

1. In Supabase dashboard, go to **Authentication** > **Settings**
2. Under **Site URL**, add your GitHub Pages URL: `https://YOUR_USERNAME.github.io/YOUR_REPO`
3. Under **Redirect URLs**, add: `https://YOUR_USERNAME.github.io/YOUR_REPO`
4. Enable **Email** authentication in **Authentication** > **Providers**

## Step 6: Set Up Row Level Security (RLS)

1. Go to **Authentication** > **Policies**
2. Enable **RLS** for each table
3. Create policies to allow users to access their own data

### For unpaid_bills table:
```sql
-- Allow all operations (for now, you can restrict later)
CREATE POLICY "Enable all operations for all users" ON unpaid_bills
  FOR ALL USING (true) WITH CHECK (true);
```

### For vendor_customers table:
```sql
-- Allow all operations (for now, you can restrict later)
CREATE POLICY "Enable all operations for all users" ON vendor_customers
  FOR ALL USING (true) WITH CHECK (true);
```

### For deleted_customers table:
```sql
-- Allow all operations (for now, you can restrict later)
CREATE POLICY "Enable all operations for all users" ON deleted_customers
  FOR ALL USING (true) WITH CHECK (true);
```

## Step 7: Test Your Setup

1. Open your `index.html` file in a browser
2. Check the browser console (F12) for messages:
   - Look for "Supabase client initialized successfully"
   - If you see errors, check your URL and keys
3. Try creating a new customer
4. Check your Supabase **Table Editor** to see if data appears

## Troubleshooting

### Common Issues:

1. **"Supabase client not initialized"**
   - Check that you replaced the placeholder URL and key correctly
   - Ensure you copied the full anon key (it's very long)

2. **"CORS error"**
   - Add your website URL to Supabase Authentication > Settings > Site URL
   - For GitHub Pages: `https://username.github.io/repo-name`

3. **"Table does not exist"**
   - Make sure you created all the required tables
   - Check table names match exactly (case-sensitive)

4. **"Permission denied"**
   - Enable RLS policies for your tables
   - Check that policies allow the operations you need

### Console Commands for Testing:

Open browser console (F12) and run:

```javascript
// Test Supabase connection
supabase.from('unpaid_bills').select('count').then(console.log);

// Test authentication
supabase.auth.getUser().then(console.log);
```

## Migration from localStorage

The application automatically:
- **Falls back to localStorage** if Supabase is not available
- **Migrates existing data** from localStorage to Supabase when you first save
- **Works offline** using localStorage as backup

This means your existing data is safe and the app continues to work even without Supabase.

## Benefits of Using Supabase

- **Cross-device sync**: Access your data from any device
- **Real-time updates**: Changes appear instantly on all connected devices
- **Data backup**: Your data is safely stored in the cloud
- **User authentication**: Secure login system for multiple users
- **Scalability**: Can handle much more data than localStorage

## Next Steps

Once your Supabase is working:
1. Set up proper user authentication
2. Configure row-level security for multi-user support
3. Enable real-time subscriptions for live updates
4. Set up database backups

## Support

If you need help:
- Check the [Supabase Documentation](https://supabase.com/docs)
- Look at console error messages for specific issues
- Test with the browser console commands above

---

**Note**: Your localStorage data will remain as a backup. The application uses Supabase when available and falls back to localStorage when needed.
