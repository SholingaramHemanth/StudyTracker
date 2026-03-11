"use client"

import { useState } from 'react'
import { useStudy } from '@/lib/study-context'
import dynamic from 'next/dynamic'

const DashboardHome = dynamic(() => import('@/components/dashboard-home').then(mod => mod.DashboardHome))
const StudyTimerPage = dynamic(() => import('@/components/study-timer-page').then(mod => mod.StudyTimerPage))
const QuizPage = dynamic(() => import('@/components/quiz-page').then(mod => mod.QuizPage))
const AnalyticsPage = dynamic(() => import('@/components/analytics-page').then(mod => mod.AnalyticsPage))
const ProfilePage = dynamic(() => import('@/components/profile-page').then(mod => mod.ProfilePage))
const AIChatPage = dynamic(() => import('@/components/ai-chat-page').then(mod => mod.AIChatPage))
const TutorPage = dynamic(() => import('@/components/tutor-page').then(mod => mod.TutorPage))
const DoubtSolver = dynamic(() => import('@/components/doubt-solver').then(mod => mod.DoubtSolver))
const FlashcardsPage = dynamic(() => import('@/components/flashcards-page').then(mod => mod.FlashcardsPage))
const ResourcesPage = dynamic(() => import('@/components/resources-page').then(mod => mod.ResourcesPage))
const GuidancePage = dynamic(() => import('@/components/guidance-page').then(mod => mod.GuidancePage))
const SettingsPage = dynamic(() => import('@/components/settings-page').then(mod => mod.SettingsPage))
const StudyPlannerPage = dynamic(() => import('@/components/study-planner-page').then(mod => mod.StudyPlannerPage))
import { cn } from '@/lib/utils'
import {
  LayoutDashboard,
  Timer,
  FileQuestion,
  BarChart3,
  User,
  Menu,
  X,
  GraduationCap,
  MessageSquareCode,
  Brain,
  Layers,
  Map,
  BookMarked,
  Search as SearchIcon,
  Settings,
  Calendar
} from 'lucide-react'
import { Button } from '@/components/ui/button'
import { ThemeToggle } from '@/components/theme-toggle'

type Page = 'home' | 'timer' | 'quiz' | 'analytics' | 'profile' | 'ai' | 'tutor' | 'solver' | 'flashcards' | 'resources' | 'guidance' | 'planner' | 'settings'

