# LMS - Legal Management System

A comprehensive legal case management system built with React, TypeScript, and Supabase.

## 🚀 Features

- **Case Management**: Track and manage legal cases with detailed information
- **Client Management**: Maintain client records and contact information
- **Appointments**: Schedule and manage appointments with calendar integration
- **Finance Tracking**: Monitor payments, transactions, and financial records
- **Counsel Management**: Manage legal counsel and their assigned cases
- **Library System**: Organize and track legal documents and books
- **Storage Management**: File storage and document management
- **User Authentication**: Secure login system with role-based access
- **Admin Panel**: Administrative controls for user and system management
- **Real-time Updates**: Live notifications and data synchronization
- **Responsive Design**: Works seamlessly on desktop and mobile devices

## 🛠️ Tech Stack

- **Frontend**: React 18, TypeScript, Vite
- **Styling**: Tailwind CSS, Framer Motion
- **Backend**: Supabase (PostgreSQL, Authentication, Storage)
- **State Management**: React Context API
- **Routing**: React Router v6
- **Forms**: React Hook Form with Zod validation
- **Icons**: Lucide React

## 📋 Prerequisites

- Node.js 18 or higher
- npm or yarn
- Supabase account (free tier available)

## 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/unknowncoder84/LMS.git
   cd LMS
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   VITE_SUPABASE_URL=your_supabase_project_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Set up the database**
   
   - Go to your Supabase project dashboard
   - Navigate to SQL Editor
   - Copy the contents of `FRESH_DATABASE_SETUP.sql`
   - Paste and run the SQL script

5. **Start the development server**
   ```bash
   npm run dev
   ```

6. **Open your browser**
   
   Navigate to `http://localhost:3000`

## 🔐 Default Login Credentials

After running the database setup:

- **Username**: `admin`
- **Password**: `admin123`

⚠️ **Important**: Change the default password after first login!

## 📚 Documentation

- **Setup Guide**: See `START_HERE_NOW.md` for quick setup instructions
- **Database Setup**: See `FRESH_DATABASE_SETUP.sql` for complete database schema
- **Local Development**: See `HOW_TO_RUN_LOCALLY.md` for detailed local setup

## 🏗️ Project Structure

```
LMS/
├── src/
│   ├── components/     # Reusable UI components
│   ├── contexts/       # React Context providers
│   ├── lib/           # Utility libraries and Supabase client
│   ├── pages/         # Application pages/routes
│   ├── types/         # TypeScript type definitions
│   └── utils/         # Helper functions
├── supabase/          # Database schema and migrations
├── public/            # Static assets
└── ...config files
```

## 🎯 Key Features Explained

### Case Management
- Create, edit, and track legal cases
- Assign cases to counsel
- Monitor case status and next hearing dates
- Store case-related documents

### Financial Tracking
- Record payments and transactions
- Track fees quoted vs. received
- Generate financial reports
- Monitor pending payments

### Appointments System
- Schedule appointments with clients
- Calendar view for easy visualization
- Appointment reminders and notifications

### User Roles
- **Admin**: Full system access and user management
- **User**: Standard access to cases and features
- **Vipin**: Custom role with specific permissions

## 🔒 Security

- Row Level Security (RLS) enabled on all tables
- Secure authentication with Supabase
- Role-based access control
- Environment variables for sensitive data

## 🚀 Deployment

### Build for Production

```bash
npm run build
```

The build output will be in the `dist/` directory.

### Deploy to Netlify

1. Connect your GitHub repository to Netlify
2. Set build command: `npm run build`
3. Set publish directory: `dist`
4. Add environment variables in Netlify dashboard

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License.

## 👨‍💻 Author

**Unknown Coder**
- GitHub: [@unknowncoder84](https://github.com/unknowncoder84)

## 🙏 Acknowledgments

- Built with [React](https://reactjs.org/)
- Powered by [Supabase](https://supabase.com/)
- Styled with [Tailwind CSS](https://tailwindcss.com/)
- Icons by [Lucide](https://lucide.dev/)

## 📞 Support

For support, please open an issue in the GitHub repository.

---

**Made with ❤️ for legal professionals**
