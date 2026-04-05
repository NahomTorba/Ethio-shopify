@echo off
cd /d "%~dp0"
set SECRET_KEY_BASE=7d80d550400bb7707dd34530196bdee9c7bfd23295ad433c3591d1becb34c747a50215a092b1fa80e80283bb22ae4d97c9655e8ba0502b578f9298e388fa8742
set DATABASE_URL=postgresql://postgres.xgrdqkhrtuhxqntmvuxy:alazar1234%%401234@aws-0-eu-west-1.pooler.supabase.com:6543/postgres
set RAILS_ENV=production
set TELEGRAM_BOT_TOKEN=8780193190:AAEH-L6NA4nFZNklwYLsjKumKTvpIKEREFg
echo Running migrations...
bundle exec rails db:migrate
pause
