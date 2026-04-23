# Real-time Synchronization Setup for Unpaid Bills Manager

This guide will help you enable real-time synchronization so that changes made on one device are instantly reflected on all other connected devices.

## Step 1: Enable Realtime in Supabase Dashboard

1. Go to your Supabase dashboard: https://supabase.com/dashboard
2. Select your project (`jnqnssbofwaioudalovk`)
3. Go to **Database** in the left sidebar
4. Click on **Replication** in the submenu
5. For each table, click the **Edit** button and enable replication:

### Enable for unpaid_bills table:
1. Find `unpaid_bills` in the table list
2. Click the **Edit** button (pencil icon)
3. Toggle **Enable replication** to ON
4. Click **Save**

### Enable for vendor_customers table:
1. Find `vendor_customers` in the table list
2. Click the **Edit** button (pencil icon)
3. Toggle **Enable replication** to ON
4. Click **Save**

## Step 2: Update Row Level Security (Optional but Recommended)

If you want to ensure users only see their own data in real-time, update your RLS policies:

```sql
-- Update unpaid_bills policy for real-time
CREATE POLICY "Enable realtime for unpaid_bills" ON unpaid_bills
  FOR ALL USING (auth.uid() = user_id::text) WITH CHECK (auth.uid() = user_id::text);

-- Update vendor_customers policy for real-time  
CREATE POLICY "Enable realtime for vendor_customers" ON vendor_customers
  FOR ALL USING (auth.uid() = user_id::text) WITH CHECK (auth.uid() = user_id::text);
```

## Step 3: Test Real-time Synchronization

1. **Open the application in two different browser windows** (or two different devices)
2. **Log in to the same account** in both windows
3. **Make a change in one window** (add/edit/delete a customer)
4. **Watch the change appear instantly** in the other window

## Step 4: Verify Real-time is Working

Check the browser console (F12) for these messages:
- `"Setting up real-time synchronization..."`
- `"Real-time sync active for unpaid_bills"`
- `"Real-time sync active for vendor_customers"`
- `"Real-time synchronization setup complete"`

When changes are made, you should see:
- `"Real-time update received for unpaid/vendor: [payload details]"`
- `"Added/Updated/Deleted [source] customer via real-time sync: [customer name]"`

## How Real-time Sync Works

### Events Handled:
- **INSERT**: When a new customer is added on any device
- **UPDATE**: When an existing customer is modified on any device  
- **DELETE**: When a customer is deleted on any device

### Conflict Resolution:
- Uses timestamps (`updatedAt`) to resolve conflicts
- Remote changes only apply if they're newer than local changes
- Prevents overwriting more recent local data

### Notifications:
- Shows blue info notifications for real-time changes
- Examples: "New customer added: John Doe", "Customer updated: Jane Smith"

## Troubleshooting

### Real-time not working:
1. **Check Replication**: Ensure replication is enabled for both tables in Supabase
2. **Check Console**: Look for error messages in the browser console
3. **Check Network**: Ensure both devices have internet connection
4. **Refresh Page**: Try refreshing both pages to re-establish connections

### Common Issues:
- **"CHANNEL_ERROR"**: Check your Supabase project URL and keys
- **No notifications**: Make sure both windows are logged into the same account
- **Delayed updates**: Check network connectivity and browser console for errors

### Performance Tips:
- Real-time subscriptions are automatically cleaned up when you close the tab
- The system handles connection drops and reconnections automatically
- Large datasets may take a moment to sync initially

## Security Notes

- Real-time subscriptions respect your Row Level Security policies
- Users can only see changes for data they have access to
- Consider implementing user-specific filtering for multi-user environments

## Advanced Features

The real-time system includes:
- **Automatic reconnection** if connection is lost
- **Duplicate prevention** to avoid adding the same customer twice
- **Timestamp-based conflict resolution**
- **Graceful fallback** to localStorage if real-time fails

---

**After completing these steps, your Unpaid Bills Manager will synchronize changes in real-time across all connected devices!**
