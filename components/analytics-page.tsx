"use client"

import { useStudy } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { cn } from '@/lib/utils'
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  ResponsiveContainer,
  Tooltip,
  LineChart,
  Line,
  PieChart,
  Pie,
  Cell
} from 'recharts'
import {
  TrendingUp,
  TrendingDown,
  Clock,
  Target,
  BookOpen,
  Flame,
  Award,
  ShieldAlert,
  Brain,
  Zap
} from 'lucide-react'

export function AnalyticsPage() {
  const { user, studySessions, quizResults, getWeeklyStudyData, getSubjectStrength } = useStudy()

  const weeklyData = getWeeklyStudyData()
  const subjectStrength = getSubjectStrength()

  // Calculate total study time
  const totalStudyTime = studySessions.reduce((acc, s) => acc + s.duration, 0)
  const totalHours = Math.floor(totalStudyTime / 60)
  const totalMins = totalStudyTime % 60

  // Calculate average daily study time
  const uniqueDays = new Set(studySessions.map(s => s.date)).size || 1
  const avgDailyTime = Math.round(totalStudyTime / uniqueDays)

  // Calculate quiz stats
  const totalQuizzes = quizResults.length
  const totalQuestions = quizResults.reduce((acc, r) => acc + r.totalQuestions, 0)
  const totalCorrect = quizResults.reduce((acc, r) => acc + r.correctAnswers, 0)
  const overallAccuracy = totalQuestions > 0 ? Math.round((totalCorrect / totalQuestions) * 100) : 0

  // Study time by subject
  const studyBySubject = user?.subjects?.map(subject => {
    const subjectTime = studySessions
      .filter(s => s.subjectId === subject.id)
      .reduce((acc, s) => acc + s.duration, 0)
    return {
      name: subject.name,
      time: Math.round(subjectTime / 60 * 10) / 10,
      icon: subject.icon
    }
  }).filter(s => s.time > 0) || []

  // Colors for pie chart
  const COLORS = ['hsl(var(--chart-1))', 'hsl(var(--chart-2))', 'hsl(var(--chart-3))', 'hsl(var(--chart-4))', 'hsl(var(--chart-5))']

  // Weekly trend (compare to last week)
  const thisWeekTotal = weeklyData.reduce((acc, d) => acc + d.hours, 0)
  const weeklyTrend = thisWeekTotal > 0 ? 'up' : 'neutral'

  const stats = [
    {
      label: 'Total Study Time',
      value: `${totalHours}h ${totalMins}m`,
      icon: Clock,
      color: 'text-chart-1',
      bgColor: 'bg-chart-1/10',
    },
    {
      label: 'Daily Average',
      value: `${Math.floor(avgDailyTime / 60)}h ${avgDailyTime % 60}m`,
      icon: Target,
      color: 'text-chart-2',
      bgColor: 'bg-chart-2/10',
    },
    {
      label: 'Quiz Accuracy',
      value: `${overallAccuracy}%`,
      icon: Award,
      color: 'text-chart-3',
      bgColor: 'bg-chart-3/10',
    },
    {
      label: 'Current Streak',
      value: `${user?.streak || 0} days`,
      icon: Flame,
      color: 'text-chart-4',
      bgColor: 'bg-chart-4/10',
    },
  ]

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div>
        <h2 className="text-2xl font-bold text-foreground mb-2">Analytics</h2>
        <p className="text-muted-foreground">Track your study progress and performance</p>
      </div>

      {/* Stats overview */}
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

      <div className="grid lg:grid-cols-2 gap-6">
        {/* Weekly study chart */}
        <Card className="border-border/50">
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle>Weekly Study Hours</CardTitle>
                <CardDescription>Your study time this week</CardDescription>
              </div>
              <div className={`flex items-center gap-1 text-sm ${weeklyTrend === 'up' ? 'text-success' : 'text-muted-foreground'
                }`}>
                {weeklyTrend === 'up' ? (
                  <>
                    <TrendingUp className="w-4 h-4" />
                    <span>{thisWeekTotal.toFixed(1)}h total</span>
                  </>
                ) : (
                  <>
                    <TrendingDown className="w-4 h-4" />
                    <span>No data yet</span>
                  </>
                )}
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <div className="h-[250px]">
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

        {/* Quiz performance trend */}
        <Card className="border-border/50">
          <CardHeader>
            <CardTitle>Quiz Performance</CardTitle>
            <CardDescription>Your accuracy over recent quizzes</CardDescription>
          </CardHeader>
          <CardContent>
            {quizResults.length > 0 ? (
              <div className="h-[250px]">
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={quizResults.slice(-7).map((r, i) => ({
                    quiz: `Quiz ${i + 1}`,
                    accuracy: Math.round((r.correctAnswers / r.totalQuestions) * 100)
                  }))}>
                    <XAxis
                      dataKey="quiz"
                      axisLine={false}
                      tickLine={false}
                      tick={{ fill: 'hsl(var(--muted-foreground))', fontSize: 12 }}
                    />
                    <YAxis
                      axisLine={false}
                      tickLine={false}
                      tick={{ fill: 'hsl(var(--muted-foreground))', fontSize: 12 }}
                      tickFormatter={(value) => `${value}%`}
                      domain={[0, 100]}
                    />
                    <Tooltip
                      contentStyle={{
                        backgroundColor: 'hsl(var(--card))',
                        border: '1px solid hsl(var(--border))',
                        borderRadius: '8px',
                      }}
                      labelStyle={{ color: 'hsl(var(--foreground))' }}
                      formatter={(value: number) => [`${value}%`, 'Accuracy']}
                    />
                    <Line
                      type="monotone"
                      dataKey="accuracy"
                      stroke="hsl(var(--accent))"
                      strokeWidth={2}
                      dot={{ fill: 'hsl(var(--accent))', strokeWidth: 2 }}
                    />
                  </LineChart>
                </ResponsiveContainer>
              </div>
            ) : (
              <div className="h-[250px] flex items-center justify-center">
                <div className="text-center">
                  <BookOpen className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                  <p className="text-muted-foreground">No quiz data yet</p>
                  <p className="text-sm text-muted-foreground">Take quizzes to see your performance</p>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      <div className="grid lg:grid-cols-2 gap-6">
        {/* Study time by subject */}
        <Card className="border-border/50">
          <CardHeader>
            <CardTitle>Time by Subject</CardTitle>
            <CardDescription>Distribution of your study time</CardDescription>
          </CardHeader>
          <CardContent>
            {studyBySubject.length > 0 ? (
              <div className="h-[250px]">
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={studyBySubject}
                      cx="50%"
                      cy="50%"
                      innerRadius={60}
                      outerRadius={100}
                      paddingAngle={5}
                      dataKey="time"
                      label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                      labelLine={false}
                    >
                      {studyBySubject.map((_, index) => (
                        <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                      ))}
                    </Pie>
                    <Tooltip
                      contentStyle={{
                        backgroundColor: 'hsl(var(--card))',
                        border: '1px solid hsl(var(--border))',
                        borderRadius: '8px',
                      }}
                      formatter={(value: number) => [`${value} hours`, 'Study Time']}
                    />
                  </PieChart>
                </ResponsiveContainer>
              </div>
            ) : (
              <div className="h-[250px] flex items-center justify-center">
                <div className="text-center">
                  <Clock className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                  <p className="text-muted-foreground">No study sessions yet</p>
                  <p className="text-sm text-muted-foreground">Start studying to see the distribution</p>
                </div>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Subject strength */}
        <Card className="border-border/50">
          <CardHeader>
            <CardTitle>Subject Strength Analysis</CardTitle>
            <CardDescription>Based on your quiz performance</CardDescription>
          </CardHeader>
          <CardContent>
            {subjectStrength.length > 0 ? (
              <div className="space-y-4">
                {subjectStrength.map((subject) => (
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
                    <Progress value={subject.accuracy} className="h-2" />
                  </div>
                ))}

                {/* Recommendations */}
                {subjectStrength.some(s => s.status === 'Weak') && (
                  <div className="mt-6 p-4 rounded-lg bg-muted">
                    <h4 className="font-medium text-foreground mb-2">Recommendations</h4>
                    <ul className="text-sm text-muted-foreground space-y-1">
                      {subjectStrength
                        .filter(s => s.status === 'Weak')
                        .map(s => (
                          <li key={s.subject}>
                            Focus more on <span className="text-foreground font-medium">{s.subject}</span> - currently at {s.accuracy}%
                          </li>
                        ))}
                    </ul>
                  </div>
                )}
              </div>
            ) : (
              <div className="h-[250px] flex items-center justify-center">
                <div className="text-center">
                  <Target className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                  <p className="text-muted-foreground">No quiz data yet</p>
                  <p className="text-sm text-muted-foreground">Take quizzes to analyze your strengths</p>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Personalized Weakness Report */}
      <Card className="border-2 border-primary/20 bg-primary/5 overflow-hidden">
        <CardHeader className="bg-primary text-primary-foreground">
          <div className="flex items-center justify-between">
            <div className="space-y-1">
              <CardTitle className="flex items-center gap-2">
                <ShieldAlert className="w-5 h-5" /> Personalized Weakness Report
              </CardTitle>
              <CardDescription className="text-primary-foreground/70 text-xs">AI-driven analysis of your performance gaps</CardDescription>
            </div>
            <Brain className="w-10 h-10 opacity-20" />
          </div>
        </CardHeader>
        <CardContent className="p-8">
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {subjectStrength.filter(s => s.status !== 'Strong').map((s) => (
              <div key={s.subject} className="p-6 rounded-2xl bg-card border shadow-sm space-y-4">
                <div className="flex items-center justify-between">
                  <h4 className="font-bold">{s.subject}</h4>
                  <span className={cn("px-2 py-1 rounded-md text-[10px] font-black uppercase tracking-widest", s.status === 'Weak' ? "bg-rose-500 text-white" : "bg-amber-500 text-white")}>
                    {s.status} PERFORMANCE
                  </span>
                </div>
                <div className="space-y-2">
                  <div className="flex justify-between text-xs font-bold text-muted-foreground">
                    <span>Conceptual Mastery</span>
                    <span>{s.accuracy}%</span>
                  </div>
                  <Progress value={s.accuracy} className={cn("h-1.5", s.status === 'Weak' ? "bg-rose-100" : "bg-amber-100")} />
                </div>
                <div className="pt-4 space-y-3">
                  <p className="text-xs font-bold uppercase tracking-widest text-primary flex items-center gap-2">
                    <Zap className="w-3 h-3" /> Improvement Action
                  </p>
                  <div className="p-3 rounded-lg bg-muted text-xs leading-relaxed italic">
                    {s.status === 'Weak'
                      ? `Focus on fundamental theory. Recommended study time: 45 minutes today.`
                      : `Review previous year questions. Recommended study time: 30 minutes today.`
                    }
                  </div>
                </div>
              </div>
            ))}
            {subjectStrength.filter(s => s.status !== 'Strong').length === 0 && (
              <div className="col-span-full py-12 text-center text-muted-foreground italic">
                All your current subjects show Strong performance. Great job!
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Quiz summary */}
      <Card className="border-border/50">
        <CardHeader>
          <CardTitle>Quiz Summary</CardTitle>
          <CardDescription>Overview of your quiz performance</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <div className="p-4 rounded-lg bg-muted text-center">
              <p className="text-3xl font-bold text-foreground">{totalQuizzes}</p>
              <p className="text-sm text-muted-foreground">Quizzes Taken</p>
            </div>
            <div className="p-4 rounded-lg bg-muted text-center">
              <p className="text-3xl font-bold text-foreground">{totalQuestions}</p>
              <p className="text-sm text-muted-foreground">Questions Answered</p>
            </div>
            <div className="p-4 rounded-lg bg-muted text-center">
              <p className="text-3xl font-bold text-foreground">{totalCorrect}</p>
              <p className="text-sm text-muted-foreground">Correct Answers</p>
            </div>
            <div className="p-4 rounded-lg bg-muted text-center">
              <p className="text-3xl font-bold text-foreground">{overallAccuracy}%</p>
              <p className="text-sm text-muted-foreground">Overall Accuracy</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
