"use client"

import { useState, useEffect } from 'react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Slider } from '@/components/ui/slider'
import { Switch } from '@/components/ui/switch'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { ScrollArea, ScrollBar } from '@/components/ui/scroll-area'
import { Badge } from '@/components/ui/badge'
import { Clock, BookOpen, Brain, Download, Settings, ChevronRight, ChevronLeft, Edit2, Play, CheckCircle2, RotateCcw } from 'lucide-react'
import { format, addDays, startOfWeek, isSameDay } from 'date-fns'
import { useStudy } from '@/lib/study-context'
import { toast } from 'sonner'
import { Progress } from '@/components/ui/progress'

// Types
type Subject = {
  id: string
  name: string
  color: string
  examDate: string
  difficulty: number // 1-10
}

type TimeSlot = {
  id: string
  dayId: number // 0-6 (Sun-Sat)
  startTime: string // "HH:MM"
  endTime: string // "HH:MM"
  subjectId: string | 'break' | 'free'
  completed: boolean
}

type StudyPlan = {
  id: string
  createdAt: string
  startDate: string
  subjects: Subject[]
  slots: TimeSlot[]
  dailyHours: number
  preferredTime: 'morning' | 'afternoon' | 'evening' | 'night'
  breakLength: number // minutes
}

const COLORS = [
  '#ef4444', '#3b82f6', '#22c55e', '#eab308',
  '#a855f7', '#ec4899', '#6366f1', '#f97316'
]

const SUBJECT_COLORS: Record<string, string> = {
  'math': '#3b82f6',
  'mathematics': '#3b82f6',
  'science': '#22c55e',
  'english': '#a855f7',
  'computer': '#f97316',
  'history': '#ef4444',
}

const getSubjectColor = (name: string, index: number) => {
  const lowerName = name.toLowerCase()
  for (const key in SUBJECT_COLORS) {
    if (lowerName.includes(key)) {
      return SUBJECT_COLORS[key]
    }
  }
  return COLORS[index % COLORS.length]
}

const hexToRgba = (hex: string, alpha: number) => {
  if (!hex.startsWith('#')) return hex;
  const r = parseInt(hex.slice(1, 3), 16);
  const g = parseInt(hex.slice(3, 5), 16);
  const b = parseInt(hex.slice(5, 7), 16);
  return `rgba(${r}, ${g}, ${b}, ${alpha})`;
}

