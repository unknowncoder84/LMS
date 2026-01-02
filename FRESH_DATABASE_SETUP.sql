-- =====================================================
-- LMS - FRESH DATABASE SETUP (Complete from Scratch)
-- Copy and paste this ENTIRE file into Supabase SQL Editor
-- Then click "RUN" to set up everything
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- 1. USER_ACCOUNTS TABLE (Username/Password Authentication)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.user_accounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('admin', 'user', 'vipin')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.user_accounts ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can view active users" ON public.user_accounts FOR SELECT USING (is_active = true);
CREATE POLICY "Allow first user creation" ON public.user_accounts FOR INSERT WITH CHECK (NOT EXISTS (SELECT 1 FROM public.user_accounts));

-- Index
CREATE INDEX IF NOT EXISTS idx_user_accounts_username ON public.user_accounts(username);

-- =====================================================
-- 2. AUTHENTICATION FUNCTION
-- =====================================================
CREATE OR REPLACE FUNCTION public.authenticate_user(
  p_username VARCHAR,
  p_password VARCHAR
)
RETURNS TABLE (
  success BOOLEAN,
  user_id UUID,
  username VARCHAR,
  name VARCHAR,
  email VARCHAR,
  role VARCHAR,
  is_active BOOLEAN,
  error_message TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    CASE WHEN ua.password = p_password THEN true ELSE false END as success,
    ua.id as user_id,
    ua.username,
    ua.name,
    ua.email,
    ua.role,
    ua.is_active,
    CASE 
      WHEN ua.password = p_password THEN NULL
      ELSE 'Invalid username or password'
    END as error_message
  FROM public.user_accounts ua
  WHERE ua.username = p_username AND ua.is_active = true
  LIMIT 1;
  
  IF NOT FOUND THEN
    RETURN QUERY SELECT false, NULL::UUID, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::BOOLEAN, 'Invalid username or password'::TEXT;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 3. USER MANAGEMENT FUNCTIONS
-- =====================================================

-- Get all users
CREATE OR REPLACE FUNCTION public.get_all_users()
RETURNS SETOF public.user_accounts AS $$
BEGIN
  RETURN QUERY SELECT * FROM public.user_accounts WHERE is_active = true ORDER BY created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create user
CREATE OR REPLACE FUNCTION public.create_user_account(
  p_name VARCHAR,
  p_email VARCHAR,
  p_username VARCHAR,
  p_password VARCHAR,
  p_role VARCHAR,
  p_created_by VARCHAR DEFAULT NULL
)
RETURNS TABLE (
  success BOOLEAN,
  user_id UUID,
  error_message TEXT
) AS $$
BEGIN
  INSERT INTO public.user_accounts (name, email, username, password, role, is_active)
  VALUES (p_name, p_email, p_username, p_password, p_role, true)
  RETURNING id INTO user_id;
  
  RETURN QUERY SELECT true, user_id, NULL::TEXT;
EXCEPTION WHEN OTHERS THEN
  RETURN QUERY SELECT false, NULL::UUID, SQLERRM::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Update user role
CREATE OR REPLACE FUNCTION public.update_user_role(
  p_user_id UUID,
  p_new_role VARCHAR,
  p_updated_by VARCHAR
)
RETURNS TABLE (
  success BOOLEAN,
  error_message TEXT
) AS $$
BEGIN
  UPDATE public.user_accounts SET role = p_new_role, updated_at = NOW()
  WHERE id = p_user_id;
  
  RETURN QUERY SELECT true, NULL::TEXT;
EXCEPTION WHEN OTHERS THEN
  RETURN QUERY SELECT false, SQLERRM::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Toggle user status
CREATE OR REPLACE FUNCTION public.toggle_user_status(
  p_user_id UUID,
  p_updated_by VARCHAR
)
RETURNS TABLE (
  success BOOLEAN,
  new_status BOOLEAN,
  error_message TEXT
) AS $$
DECLARE
  v_new_status BOOLEAN;
BEGIN
  UPDATE public.user_accounts 
  SET is_active = NOT is_active, updated_at = NOW()
  WHERE id = p_user_id
  RETURNING is_active INTO v_new_status;
  
  RETURN QUERY SELECT true, v_new_status, NULL::TEXT;
EXCEPTION WHEN OTHERS THEN
  RETURN QUERY SELECT false, NULL::BOOLEAN, SQLERRM::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Delete user
CREATE OR REPLACE FUNCTION public.delete_user_account(
  p_user_id UUID,
  p_deleted_by VARCHAR
)
RETURNS TABLE (
  success BOOLEAN,
  error_message TEXT
) AS $$
BEGIN
  DELETE FROM public.user_accounts WHERE id = p_user_id;
  
  RETURN QUERY SELECT true, NULL::TEXT;
EXCEPTION WHEN OTHERS THEN
  RETURN QUERY SELECT false, SQLERRM::TEXT;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 4. COURTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.courts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.courts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view courts" ON public.courts FOR SELECT USING (true);
CREATE POLICY "Anyone can insert courts" ON public.courts FOR INSERT WITH CHECK (true);

-- =====================================================
-- 5. CASE_TYPES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.case_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.case_types ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view case types" ON public.case_types FOR SELECT USING (true);
CREATE POLICY "Anyone can insert case types" ON public.case_types FOR INSERT WITH CHECK (true);

-- =====================================================
-- 6. DISTRICTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.districts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.districts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view districts" ON public.districts FOR SELECT USING (true);
CREATE POLICY "Anyone can insert districts" ON public.districts FOR INSERT WITH CHECK (true);

-- =====================================================
-- 7. CASES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.cases (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_name VARCHAR(255) NOT NULL,
  client_email VARCHAR(255),
  client_mobile VARCHAR(20),
  client_alternate_no VARCHAR(20),
  file_no VARCHAR(100) NOT NULL,
  stamp_no VARCHAR(100),
  reg_no VARCHAR(100),
  parties_name TEXT,
  district VARCHAR(100),
  case_type VARCHAR(100),
  court VARCHAR(255),
  on_behalf_of VARCHAR(255),
  no_resp VARCHAR(100),
  opponent_lawyer VARCHAR(255),
  additional_details TEXT,
  fees_quoted DECIMAL(12, 2) DEFAULT 0,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'closed', 'on-hold')),
  next_date DATE,
  filing_date DATE,
  circulation_status VARCHAR(20) DEFAULT 'non-circulated',
  interim_relief VARCHAR(20) DEFAULT 'none',
  created_by UUID REFERENCES public.user_accounts(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.cases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view cases" ON public.cases FOR SELECT USING (true);
CREATE POLICY "Anyone can insert cases" ON public.cases FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update cases" ON public.cases FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete cases" ON public.cases FOR DELETE USING (true);

CREATE INDEX idx_cases_status ON public.cases(status);
CREATE INDEX idx_cases_client_name ON public.cases(client_name);
CREATE INDEX idx_cases_file_no ON public.cases(file_no);
CREATE INDEX idx_cases_next_date ON public.cases(next_date);

-- =====================================================
-- 8. COUNSEL TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.counsel (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  mobile VARCHAR(20),
  address TEXT,
  details TEXT,
  total_cases INTEGER DEFAULT 0,
  created_by UUID REFERENCES public.user_accounts(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.counsel ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view counsel" ON public.counsel FOR SELECT USING (true);
CREATE POLICY "Anyone can insert counsel" ON public.counsel FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update counsel" ON public.counsel FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete counsel" ON public.counsel FOR DELETE USING (true);

-- =====================================================
-- 9. APPOINTMENTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.appointments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  date DATE NOT NULL,
  time VARCHAR(10),
  user_id UUID REFERENCES public.user_accounts(id),
  user_name VARCHAR(255),
  client VARCHAR(255),
  details TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view appointments" ON public.appointments FOR SELECT USING (true);
CREATE POLICY "Anyone can insert appointments" ON public.appointments FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update appointments" ON public.appointments FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete appointments" ON public.appointments FOR DELETE USING (true);

CREATE INDEX idx_appointments_date ON public.appointments(date);

-- =====================================================
-- 10. TRANSACTIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  amount DECIMAL(12, 2) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('received', 'pending')),
  received_by VARCHAR(255),
  confirmed_by VARCHAR(255),
  case_id UUID REFERENCES public.cases(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view transactions" ON public.transactions FOR SELECT USING (true);
CREATE POLICY "Anyone can insert transactions" ON public.transactions FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update transactions" ON public.transactions FOR UPDATE USING (true);

-- =====================================================
-- 11. TASKS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(255) NOT NULL,
  details TEXT,
  assigned_to UUID REFERENCES public.user_accounts(id),
  assigned_by UUID REFERENCES public.user_accounts(id),
  deadline DATE,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in-progress', 'completed')),
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view tasks" ON public.tasks FOR SELECT USING (true);
CREATE POLICY "Anyone can insert tasks" ON public.tasks FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update tasks" ON public.tasks FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete tasks" ON public.tasks FOR DELETE USING (true);

-- =====================================================
-- 12. ATTENDANCE TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.attendance (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.user_accounts(id),
  user_name VARCHAR(255),
  date DATE NOT NULL,
  status VARCHAR(20) DEFAULT 'present' CHECK (status IN ('present', 'absent', 'half-day', 'leave')),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, date)
);

ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view attendance" ON public.attendance FOR SELECT USING (true);
CREATE POLICY "Anyone can insert attendance" ON public.attendance FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update attendance" ON public.attendance FOR UPDATE USING (true);

-- =====================================================
-- 13. EXPENSES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.expenses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(255) NOT NULL,
  amount DECIMAL(12, 2) NOT NULL,
  category VARCHAR(100),
  month VARCHAR(7),
  description TEXT,
  created_by UUID REFERENCES public.user_accounts(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view expenses" ON public.expenses FOR SELECT USING (true);
CREATE POLICY "Anyone can insert expenses" ON public.expenses FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update expenses" ON public.expenses FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete expenses" ON public.expenses FOR DELETE USING (true);

-- =====================================================
-- 14. LIBRARY LOCATIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.library_locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  created_by VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.library_locations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view library locations" ON public.library_locations FOR SELECT USING (true);
CREATE POLICY "Anyone can insert library locations" ON public.library_locations FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can delete library locations" ON public.library_locations FOR DELETE USING (true);

-- =====================================================
-- 15. BOOKS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.books (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  number VARCHAR(100),
  location VARCHAR(255),
  location_id UUID REFERENCES public.library_locations(id) ON DELETE SET NULL,
  added_by VARCHAR(255),
  added_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view books" ON public.books FOR SELECT USING (true);
CREATE POLICY "Anyone can insert books" ON public.books FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update books" ON public.books FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete books" ON public.books FOR DELETE USING (true);

-- =====================================================
-- 16. STORAGE LOCATIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.storage_locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  created_by VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.storage_locations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view storage locations" ON public.storage_locations FOR SELECT USING (true);
CREATE POLICY "Anyone can insert storage locations" ON public.storage_locations FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can delete storage locations" ON public.storage_locations FOR DELETE USING (true);

-- =====================================================
-- 17. STORAGE ITEMS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.storage_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50),
  location VARCHAR(255),
  location_id UUID REFERENCES public.storage_locations(id) ON DELETE SET NULL,
  added_by VARCHAR(255),
  added_at TIMESTAMPTZ DEFAULT NOW(),
  dropbox_path TEXT,
  dropbox_link TEXT
);

ALTER TABLE public.storage_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view storage items" ON public.storage_items FOR SELECT USING (true);
CREATE POLICY "Anyone can insert storage items" ON public.storage_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update storage items" ON public.storage_items FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete storage items" ON public.storage_items FOR DELETE USING (true);

-- =====================================================
-- 18. CASE FILES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.case_files (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  case_id UUID REFERENCES public.cases(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  url TEXT,
  file_type VARCHAR(50),
  uploaded_by VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.case_files ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view case files" ON public.case_files FOR SELECT USING (true);
CREATE POLICY "Anyone can insert case files" ON public.case_files FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can delete case files" ON public.case_files FOR DELETE USING (true);

-- =====================================================
-- 19. NOTIFICATIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.user_accounts(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  icon VARCHAR(50),
  related_id UUID,
  is_read BOOLEAN DEFAULT false,
  created_by UUID REFERENCES public.user_accounts(id),
  created_by_name VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view notifications" ON public.notifications FOR SELECT USING (true);
CREATE POLICY "Anyone can insert notifications" ON public.notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update notifications" ON public.notifications FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete notifications" ON public.notifications FOR DELETE USING (true);

CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_is_read ON public.notifications(is_read);

-- =====================================================
-- 20. NOTIFICATION FUNCTIONS
-- =====================================================
CREATE OR REPLACE FUNCTION public.mark_notification_read(p_notification_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  UPDATE public.notifications SET is_read = true WHERE id = p_notification_id;
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.mark_all_notifications_read(p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  UPDATE public.notifications SET is_read = true WHERE user_id = p_user_id;
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 21. DASHBOARD STATS FUNCTION
-- =====================================================
CREATE OR REPLACE FUNCTION get_dashboard_stats()
RETURNS TABLE (
  total_cases BIGINT,
  active_cases BIGINT,
  pending_cases BIGINT,
  closed_cases BIGINT,
  on_hold_cases BIGINT,
  total_counsel BIGINT,
  total_appointments BIGINT,
  upcoming_hearings BIGINT,
  total_received DECIMAL,
  total_pending DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    (SELECT COUNT(*) FROM public.cases)::BIGINT,
    (SELECT COUNT(*) FROM public.cases WHERE status = 'active')::BIGINT,
    (SELECT COUNT(*) FROM public.cases WHERE status = 'pending')::BIGINT,
    (SELECT COUNT(*) FROM public.cases WHERE status = 'closed')::BIGINT,
    (SELECT COUNT(*) FROM public.cases WHERE status = 'on-hold')::BIGINT,
    (SELECT COUNT(*) FROM public.counsel)::BIGINT,
    (SELECT COUNT(*) FROM public.appointments WHERE date >= CURRENT_DATE)::BIGINT,
    (SELECT COUNT(*) FROM public.cases WHERE next_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days')::BIGINT,
    (SELECT COALESCE(SUM(amount), 0) FROM public.transactions WHERE status = 'received'),
    (SELECT COALESCE(SUM(amount), 0) FROM public.transactions WHERE status = 'pending');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 22. INSERT DEFAULT DATA
-- =====================================================

-- Insert default courts
INSERT INTO public.courts (name) VALUES 
  ('Supreme Court'),
  ('High Court'),
  ('District Court'),
  ('Sessions Court'),
  ('Civil Court'),
  ('Family Court'),
  ('Consumer Court'),
  ('Labour Court'),
  ('Tribunal'),
  ('Magistrate Court')
ON CONFLICT (name) DO NOTHING;

-- Insert default case types
INSERT INTO public.case_types (name) VALUES 
  ('Civil'),
  ('Criminal'),
  ('Family'),
  ('Corporate'),
  ('Immigration'),
  ('Real Estate'),
  ('Labour'),
  ('Tax'),
  ('Constitutional'),
  ('Consumer Protection'),
  ('Intellectual Property'),
  ('Banking'),
  ('Insurance'),
  ('Arbitration'),
  ('Writ Petition')
ON CONFLICT (name) DO NOTHING;

-- Insert default districts
INSERT INTO public.districts (name) VALUES 
  ('Mumbai'),
  ('Delhi'),
  ('Bangalore'),
  ('Pune'),
  ('Hyderabad'),
  ('Chennai'),
  ('Kolkata'),
  ('Ahmedabad')
ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- 23. CREATE ADMIN USER
-- =====================================================
INSERT INTO public.user_accounts (username, password, name, email, role, is_active)
VALUES ('admin', 'admin123', 'Administrator', 'admin@lms.local', 'admin', true)
ON CONFLICT (username) DO NOTHING;

-- =====================================================
-- 24. STORAGE BUCKET SETUP
-- =====================================================
INSERT INTO storage.buckets (id, name, public) 
VALUES ('case-files', 'case-files', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies
CREATE POLICY "Case files are publicly accessible" ON storage.objects FOR SELECT USING (bucket_id = 'case-files');
CREATE POLICY "Anyone can upload case files" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'case-files');
CREATE POLICY "Anyone can update case files" ON storage.objects FOR UPDATE USING (bucket_id = 'case-files');
CREATE POLICY "Anyone can delete case files" ON storage.objects FOR DELETE USING (bucket_id = 'case-files');

-- =====================================================
-- ✅ SETUP COMPLETE!
-- =====================================================
-- 
-- Your database is now ready to use!
-- 
-- LOGIN CREDENTIALS:
-- Username: admin
-- Password: admin123
-- 
-- NEXT STEPS:
-- 1. Update your .env file with Supabase credentials
-- 2. Restart your dev server (npm run dev)
-- 3. Go to http://localhost:3000/
-- 4. Login with the credentials above
-- 
-- =====================================================
