"use client"

import { useEffect, useState } from 'react'
import { StudyProvider, useStudy } from '@/lib/study-context'
import { AuthPage } from '@/components/auth-page'
import { OnboardingFlow } from '@/components/onboarding-flow'
import { Dashboard } from '@/components/dashboard'

function AppContent() {
  const { isAuthenticated, user } = useStudy()
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="animate-pulse text-muted-foreground">Loading...</div>
      </div>
    )
  }

  if (!isAuthenticated || !user) {
    return <AuthPage />
  }

  if (!user?.subjects || user.subjects.length === 0) {
    return <OnboardingFlow />
  }

  return <Dashboard />
}

export default function Home() {
  return (
    <StudyProvider>
      <AppContent />
    </StudyProvider>
  )
}