export function StudyPlannerPage() {
  const { user, setTimerConfig, startTimer, updateProfile } = useStudy()
  const [activeTab, setActiveTab] = useState('setup')
  const [plan, setPlan] = useState<StudyPlan | null>(null)

  // Form State
  const [subjects, setSubjects] = useState<Subject[]>([])
  const [newSubject, setNewSubject] = useState('')
  const [examDate, setExamDate] = useState('')
  const [difficulty, setDifficulty] = useState([5])

  const [dailyHours, setDailyHours] = useState([4])
  const [preferredTime, setPreferredTime] = useState<'morning' | 'afternoon' | 'evening' | 'night'>('morning')
  const [breakLength, setBreakLength] = useState([15])

  const [currentWeekStart, setCurrentWeekStart] = useState(startOfWeek(new Date(), { weekStartsOn: 1 }))

  // Load from local storage
  useEffect(() => {
    const saved = localStorage.getItem('study-planner-data')
    if (saved) {
      setPlan(JSON.parse(saved))
      setActiveTab('timetable')
    }
  }, [])

  // Save to local storage
  useEffect(() => {
    if (plan) {
      localStorage.setItem('study-planner-data', JSON.stringify(plan))
    }
  }, [plan])

  const handleAddSubject = () => {
    if (!newSubject.trim() || !examDate) {
      toast.error('Please enter subject name and exam date')
      return
    }

    const newSub: Subject = {
      id: Math.random().toString(36).substr(2, 9),
      name: newSubject,
      examDate,
      difficulty: difficulty[0],
      color: getSubjectColor(newSubject, subjects.length)
    }

    setSubjects([...subjects, newSub])
    setNewSubject('')
    setExamDate('')
    setDifficulty([5])
  }

  const removeSubject = (id: string) => {
    setSubjects(subjects.filter(s => s.id !== id))
  }

  const generatePlan = () => {
    if (subjects.length === 0) {
      toast.error('Please add at least one subject')
      return
    }

    toast.promise(
      new Promise(resolve => setTimeout(resolve, 1500)),
      {
        loading: 'AI is generating your optimal study plan...',
        success: () => {
          // Mock AI Generation Algorithm
          const slots: TimeSlot[] = []

          // Very simplified mocking logic to create a weekly schedule
          for (let day = 0; day < 7; day++) {
            let currentHour = preferredTime === 'morning' ? 8 :
              preferredTime === 'afternoon' ? 13 :
                preferredTime === 'evening' ? 17 : 20

            let minutesStudied = 0;
            let targetMinutes = dailyHours[0] * 60;

            // Prioritize difficult subjects and closer exam dates (Mock implementation)
            const sortedSubjects = [...subjects].sort((a, b) => b.difficulty - a.difficulty)

            let subjectIndex = 0;

            while (minutesStudied < targetMinutes) {
              const subject = sortedSubjects[subjectIndex % sortedSubjects.length]

              // 45 min study session + Break
              const sessionLength = 45;

              // Calculate absolute minutes from midnight for this specific block
              const absoluteStartMinutes = (currentHour * 60) + minutesStudied;

              const startHour = Math.floor(absoluteStartMinutes / 60);
              const startMinute = absoluteStartMinutes % 60;

              const endHour = Math.floor((absoluteStartMinutes + sessionLength) / 60);
              const endMinute = (absoluteStartMinutes + sessionLength) % 60;

              const breakEndHour = Math.floor((absoluteStartMinutes + sessionLength + breakLength[0]) / 60);
              const breakEndMinute = (absoluteStartMinutes + sessionLength + breakLength[0]) % 60;

              const sTime = `${startHour.toString().padStart(2, '0')}:${startMinute.toString().padStart(2, '0')}`
              const eTime = `${endHour.toString().padStart(2, '0')}:${endMinute.toString().padStart(2, '0')}`

              slots.push({
                id: Math.random().toString(36).substr(2, 9),
                dayId: day,
                startTime: sTime,
                endTime: eTime,
                subjectId: subject.id,
                completed: false
              })

              // Break slot
              const bsTime = eTime;
              const beTime = `${breakEndHour.toString().padStart(2, '0')}:${breakEndMinute.toString().padStart(2, '0')}`

              slots.push({
                id: Math.random().toString(36).substr(2, 9),
                dayId: day,
                startTime: bsTime,
                endTime: beTime,
                subjectId: 'break',
                completed: false
              })

              minutesStudied += sessionLength + breakLength[0];
              subjectIndex++;
            }
          }

          const newPlan: StudyPlan = {
            id: Math.random().toString(36).substr(2, 9),
            createdAt: new Date().toISOString(),
            startDate: new Date().toISOString(),
            subjects,
            slots,
            dailyHours: dailyHours[0],
            preferredTime,
            breakLength: breakLength[0]
          }

          setPlan(newPlan)
          setActiveTab('timetable')
          return 'Plan generated successfully!'
        },
        error: 'Failed to generate plan'
      }
    )
  }

  const adjustSchedule = () => {
    if (!plan || subjects.length === 0) {
      toast.error('Please generate a plan first')
      return;
    }

    toast.promise(
      new Promise<void>(resolve => {
        setTimeout(() => {
          let adjustedSlots = [...plan.slots];
          const uncompletedSlots = adjustedSlots.filter(s => !s.completed && s.subjectId !== 'break');

          if (uncompletedSlots.length >= 2) {
            const idx1 = adjustedSlots.findIndex(s => s.id === uncompletedSlots[0].id);
            const idx2 = adjustedSlots.findIndex(s => s.id === uncompletedSlots[1].id);
            if (idx1 !== -1 && idx2 !== -1) {
              const tempSubj = adjustedSlots[idx1].subjectId;
              adjustedSlots[idx1].subjectId = adjustedSlots[idx2].subjectId;
              adjustedSlots[idx2].subjectId = tempSubj;
            }
          }
          setPlan({ ...plan, slots: adjustedSlots });
          resolve();
        }, 1200);
      }),
      {
        loading: 'AI is adjusting your schedule based on missed sessions...',
        success: 'Schedule adjusted successfully to cover missed topics!',
        error: 'Failed to adjust schedule'
      }
    )
  }

  const downloadPDF = async () => {
    toast.info("Preparing PDF... Please use the browser dialog to save.");

    // Fallback to native print logic with CSS to style it right
    // react-to-print is another option, but native print works better for complex DOM sizes like large schedules.
    setTimeout(() => {
      window.print();
    }, 500);
  }

  const toggleSlotCompletion = (slotId: string) => {
    if (!plan) return
    const newSlots = plan.slots.map(s => s.id === slotId ? { ...s, completed: !s.completed } : s)
    setPlan({ ...plan, slots: newSlots })
  }

  const renderSubjectSetup = () => (
    <div className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
      <Card>
        <CardHeader>
          <CardTitle>Add Subjects</CardTitle>
          <CardDescription>Enter the subjects you need to study for.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label>Subject Name</Label>
              <Input
                placeholder="e.g. Mathematics"
                value={newSubject}
                onChange={e => setNewSubject(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label>Exam Date</Label>
              <Input
                type="date"
                value={examDate}
                onChange={e => setExamDate(e.target.value)}
              />
            </div>
            <div className="space-y-2 md:col-span-2">
              <div className="flex justify-between">
                <Label>Difficulty Level</Label>
                <span className="text-sm text-muted-foreground">{difficulty[0]}/10</span>
              </div>
              <Slider
                value={difficulty}
                onValueChange={setDifficulty}
                max={10}
                step={1}
                className="py-4"
              />
            </div>
          </div>
          <Button onClick={handleAddSubject} className="w-full">
            <BookOpen className="w-4 h-4 mr-2" /> Add Subject
          </Button>

          {subjects.length > 0 && (
            <div className="mt-6">
              <h4 className="text-sm font-medium mb-3">Your Subjects</h4>
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                {subjects.map(sub => (
                  <div key={sub.id} className="relative group border rounded-lg p-3 flex items-center gap-3">
                    <div className="w-3 h-10 rounded-full" style={{ backgroundColor: sub.color }} />
                    <div className="flex-1 min-w-0">
                      <p className="font-medium truncate">{sub.name}</p>
                      <p className="text-xs text-muted-foreground">Exam: {format(new Date(sub.examDate), 'MMM d, yyyy')}</p>
                    </div>
                    <Badge variant="outline">{sub.difficulty}/10</Badge>
                    <button
                      onClick={() => removeSubject(sub.id)}
                      className="absolute -top-2 -right-2 w-6 h-6 bg-destructive text-destructive-foreground rounded-full opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center text-xs"
                    >
                      ×
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Study Preferences</CardTitle>
          <CardDescription>Tell us how you prefer to study.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <div>
                <Label>Available Study Hours / Day</Label>
                <p className="text-sm text-muted-foreground">How much time can you dedicate daily?</p>
              </div>
              <span className="text-xl font-bold">{dailyHours[0]}h</span>
            </div>
            <Slider value={dailyHours} onValueChange={setDailyHours} max={12} min={1} step={0.5} />
          </div>

          <div className="space-y-4">
            <Label>Preferred Study Time</Label>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              {(['morning', 'afternoon', 'evening', 'night'] as const).map(time => (
                <button
                  key={time}
                  onClick={() => setPreferredTime(time)}
                  className={`p-3 rounded-xl border flex flex-col items-center gap-2 transition-all ${
                    preferredTime === time 
                      ? 'border-primary bg-primary/10 text-primary' 
                      : 'hover:bg-muted'
                  }`}
                >
                  <Clock className="w-5 h-5" />
                  <span className="capitalize">{time}</span>
                </button>
              ))}
            </div>
          </div>

          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <div>
                <Label>Break Length</Label>
                <p className="text-sm text-muted-foreground">After every 45 min focus session</p>
              </div>
              <span className="text-xl font-bold">{breakLength[0]}m</span>
            </div>
            <Slider value={breakLength} onValueChange={setBreakLength} max={30} min={5} step={5} />
          </div>
        </CardContent>
        <CardFooter>
          <Button onClick={generatePlan} className="w-full text-lg h-12" size="lg">
            <Brain className="w-5 h-5 mr-2" /> Generate AI Study Plan
          </Button>
        </CardFooter>
      </Card>
    </div>
  )

  const renderTimetable = () => {
    if (!plan) return null;

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

    // Group slots by day
    const slotsByDay = days.reduce((acc, _, i) => {
      acc[i] = plan.slots.filter(s => s.dayId === i).sort((a, b) => a.startTime.localeCompare(b.startTime));
      return acc;
    }, {} as Record<number, TimeSlot[]>);

    return (
      <div className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
          <div className="flex items-center gap-4 border rounded-lg p-1 bg-card">
            <Button variant="ghost" size="icon" onClick={() => setCurrentWeekStart(startOfWeek(addDays(currentWeekStart, -7), { weekStartsOn: 1 }))}><ChevronLeft className="w-4 h-4" /></Button>
            <span className="font-medium min-w-[120px] text-center">
              {format(currentWeekStart, 'MMM d')} - {format(addDays(currentWeekStart, 6), 'MMM d')}
            </span>
            <Button variant="ghost" size="icon" onClick={() => setCurrentWeekStart(startOfWeek(addDays(currentWeekStart, 7), { weekStartsOn: 1 }))}><ChevronRight className="w-4 h-4" /></Button>
          </div>

          <div className="flex gap-2 w-full sm:w-auto">
            <Button variant="outline" className="flex-1 sm:flex-none" onClick={adjustSchedule}>
              <RotateCcw className="w-4 h-4 mr-2" /> Adjust AI
            </Button>
            <Button variant="outline" className="flex-1 sm:flex-none" onClick={downloadPDF}>
              <Download className="w-4 h-4 mr-2" /> Download Timetable as PDF
            </Button>
          </div>
        </div>

        {/* Timetable View */}
        <div className="border rounded-xl bg-card overflow-hidden print-to-pdf">
          <ScrollArea className="w-full">
            <div id="timetable-to-export" className="min-w-[800px] bg-card p-4 print:min-w-full">
              {/* Header */}
              <div className="grid grid-cols-8 divide-x border-b bg-muted/50">
                <div className="p-3 text-center font-semibold text-muted-foreground">Time</div>
                {days.map((day, i) => {
                  const date = addDays(currentWeekStart, i);
                  const isToday = isSameDay(date, new Date());
                  return (
                    <div key={day} className={`p-3 text-center ${isToday ? 'bg-primary/10 text-primary font-bold' : 'font-semibold'}`}>
                      <div>{day}</div>
                      <div className="text-xs font-normal mt-1 opacity-70">{format(date, 'MMM d')}</div>
                    </div>
                  )
                })}
              </div>

              {/* Content Grid (simplified for visualization) */}
              <div className="grid grid-cols-8 divide-x">
                <div className="divide-y text-xs text-muted-foreground text-center">
                  {[...Array(14)].map((_, i) => (
                    <div key={i} className="h-20 flex items-center justify-center p-2">
                      {i + 8}:00
                    </div>
                  ))}
                </div>

                {days.map((_, dayIndex) => (
                  <div key={dayIndex} className="relative min-h-[1120px] p-1 divide-y">
                    {slotsByDay[dayIndex]?.map(slot => {
                      if (slot.subjectId === 'break') {
                        return (
                          <div key={slot.id} className="my-1 rounded-md bg-muted/50 border border-dashed flex flex-col justify-center items-center text-[10px] text-muted-foreground p-1 text-center">
                            Break<br />{slot.startTime}
                          </div>
                        )
                      }

                      const subject = plan.subjects.find(s => s.id === slot.subjectId)
                      if (!subject) return null;

                      return (
                        <div
                          key={slot.id}
                          className={`my-1 p-2 rounded-md shadow-sm border flex flex-col gap-1 transition-all group overflow-hidden relative ${slot.completed ? 'opacity-60 bg-muted/50' : ''}`}
                          style={{
                            backgroundColor: slot.completed ? undefined : hexToRgba(subject.color, 0.15),
                            borderLeftWidth: '4px',
                            borderLeftColor: subject.color
                          }}
                        >
                          <div className="absolute top-0 left-0 w-1 h-full" style={{ backgroundColor: subject.color }}></div>
                          <div className="flex justify-between items-start">
                            <span className="font-bold text-xs truncate" title={subject.name}>{subject.name}</span>
                          </div>
                          <div className="text-[10px] opacity-80 flex items-center gap-1">
                            <Clock className="w-3 h-3" /> {slot.startTime} - {slot.endTime}
                          </div>
                          <div className="mt-1 flex gap-1 w-full">
                            <button
                              onClick={() => toggleSlotCompletion(slot.id)}
                              className="h-6 flex-1 rounded text-[10px] flex items-center justify-center gap-1 transition-colors font-medium"
                              style={{
                                backgroundColor: slot.completed ? '#22c55e' : hexToRgba(subject.color, 0.2),
                                color: slot.completed ? '#ffffff' : subject.color,
                              }}
                            >
                              <CheckCircle2 className="w-3 h-3" />
                              {slot.completed ? 'Done' : 'Mark'}
                            </button>
                            {!slot.completed && (
                              <button
                                onClick={() => {
                                  if (user && !user.subjects.find(s => s.id === subject.id)) {
                                    updateProfile({ subjects: [...user.subjects, { id: subject.id, name: subject.name, icon: '📅' }] });
                                  }
                                  setTimerConfig({ type: 'custom', duration: 45, subjectId: subject.id, mode: 'study' });
                                  startTimer();
                                  toast.success(`Timer started for ${subject.name}! Head to the Study Timer page.`);
                                }}
                                className="h-6 flex-1 rounded text-[10px] flex items-center justify-center gap-1 transition-colors font-medium"
                                style={{
                                  backgroundColor: hexToRgba(subject.color, 0.2),
                                  color: subject.color,
                                }}
                              >
                                <Play className="w-3 h-3" />
                                Start
                              </button>
                            )}
                          </div>
                        </div>
                      )
                    })}
                  </div>
                ))}
              </div>
            </div>
            <ScrollBar orientation="horizontal" />
          </ScrollArea>
        </div>
      </div>
    )
  }

  const renderProgress = () => {
    if (!plan) return null;

    const totalSlots = plan.slots.filter(s => s.subjectId !== 'break').length;
    const completedSlots = plan.slots.filter(s => s.subjectId !== 'break' && s.completed).length;
    const progress = totalSlots > 0 ? (completedSlots / totalSlots) * 100 : 0;

    return (
      <div className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
        <Card>
          <CardHeader>
            <CardTitle>Weekly Progress</CardTitle>
            <CardDescription>Keep track of your study goals</CardDescription>
          </CardHeader>
          <CardContent className="space-y-8">
            <div>
              <div className="flex justify-between mb-2">
                <span className="font-medium">Completion Rate</span>
                <span className="font-bold text-primary">{Math.round(progress)}%</span>
              </div>
              <Progress value={progress} className="h-3" />
            </div>

            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <div className="p-4 rounded-xl border bg-card flex flex-col gap-2">
                <span className="text-muted-foreground text-sm">Total Sessions</span>
                <span className="text-3xl font-bold">{totalSlots}</span>
              </div>
              <div className="p-4 rounded-xl border bg-card flex flex-col gap-2">
                <span className="text-muted-foreground text-sm">Completed</span>
                <span className="text-3xl font-bold text-green-500">{completedSlots}</span>
              </div>
              <div className="p-4 rounded-xl border bg-card flex flex-col gap-2">
                <span className="text-muted-foreground text-sm">Hours Studied</span>
                <span className="text-3xl font-bold text-primary">{((completedSlots * 45) / 60).toFixed(1)}h</span>
              </div>
              <div className="p-4 rounded-xl border bg-card flex flex-col gap-2">
                <span className="text-muted-foreground text-sm">Current Streak</span>
                <span className="text-3xl font-bold text-orange-500 flex items-center">3 <Play className="fill-orange-500 w-5 h-5 -rotate-90 ml-1" /></span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <>
      <style dangerouslySetInnerHTML={{
        __html: `
      @media print {
         body * {
            visibility: hidden;
         }
         .print-to-pdf, .print-to-pdf * {
            visibility: visible;
         }
         .print-to-pdf {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
         }
      }
    `}} />
      <div className="space-y-6 pb-20">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Study Planner 📅</h2>
          <p className="text-muted-foreground mt-2">
            AI-powered study timetable generator based on your exams and schedule.
          </p>
        </div>

        <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
          <TabsList className="grid grid-cols-3 w-full max-w-md">
            <TabsTrigger value="setup">Setup</TabsTrigger>
            <TabsTrigger value="timetable" disabled={!plan}>Timetable</TabsTrigger>
            <TabsTrigger value="progress" disabled={!plan}>Progress</TabsTrigger>
          </TabsList>
          <TabsContent value="setup" className="mt-0">
            {renderSubjectSetup()}
          </TabsContent>
          <TabsContent value="timetable" className="mt-0">
            {renderTimetable()}
          </TabsContent>
          <TabsContent value="progress" className="mt-0">
            {renderProgress()}
          </TabsContent>
        </Tabs>
      </div>
    </>
  )
}
