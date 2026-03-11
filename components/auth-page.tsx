"use client"

import { useState } from 'react'
import { useStudy } from '@/lib/study-context'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { FieldGroup, Field, FieldLabel } from '@/components/ui/field'
import { BookOpen, GraduationCap, Target, TrendingUp } from 'lucide-react'
import { ThemeToggle } from '@/components/theme-toggle'

export function AuthPage() {
  const [isLogin, setIsLogin] = useState(true)
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { login, signup } = useStudy()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      let success: boolean
      if (isLogin) {
        success = await login(email, password)
        if (!success) {
          setError('Invalid email or password')
        }
      } else {
        if (!name.trim()) {
          setError('Name is required')
          setLoading(false)
          return
        }
        success = await signup(name, email, password)
        if (!success) {
          setError('Email already exists')
        }
      }
    } catch {
      setError('Something went wrong. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  const features = [
    { icon: BookOpen, title: 'Track Study Hours', description: 'Log your daily study sessions' },
    { icon: Target, title: 'Take Quizzes', description: 'Test your knowledge with daily quizzes' },
    { icon: TrendingUp, title: 'View Analytics', description: 'Analyze your performance over time' },
    { icon: GraduationCap, title: 'Stay Motivated', description: 'Build streaks and achieve goals' },
  ]

  return (
    <div className="min-h-screen bg-background flex flex-col lg:flex-row relative">
      <div className="absolute top-4 right-4 z-50">
        <ThemeToggle />
      </div>
      {/* Left side - Branding */}
      <div className="flex-1 bg-primary/5 p-8 lg:p-12 flex flex-col justify-center">
        <div className="max-w-md mx-auto lg:mx-0">
          <div className="flex items-center gap-3 mb-8">
            <div className="w-12 h-12 rounded-xl bg-primary flex items-center justify-center">
              <GraduationCap className="w-7 h-7 text-primary-foreground" />
            </div>
            <h1 className="text-2xl font-bold text-foreground">Smart Study Tracker</h1>
          </div>

          <h2 className="text-3xl lg:text-4xl font-bold text-foreground mb-4 text-balance">
            Track your learning journey and achieve your goals
          </h2>
          <p className="text-muted-foreground mb-8 text-pretty">
            The all-in-one study companion for students from school to engineering level.
            Track progress, take quizzes, and improve with daily analytics.
          </p>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {features.map((feature) => (
              <div key={feature.title} className="flex items-start gap-3 p-4 rounded-lg bg-background/50">
                <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center flex-shrink-0">
                  <feature.icon className="w-5 h-5 text-primary" />
                </div>
                <div>
                  <h3 className="font-medium text-foreground">{feature.title}</h3>
                  <p className="text-sm text-muted-foreground">{feature.description}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Right side - Auth Form */}
      <div className="flex-1 p-8 lg:p-12 flex items-center justify-center">
        <Card className="w-full max-w-md border-border/50">
          <CardHeader className="text-center">
            <CardTitle className="text-2xl">{isLogin ? 'Welcome back' : 'Create account'}</CardTitle>
            <CardDescription>
              {isLogin
                ? 'Sign in to continue your learning journey'
                : 'Start tracking your study progress today'}
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
              <FieldGroup>
                {!isLogin && (
                  <Field>
                    <FieldLabel htmlFor="name">Full Name</FieldLabel>
                    <Input
                      id="name"
                      type="text"
                      placeholder="John Doe"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      required={!isLogin}
                    />
                  </Field>
                )}
                <Field>
                  <FieldLabel htmlFor="email">Email</FieldLabel>
                  <Input
                    id="email"
                    type="email"
                    placeholder="you@example.com"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                  />
                </Field>
                <Field>
                  <FieldLabel htmlFor="password">Password</FieldLabel>
                  <Input
                    id="password"
                    type="password"
                    placeholder="••••••••"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    minLength={6}
                  />
                </Field>
              </FieldGroup>

              {error && (
                <div className="text-sm text-destructive text-center bg-destructive/10 p-2 rounded-md">
                  {error}
                </div>
              )}

              <Button type="submit" className="w-full" disabled={loading}>
                {loading ? 'Please wait...' : isLogin ? 'Sign In' : 'Create Account'}
              </Button>
            </form>

            <div className="mt-6 text-center">
              <button
                type="button"
                onClick={() => {
                  setIsLogin(!isLogin)
                  setError('')
                }}
                className="text-sm text-muted-foreground hover:text-primary transition-colors"
              >
                {isLogin ? "Don't have an account? Sign up" : 'Already have an account? Sign in'}
              </button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
