"use client"

import { useState } from 'react'
import { useStudy } from '@/lib/study-context'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { FieldGroup, Field, FieldLabel } from '@/components/ui/field'
import { BookOpen, GraduationCap, Target, TrendingUp } from 'lucide-react'
import { ThemeToggle } from '@/components/theme-toggle'
import { cn } from '@/lib/utils'

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
      <div className="flex-1 bg-primary/5 p-8 lg:p-12 flex flex-col justify-center overflow-hidden">
        <div className="max-w-md mx-auto lg:mx-0">
          <div className="flex items-center gap-3 mb-8 animate-fade-in-up">
            <div className="w-12 h-12 rounded-xl bg-primary flex items-center justify-center animate-pulse">
              <GraduationCap className="w-7 h-7 text-primary-foreground" />
            </div>
            <h1 className="text-2xl font-bold text-foreground">Smart Study Tracker</h1>
          </div>

          <h2 className="text-3xl lg:text-4xl font-bold text-foreground mb-4 text-balance animate-fade-in-up delay-100">
            Track your learning journey and achieve your goals
          </h2>
          <p className="text-muted-foreground mb-8 text-pretty animate-fade-in-up delay-200">
            The all-in-one study companion for students from school to engineering level.
            Track progress, take quizzes, and improve with daily analytics.
          </p>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {features.map((feature, index) => (
              <div 
                key={feature.title} 
                className={cn(
                  "flex items-start gap-3 p-4 rounded-lg bg-background/50 border border-border/50 transition-all hover:scale-105 hover:bg-background hover:shadow-lg animate-fade-in-up",
                  index === 0 ? "delay-300" : index === 1 ? "delay-400" : index === 2 ? "delay-500" : "delay-500"
                )}
              >
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
      <div className="flex-1 p-8 lg:p-12 flex items-center justify-center bg-background relative">
        <div className="absolute inset-0 bg-grid-slate-100 [mask-image:linear-gradient(0deg,#fff,rgba(255,255,255,0.6))] dark:bg-grid-slate-700/25" />
        <Card className="w-full max-w-md border-border/50 shadow-2xl relative z-10 animate-fade-in-up delay-300 backdrop-blur-sm bg-card/95">
          <CardHeader className="text-center">
            <CardTitle className="text-2xl transition-all duration-300">
              {isLogin ? 'Welcome back' : 'Create account'}
            </CardTitle>
            <CardDescription className="transition-all duration-300">
              {isLogin
                ? 'Sign in to continue your learning journey'
                : 'Start tracking your study progress today'}
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
              <FieldGroup>
                {!isLogin && (
                  <div className="animate-in fade-in slide-in-from-left-4 duration-300">
                    <Field>
                      <FieldLabel htmlFor="name">Full Name</FieldLabel>
                      <Input
                        id="name"
                        type="text"
                        placeholder="John Doe"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        required={!isLogin}
                        className="transition-all focus:ring-2 focus:ring-primary/20"
                      />
                    </Field>
                  </div>
                )}
                <Field>
                  <FieldLabel htmlFor="email">Email Address</FieldLabel>
                  <Input
                    id="email"
                    type="email"
                    placeholder="you@example.com"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    className="transition-all focus:ring-2 focus:ring-primary/20"
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
                    className="transition-all focus:ring-2 focus:ring-primary/20"
                  />
                </Field>
              </FieldGroup>

              {error && (
                <div className="text-sm text-destructive text-center bg-destructive/10 p-3 rounded-md animate-in shake duration-300">
                  {error}
                </div>
              )}

              <Button type="submit" className="w-full h-11 text-base font-semibold transition-all hover:scale-[1.02] active:scale-[0.98]" disabled={loading}>
                {loading ? (
                  <div className="flex items-center gap-2">
                    <span className="w-4 h-4 border-2 border-primary-foreground/30 border-t-primary-foreground rounded-full animate-spin" />
                    Please wait...
                  </div>
                ) : isLogin ? 'Sign In' : 'Create Account'}
              </Button>
            </form>

            <div className="mt-8 text-center">
              <button
                type="button"
                onClick={() => {
                  setIsLogin(!isLogin)
                  setError('')
                }}
                className="group text-sm text-muted-foreground hover:text-primary transition-colors flex items-center justify-center gap-2 mx-auto"
              >
                <span>{isLogin ? "Don't have an account?" : 'Already have an account?'}</span>
                <span className="font-bold border-b border-transparent group-hover:border-primary transition-all">
                  {isLogin ? 'Sign up' : 'Sign in'}
                </span>
              </button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
