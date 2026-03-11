"use client"

import { useStudy } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import {
  Clock,
  Flame,
  Target,
  TrendingUp,
  BookOpen,
  Play,
  ChevronRight,
  Bell,
  History,
  Sparkles,
  Zap,
  Layers,
  Brain,
  Download,
  Map as MapIcon
} from 'lucide-react'
import { cn } from '@/lib/utils'
import { BarChart, Bar, XAxis, YAxis, ResponsiveContainer, Tooltip } from 'recharts'

type Page = 'home' | 'timer' | 'quiz' | 'analytics' | 'profile' | 'solver' | 'flashcards' | 'resources' | 'guidance'

interface DashboardHomeProps {
  onNavigate: (page: Page) => void
}

export function DashboardHome({ onNavigate }: DashboardHomeProps) {
  const { user, getTodayStudyTime, getWeeklyStudyData, getSubjectStrength, revisionReminders, offlineMode, toggleOfflineMode } = useStudy()

  const todayMinutes = getTodayStudyTime()
  const todayHours = Math.floor(todayMinutes / 60)
  const todayMins = todayMinutes % 60
  const dailyGoal = user?.dailyGoal || 120
  const progress = Math.min((todayMinutes / dailyGoal) * 100, 100)

  const weeklyData = getWeeklyStudyData()
  const subjectStrength = getSubjectStrength()

  const stats = [
    {
      label: 'Today',
      value: `${todayHours}h ${todayMins}m`,
      icon: Clock,
      color: 'text-chart-1',
      bgColor: 'bg-chart-1/10',
    },
    {
      label: 'Streak',
      value: `${user?.streak || 0} days`,
      icon: Flame,
      color: 'text-chart-3',
      bgColor: 'bg-chart-3/10',
    },
    {
      label: 'Goal',
      value: `${Math.round(progress)}%`,
      icon: Target,
      color: 'text-chart-2',
      bgColor: 'bg-chart-2/10',
    },
    {
      label: 'Subjects',
      value: `${user?.subjects?.length || 0}`,
      icon: BookOpen,
      color: 'text-chart-4',
      bgColor: 'bg-chart-4/10',
    },
  ]

  return (
    <div className="space-y-6">
      {/* Welcome message */}
      <div>
        <h2 className="text-2xl font-bold text-foreground">
          Welcome back, {user?.name?.split(' ')[0]}!
        </h2>
        <p className="text-muted-foreground">Here is your study progress for today</p>
      </div>

      {/* Stats grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        {stats.map((stat) => (
          <Card key={stat.label} className="border-border/50">
            <CardContent className="pt-6">
              <div className="flex items-center gap-4">
                <div className={`w-12 h-12 rounded-xl ${stat.bgColor} flex items-center justify-center`}>
                  <stat.icon className={`w-6 h-6 ${stat.color}`} />
                </div>
                <div>
                  <p className="text-2xl font-bold text-foreground">{stat.value}</p>
                  <p className="text-sm text-muted-foreground">{stat.label}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Daily goal progress */}
      <Card className="border-border/50">
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Daily Study Goal</CardTitle>
              <CardDescription>
                {todayMinutes} of {dailyGoal} minutes completed
              </CardDescription>
            </div>
            <Button onClick={() => onNavigate('timer')} className="gap-2">
              <Play className="w-4 h-4" /> Start Session
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <Progress value={progress} className="h-3" />
          <div className="flex justify-between mt-2 text-sm text-muted-foreground">
            <span>0 min</span>
            <span>{dailyGoal} min</span>
          </div>
        </CardContent>
      </Card>

      <div className="grid lg:grid-cols-2 gap-6">
        {/* Weekly study chart */}
        <Card className="border-border/50">
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle>Weekly Overview</CardTitle>
                <CardDescription>Study hours this week</CardDescription>
              </div>
              <Button variant="ghost" size="sm" onClick={() => onNavigate('analytics')} className="gap-1">
                View Details <ChevronRight className="w-4 h-4" />
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            <div className="h-[200px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={weeklyData}>
                  <XAxis
                    dataKey="day"
                    axisLine={false}
                    tickLine={false}
                    tick={{ fill: 'hsl(var(--muted-foreground))', fontSize: 12 }}
                  />
                  <YAxis
                    axisLine={false}
                    tickLine={false}
                    tick={{ fill: 'hsl(var(--muted-foreground))', fontSize: 12 }}
                    tickFormatter={(value) => `${value}h`}
                  />
                  <Tooltip
                    contentStyle={{
                      backgroundColor: 'hsl(var(--card))',
                      border: '1px solid hsl(var(--border))',
                      borderRadius: '8px',
                    }}
                    labelStyle={{ color: 'hsl(var(--foreground))' }}
                    formatter={(value: number) => [`${value} hours`, 'Study Time']}
                  />
                  <Bar
                    dataKey="hours"
                    fill="hsl(var(--primary))"
                    radius={[4, 4, 0, 0]}
                  />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* Subject strength */}
        <Card className="border-border/50">
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle>Subject Strength</CardTitle>
                <CardDescription>Based on your quiz performance</CardDescription>
              </div>
              <Button variant="ghost" size="sm" onClick={() => onNavigate('quiz')} className="gap-1">
                Take Quiz <ChevronRight className="w-4 h-4" />
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            {subjectStrength.length > 0 ? (
              <div className="space-y-4">
                {subjectStrength.slice(0, 4).map((subject) => (
                  <div key={subject.subject} className="space-y-2">
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium text-foreground">{subject.subject}</span>
                      <span className={`text-xs font-medium px-2 py-1 rounded-full ${subject.status === 'Strong'
                        ? 'bg-success/10 text-success'
                        : subject.status === 'Average'
                          ? 'bg-warning/10 text-warning'
                          : 'bg-destructive/10 text-destructive'
                        }`}>
                        {subject.accuracy}% - {subject.status}
                      </span>
                    </div>
                    <Progress
                      value={subject.accuracy}
                      className="h-2"
                    />
                  </div>
                ))}
              </div>
            ) : (
              <div className="flex flex-col items-center justify-center py-8 text-center">
                <TrendingUp className="w-12 h-12 text-muted-foreground mb-4" />
                <p className="text-muted-foreground">No quiz data yet</p>
                <p className="text-sm text-muted-foreground">Take quizzes to see your strengths</p>
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Smart Revision Reminders & Offline Toggle */}
      <div className="grid md:grid-cols-2 gap-6">
        <Card className="border-primary/20 bg-primary/5">
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <Bell className="w-5 h-5 text-primary" /> Smart Revision
              </CardTitle>
              <Button variant="ghost" size="sm" onClick={() => onNavigate('flashcards')}>
                Practice All <Sparkles className="w-3 h-3 ml-2" />
              </Button>
            </div>
            <CardDescription>Topics due for spaced repetition review</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {revisionReminders.length > 0 ? revisionReminders.map(rem => (
              <div key={rem.id} className="p-4 rounded-xl bg-card border flex items-center justify-between group hover:border-primary transition-all">
                <div className="flex items-center gap-4">
                  <div className="w-10 h-10 rounded-lg bg-orange-100 flex items-center justify-center text-orange-600">
                    <History className="w-5 h-5" />
                  </div>
                  <div>
                    <p className="font-bold text-sm">Revise: {rem.topicName}</p>
                    <p className="text-[10px] text-muted-foreground uppercase font-black">Studied 3 days ago</p>
                  </div>
                </div>
                <Button size="sm" variant="outline" className="opacity-0 group-hover:opacity-100 transition-opacity">Revise Now</Button>
              </div>
            )) : (
              <p className="text-sm text-muted-foreground italic text-center py-4">All caught up! No topics due for revision.</p>
            )}
          </CardContent>
        </Card>

        <Card className={cn("transition-all border-2", offlineMode ? "bg-slate-900 border-slate-700 text-white" : "bg-muted/50 border-dashed border-muted-foreground/30")}>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Download className="w-5 h-5" /> Offline Study Mode
            </CardTitle>
            <CardDescription className={offlineMode ? "text-slate-400" : ""}>Study without internet connectivity</CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="flex items-center justify-between">
              <p className="text-sm font-medium">Download progress</p>
              <span className="text-xs font-bold">12 / 12 Topics</span>
            </div>
            <Progress value={100} className={cn("h-1.5", offlineMode ? "bg-slate-800" : "bg-muted")} />
            <Button
              className={cn("w-full h-12 font-bold", offlineMode ? "bg-emerald-600 hover:bg-emerald-700" : "bg-primary")}
              onClick={toggleOfflineMode}
            >
              {offlineMode ? "Offline Mode Enabled" : "Go Offline Now"}
            </Button>
          </CardContent>
        </Card>
      </div>

      {/* Quick actions */}
      <Card className="border-border/50">
        <CardHeader>
          <CardTitle>Advanced Study Toolkit</CardTitle>
          <CardDescription>Specialized tools to boost your productivity</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <Button
              variant="outline"
              className="h-auto py-6 flex flex-col gap-3 group border-2 hover:border-primary transition-all text-center"
              onClick={() => onNavigate('solver')}
            >
              <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary group-hover:scale-110 transition-transform mx-auto">
                <Brain className="w-6 h-6" />
              </div>
              <span className="font-bold text-[10px] uppercase tracking-widest mt-2">Doubt Solver</span>
            </Button>
            <Button
              variant="outline"
              className="h-auto py-6 flex flex-col gap-3 group border-2 hover:border-primary transition-all text-center"
              onClick={() => onNavigate('flashcards')}
            >
              <div className="w-12 h-12 rounded-xl bg-orange-100 flex items-center justify-center text-orange-600 group-hover:scale-110 transition-transform mx-auto">
                <Layers className="w-6 h-6" />
              </div>
              <span className="font-bold text-[10px] uppercase tracking-widest mt-2">Flashcards</span>
            </Button>
            <Button
              variant="outline"
              className="h-auto py-6 flex flex-col gap-3 group border-2 hover:border-primary transition-all text-center"
              onClick={() => onNavigate('guidance')}
            >
              <div className="w-12 h-12 rounded-xl bg-emerald-100 flex items-center justify-center text-emerald-600 group-hover:scale-110 transition-transform mx-auto">
                <MapIcon className="w-6 h-6" />
              </div>
              <span className="font-bold text-[10px] uppercase tracking-widest mt-2">Guidance</span>
            </Button>
            <Button
              variant="outline"
              className="h-auto py-6 flex flex-col gap-3 group border-2 hover:border-primary transition-all text-center"
              onClick={() => onNavigate('resources')}
            >
              <div className="w-12 h-12 rounded-xl bg-blue-100 flex items-center justify-center text-blue-600 group-hover:scale-110 transition-transform mx-auto">
                <History className="w-6 h-6" />
              </div>
              <span className="font-bold text-[10px] uppercase tracking-widest mt-2">Resources</span>
            </Button>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mt-6 pt-4 border-t border-dashed">
            <Button variant="ghost" className="gap-2 h-8 text-[11px] font-bold uppercase tracking-wider" onClick={() => onNavigate('timer')}><Clock className="w-3 h-3" /> Timer</Button>
            <Button variant="ghost" className="gap-2 h-8 text-[11px] font-bold uppercase tracking-wider" onClick={() => onNavigate('quiz')}><BookOpen className="w-3 h-3" /> Quiz</Button>
            <Button variant="ghost" className="gap-2 h-8 text-[11px] font-bold uppercase tracking-wider" onClick={() => onNavigate('analytics')}><TrendingUp className="w-3 h-3" /> Reports</Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
