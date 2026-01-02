# ⚡ Netlify Quick Deploy - 5 Minutes

## 🎯 Super Fast Deployment Guide

### 1️⃣ Go to Netlify (1 minute)
```
https://www.netlify.com/
```
- Click "Sign up with GitHub"
- Authorize Netlify

### 2️⃣ Import Your Project (1 minute)
- Click "Add new site" → "Import an existing project"
- Choose "Deploy with GitHub"
- Select your `LMS` repository

### 3️⃣ Configure Settings (2 minutes)

**Build command:**
```
npm run build
```

**Publish directory:**
```
dist
```

**Environment Variables** (Click "Add environment variables"):

**Variable 1:**
```
Key: VITE_SUPABASE_URL
Value: https://jnpekutjldtovddetbor.supabase.co
```

**Variable 2:**
```
Key: VITE_SUPABASE_ANON_KEY
Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpucGVrdXRqbGR0b3ZkZGV0Ym9yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNjY2ODEsImV4cCI6MjA4Mjk0MjY4MX0.-1tnu0EsUr4T13XqHLuwhmJwjnlcovcrZPcpHbqhkNY
```

### 4️⃣ Deploy! (1 minute)
- Click "Deploy site"
- Wait 2-3 minutes for build to complete

### 5️⃣ Done! ✅
Your site is live at: `https://your-site-name.netlify.app`

---

## 🔑 Login Credentials

**Username:** `admin`  
**Password:** `admin123`

---

## 📋 Visual Checklist

```
Step 1: Sign up with GitHub          ✅
Step 2: Import LMS repository         ✅
Step 3: Set build command             ✅
Step 4: Set publish directory         ✅
Step 5: Add VITE_SUPABASE_URL         ✅
Step 6: Add VITE_SUPABASE_ANON_KEY    ✅
Step 7: Click Deploy                  ✅
Step 8: Wait for build                ✅
Step 9: Site is live!                 🎉
```

---

## 🆘 Troubleshooting

**Build failed?**
→ Check environment variables are added correctly

**Blank screen?**
→ Verify Supabase credentials in environment variables

**Can't login?**
→ Make sure you ran the database SQL in Supabase

---

## 🎯 That's It!

Your LMS is now live on the internet! 🌐

**Full guide:** See `DEPLOY_TO_NETLIFY.md` for detailed instructions
