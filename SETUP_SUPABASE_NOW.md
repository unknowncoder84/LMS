# 🚨 IMPORTANT: Setup Supabase to Fix Blank Screen

## Why You're Seeing a Blank Screen

The application is running, but it can't connect to the database because the `.env` file has placeholder values. You need to add your real Supabase credentials.

## Quick Fix (5 Minutes)

### Step 1: Get Your Supabase Credentials

1. **Go to Supabase**: https://supabase.com/dashboard
2. **Sign in** or create a free account
3. **Create a new project** (if you don't have one):
   - Click "New Project"
   - Give it a name (e.g., "LMS")
   - Set a database password (save this!)
   - Choose a region close to you
   - Click "Create new project"
   - Wait 2-3 minutes for setup

4. **Get your API credentials**:
   - Click on "Settings" (gear icon) in the left sidebar
   - Click on "API"
   - You'll see two important values:
     - **Project URL** (looks like: `https://xxxxx.supabase.co`)
     - **anon public** key (long string of characters)

### Step 2: Update Your .env File

1. **Open the `.env` file** in your project root
2. **Replace the placeholder values**:

```env
VITE_SUPABASE_URL=https://your-actual-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-actual-anon-key-here
```

**Example** (with fake values):
```env
VITE_SUPABASE_URL=https://abcdefghijk.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDI1MjM2MDAsImV4cCI6MTk1ODA5OTYwMH0.abc123def456
```

3. **Save the file**

### Step 3: Set Up the Database

1. **Go to SQL Editor** in Supabase:
   - Click "SQL Editor" in the left sidebar
   - Click "New query"

2. **Run the schema setup**:
   - Look for the file `supabase/schema.sql` in your project
   - Copy its contents
   - Paste into the SQL Editor
   - Click "Run" (or press Ctrl+Enter)

3. **Create an admin user**:
   - Create a new query
   - Run this SQL:

```sql
-- Create admin user
INSERT INTO public.user_accounts (
  username, 
  password, 
  name, 
  email, 
  role, 
  is_active
)
VALUES (
  'admin',
  'admin123',  -- Change this password!
  'Administrator',
  'admin@lms.local',
  'admin',
  true
)
ON CONFLICT (username) DO NOTHING;
```

### Step 4: Restart the Dev Server

The dev server should automatically reload, but if not:

1. **Stop the server**: Press `Ctrl+C` in the terminal
2. **Start it again**: Run `npm run dev`
3. **Refresh your browser**: Go to http://localhost:3000/

## ✅ You Should Now See:

- The LMS login page (not a blank screen!)
- A beautiful gradient background
- Login form with username and password fields

## 🔐 Login Credentials

- **Username**: `admin`
- **Password**: `admin123` (or whatever you set in the SQL)

## 🆘 Still Having Issues?

### Check the Browser Console

1. Press `F12` to open Developer Tools
2. Click on the "Console" tab
3. Look for error messages (usually in red)
4. Common errors:
   - "Missing Supabase environment variables" → Check your `.env` file
   - "Failed to fetch" → Check your Supabase URL
   - "Invalid API key" → Check your anon key

### Check the Terminal

Look at the terminal where `npm run dev` is running. Any errors will show there.

### Verify Your .env File

Make sure:
- The file is named exactly `.env` (not `.env.txt`)
- It's in the project root directory (same folder as `package.json`)
- There are no extra spaces or quotes around the values
- The values are your actual Supabase credentials (not the placeholders)

## 📚 Need More Help?

1. **Supabase Documentation**: https://supabase.com/docs
2. **Check the schema file**: `supabase/schema.sql`
3. **Review the setup guide**: `HOW_TO_RUN_LOCALLY.md`

---

**Quick Checklist:**
- [ ] Created/logged into Supabase account
- [ ] Created a new project
- [ ] Copied Project URL to `.env`
- [ ] Copied anon key to `.env`
- [ ] Ran the schema SQL in Supabase SQL Editor
- [ ] Created admin user
- [ ] Restarted dev server
- [ ] Refreshed browser
- [ ] Can see login page (not blank screen)

Once you complete these steps, the application will work perfectly!
