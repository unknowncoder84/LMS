# How to Run LMS Locally

This guide provides step-by-step instructions to run the Legal Management System on your local machine.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (version 18 or higher)
- **npm** (comes with Node.js)
- **Git** (optional, for version control)

## Step 1: Install Dependencies

Open your terminal in the project directory and run:

```bash
npm install
```

This will install all required packages listed in `package.json`.

## Step 2: Set Up Environment Variables

1. Copy the example environment file:
   ```bash
   copy .env.example .env
   ```

2. Open the `.env` file and add your Supabase credentials:
   ```
   VITE_SUPABASE_URL=your_supabase_project_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

   **Where to find these values:**
   - Go to your Supabase project dashboard
   - Click on "Settings" → "API"
   - Copy the "Project URL" and "anon public" key

## Step 3: Set Up Database (First Time Only)

1. Go to your Supabase project dashboard
2. Click on "SQL Editor"
3. Run the migration file from `supabase/migrations/` to create the database schema
4. Create an admin user (see database setup documentation)

## Step 4: Start the Development Server

Run the following command:

```bash
npm run dev
```

The application will start and you'll see output like:

```
VITE v5.0.0  ready in 500 ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

## Step 5: Open in Browser

Open your web browser and navigate to:

```
http://localhost:5173
```

You should see the LMS login page.

## Default Login Credentials

After setting up the database with the admin user:

- **Username:** `admin`
- **Password:** (the password you set in the SQL script)
- **Email:** `admin@lms.local`

## Common Commands

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build |
| `npm test` | Run tests |
| `npm run lint` | Check code quality |

## Troubleshooting

### Port Already in Use

If port 5173 is already in use, Vite will automatically try the next available port (5174, 5175, etc.).

### Cannot Connect to Supabase

- Verify your `.env` file has correct credentials
- Check that your Supabase project is active
- Ensure you have internet connection

### Build Errors

If you encounter TypeScript errors:
```bash
npm run build
```

This will show you any compilation errors that need to be fixed.

### Database Connection Issues

- Verify your database migrations have been run
- Check that RLS (Row Level Security) policies are set up correctly
- Ensure the admin user exists in the database

## Stopping the Server

To stop the development server:

- Press `Ctrl + C` in the terminal where the server is running

## Next Steps

After running locally:

1. Test the login functionality
2. Verify file upload/download works
3. Check that all pages load correctly
4. Review the branding (should show "LMS" everywhere)

## Need Help?

If you encounter issues:

1. Check the browser console for errors (F12)
2. Check the terminal for server errors
3. Review the Supabase logs in your dashboard
4. Ensure all environment variables are set correctly

---

**Note:** This application requires an active Supabase project. Make sure your Supabase project is properly configured before running locally.