const navItems = [
  { id: 'home' as Page, label: 'Dashboard', icon: LayoutDashboard },
  { id: 'tutor' as Page, label: 'AI Tutor', icon: GraduationCap },
  { id: 'solver' as Page, label: 'Doubt Solver', icon: Brain },
  { id: 'flashcards' as Page, label: 'Flashcards', icon: Layers },
  { id: 'resources' as Page, label: 'Resources', icon: BookMarked },
  { id: 'planner' as Page, label: 'Study Planner', icon: Calendar },
  { id: 'timer' as Page, label: 'Study Timer', icon: Timer },
  { id: 'quiz' as Page, label: 'Quizzes', icon: FileQuestion },
  { id: 'ai' as Page, label: 'AI Assistant', icon: MessageSquareCode },
  { id: 'guidance' as Page, label: 'Career Guidance', icon: Map },
  { id: 'analytics' as Page, label: 'Analytics', icon: BarChart3 },
  { id: 'profile' as Page, label: 'Profile', icon: User },
]
export function Dashboard() {
  const [currentPage, setCurrentPage] = useState<Page>('home')
  const { user } = useStudy()

  const renderPage = () => {
    switch (currentPage) {
      case 'home':
        return <DashboardHome onNavigate={setCurrentPage} />
      case 'timer':
        return <StudyTimerPage />
      case 'quiz':
        return <QuizPage />
      case 'analytics':
        return <AnalyticsPage />
      case 'profile':
        return <ProfilePage />
      case 'ai':
        return <AIChatPage />
      case 'tutor':
        return <TutorPage />
      case 'solver':
        return <DoubtSolver />
      case 'flashcards':
        return <FlashcardsPage />
      case 'resources':
        return <ResourcesPage />
      case 'guidance':
        return <GuidancePage />
      case 'planner':
        return <StudyPlannerPage />
      case 'settings':
        return <SettingsPage />
      default:
        return <DashboardHome onNavigate={setCurrentPage} />
    }
  }

  const bottomNavItems = [
    { id: 'home' as Page, label: 'Home', icon: LayoutDashboard },
    { id: 'tutor' as Page, label: 'Features', icon: Layers },
    { id: 'resources' as Page, label: 'Search', icon: SearchIcon },
    { id: 'profile' as Page, label: 'Profile', icon: User },
    { id: 'settings' as Page, label: 'Settings', icon: Settings },
  ]

  return (
    <div className="min-h-screen bg-background flex">
      {/* Sidebar - Desktop Only */}
      <aside className="hidden lg:flex sticky top-0 left-0 z-50 h-[100dvh] w-64 bg-card border-r border-border flex-col">
        {/* Logo */}
        <div className="p-6 border-b border-border flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-primary flex items-center justify-center">
              <GraduationCap className="w-6 h-6 text-primary-foreground" />
            </div>
            <span className="font-bold text-foreground">StudyTracker</span>
          </div>
        </div>

        {/* Navigation */}
        <nav className="flex-1 p-4 overflow-y-auto">
          <ul className="space-y-2">
            {navItems.map((item) => (
              <li key={item.id}>
                <button
                  onClick={() => setCurrentPage(item.id)}
                  className={cn(
                    "w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left transition-colors",
                    currentPage === item.id
                      ? "bg-primary text-primary-foreground"
                      : "text-muted-foreground hover:bg-muted hover:text-foreground"
                  )}
                >
                  <item.icon className="w-5 h-5" />
                  <span className="font-medium">{item.label}</span>
                </button>
              </li>
            ))}
          </ul>
        </nav>

        {/* User info */}
        <div className="p-4 border-t border-border">
          <div className="flex items-center gap-3 px-2">
            <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
              <span className="text-primary font-semibold">
                {user?.name?.charAt(0).toUpperCase()}
              </span>
            </div>
            <div className="flex-1 min-w-0">
              <p className="font-medium text-foreground truncate">{user?.name}</p>
              <p className="text-xs text-muted-foreground truncate">{user?.email}</p>
            </div>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <div className="flex-1 flex flex-col min-h-[100dvh] pb-20 lg:pb-0">
        {/* Top header */}
        <header className="sticky top-0 z-30 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 border-b border-border">
          <div className="flex items-center justify-between px-4 lg:px-6 h-16">
            <div className="flex items-center gap-4">
              <div className="lg:hidden w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
                <GraduationCap className="w-5 h-5 text-primary-foreground" />
              </div>
              <h1 className="text-lg font-semibold text-foreground">
                {navItems.find(item => item.id === currentPage)?.label || 'Dashboard'}
              </h1>
            </div>
            <ThemeToggle />
          </div>
        </header>

        {/* Page content */}
        <main className="flex-1 p-4 lg:p-6 pb-6">
          {renderPage()}
        </main>
      </div>

      {/* Mobile Bottom Navigation */}
      <nav className="lg:hidden fixed bottom-0 left-0 right-0 z-50 bg-card border-t border-border mt-auto pt-2 pb-safe supports-[padding-bottom:env(safe-area-inset-bottom)]:pb-[env(safe-area-inset-bottom)]">
        <ul className="flex items-center justify-around px-2 pb-2">
          {bottomNavItems.map((item) => (
            <li key={item.id} className="flex-1">
              <button
                onClick={() => setCurrentPage(item.id)}
                className={cn(
                  "w-full flex flex-col items-center justify-center gap-1 p-2 rounded-xl transition-all duration-200",
                  currentPage === item.id
                    ? "text-primary scale-110"
                    : "text-muted-foreground hover:text-foreground"
                )}
              >
                <div className={cn(
                  "p-1.5 rounded-full transition-colors",
                  currentPage === item.id ? "bg-primary/10" : "bg-transparent"
                )}>
                  <item.icon className="w-5 h-5 flex-shrink-0" />
                </div>
                <span className="text-[10px] font-medium tracking-wide">
                  {item.label}
                </span>
              </button>
            </li>
          ))}
        </ul>
      </nav>
    </div>
  )
}
