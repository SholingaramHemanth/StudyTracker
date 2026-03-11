"use client"

import { useState } from 'react'
import { useStudy, SUBJECTS_BY_LEVEL, EducationLevel, EngineeringBranch } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { FieldGroup, Field, FieldLabel } from '@/components/ui/field'
import { cn } from '@/lib/utils'
import { 
  User, 
  Mail, 
  GraduationCap, 
  BookOpen,
  Target,
  LogOut,
  Save,
  Settings,
  Flame
} from 'lucide-react'

const educationLabels: Record<EducationLevel, string> = {
  'class-1-5': 'Class 1-5',
  'class-6-10': 'Class 6-10',
  'intermediate': 'Intermediate',
  'engineering': 'Engineering',
  'other': 'Other Courses',
}

export function ProfilePage() {
  const { user, updateProfile, logout } = useStudy()
  const [editing, setEditing] = useState(false)
  const [name, setName] = useState(user?.name || '')
  const [dailyGoal, setDailyGoal] = useState(user?.dailyGoal || 120)

  const handleSave = () => {
    updateProfile({ name, dailyGoal })
    setEditing(false)
  }

  const handleLogout = () => {
    logout()
  }

  const getSubjectKey = () => {
    if (!user) return 'other'
    if (user.educationLevel === 'engineering' && user.branch) {
      return `engineering-${user.branch}`
    }
    return user.educationLevel
  }

  const subjects = SUBJECTS_BY_LEVEL[getSubjectKey()] || SUBJECTS_BY_LEVEL['other']

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div>
        <h2 className="text-2xl font-bold text-foreground mb-2">Profile</h2>
        <p className="text-muted-foreground">Manage your account and preferences</p>
      </div>

      {/* Profile card */}
      <Card className="border-border/50">
        <CardHeader>
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center">
                <span className="text-2xl font-bold text-primary">
                  {user?.name?.charAt(0).toUpperCase()}
                </span>
              </div>
              <div>
                <CardTitle>{user?.name}</CardTitle>
                <CardDescription>{user?.email}</CardDescription>
              </div>
            </div>
            <Button variant="outline" size="sm" onClick={() => setEditing(!editing)}>
              <Settings className="w-4 h-4 mr-2" />
              {editing ? 'Cancel' : 'Edit'}
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {editing ? (
            <div className="space-y-4">
              <FieldGroup>
                <Field>
                  <FieldLabel htmlFor="edit-name">Name</FieldLabel>
                  <Input
                    id="edit-name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="Your name"
                  />
                </Field>
                <Field>
                  <FieldLabel htmlFor="edit-goal">Daily Study Goal (minutes)</FieldLabel>
                  <Input
                    id="edit-goal"
                    type="number"
                    value={dailyGoal}
                    onChange={(e) => setDailyGoal(Number(e.target.value))}
                    min={15}
                    max={480}
                  />
                </Field>
              </FieldGroup>
              <Button onClick={handleSave} className="gap-2">
                <Save className="w-4 h-4" /> Save Changes
              </Button>
            </div>
          ) : (
            <div className="grid sm:grid-cols-2 gap-6">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-muted flex items-center justify-center">
                  <User className="w-5 h-5 text-muted-foreground" />
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Name</p>
                  <p className="font-medium text-foreground">{user?.name}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-muted flex items-center justify-center">
                  <Mail className="w-5 h-5 text-muted-foreground" />
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Email</p>
                  <p className="font-medium text-foreground">{user?.email}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-muted flex items-center justify-center">
                  <Target className="w-5 h-5 text-muted-foreground" />
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Daily Goal</p>
                  <p className="font-medium text-foreground">{Math.floor(dailyGoal / 60)}h {dailyGoal % 60}m</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-muted flex items-center justify-center">
                  <Flame className="w-5 h-5 text-muted-foreground" />
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Current Streak</p>
                  <p className="font-medium text-foreground">{user?.streak || 0} days</p>
                </div>
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Education info */}
      <Card className="border-border/50">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <GraduationCap className="w-5 h-5" />
            Education Details
          </CardTitle>
          <CardDescription>Your current academic information</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid sm:grid-cols-2 gap-6">
            <div>
              <p className="text-sm text-muted-foreground mb-1">Education Level</p>
              <p className="font-medium text-foreground">
                {user?.educationLevel ? educationLabels[user.educationLevel] : 'Not set'}
              </p>
            </div>
            {user?.class && (
              <div>
                <p className="text-sm text-muted-foreground mb-1">Class</p>
                <p className="font-medium text-foreground">{user.class}</p>
              </div>
            )}
            {user?.year && (
              <div>
                <p className="text-sm text-muted-foreground mb-1">Year</p>
                <p className="font-medium text-foreground">{user.year}</p>
              </div>
            )}
            {user?.branch && (
              <div>
                <p className="text-sm text-muted-foreground mb-1">Branch</p>
                <p className="font-medium text-foreground">{user.branch}</p>
              </div>
            )}
            {user?.semester && (
              <div>
                <p className="text-sm text-muted-foreground mb-1">Semester</p>
                <p className="font-medium text-foreground">Semester {user.semester}</p>
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Subjects */}
      <Card className="border-border/50">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <BookOpen className="w-5 h-5" />
            Your Subjects
          </CardTitle>
          <CardDescription>Subjects based on your education level</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
            {subjects.map((subject) => (
              <div
                key={subject.id}
                className="p-4 rounded-lg border border-border bg-card"
              >
                <span className="text-2xl mb-2 block">{subject.icon}</span>
                <span className="font-medium text-foreground text-sm">{subject.name}</span>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Goal settings */}
      <Card className="border-border/50">
        <CardHeader>
          <CardTitle>Study Goals</CardTitle>
          <CardDescription>Set your daily study targets</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <div>
              <p className="text-sm text-muted-foreground mb-3">Quick Goal Presets</p>
              <div className="flex flex-wrap gap-2">
                {[30, 60, 90, 120, 180, 240].map((mins) => (
                  <Button
                    key={mins}
                    variant={dailyGoal === mins ? 'default' : 'outline'}
                    size="sm"
                    onClick={() => {
                      setDailyGoal(mins)
                      updateProfile({ dailyGoal: mins })
                    }}
                  >
                    {mins >= 60 ? `${mins / 60}h` : `${mins}m`}
                  </Button>
                ))}
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Logout */}
      <Card className="border-destructive/50">
        <CardContent className="pt-6">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="font-medium text-foreground">Sign Out</h3>
              <p className="text-sm text-muted-foreground">Sign out of your account</p>
            </div>
            <Button variant="destructive" onClick={handleLogout}>
              <LogOut className="w-4 h-4 mr-2" /> Sign Out
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
