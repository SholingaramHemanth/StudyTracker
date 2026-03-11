"use client"

import { useState, useEffect, useCallback } from 'react'
import { useStudy } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import {
  Play,
  Pause,
  RotateCcw,
  Coffee,
  BookOpen,
  Clock,
  CheckCircle2,
  Shield,
  ShieldAlert,
  Lock,
  Flame
} from 'lucide-react'

type TimerMode = 'study' | 'break'
type TimerType = 'pomodoro' | 'custom'

const POMODORO_STUDY = 25 * 60 // 25 minutes
const POMODORO_BREAK = 5 * 60 // 5 minutes
const CUSTOM_TIMES = [15, 30, 45, 60, 90, 120] // in minutes

export function StudyTimerPage() {
  const { user, timer, startTimer, pauseTimer, resetTimer, setTimerConfig } = useStudy()
  const [sessionsCompleted, setSessionsCompleted] = useState(0)
  const [totalStudyTime, setTotalStudyTime] = useState(0)

  const { timeLeft, isRunning, mode, type: timerType, selectedSubject, customDuration: customTime } = timer

  const getInitialTime = () => {
    if (timerType === 'pomodoro') {
      return mode === 'study' ? POMODORO_STUDY : POMODORO_BREAK
    }
    return customTime * 60
  }

  const toggleTimer = () => {
    if (!selectedSubject && !isRunning) {
      return
    }
    if (isRunning) {
      pauseTimer()
    } else {
      startTimer()
    }
  }

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  const progress = ((getInitialTime() - timeLeft) / getInitialTime()) * 100

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Timer type selection */}
      <div className="flex flex-col sm:flex-row gap-4">
        <div className="flex gap-4 flex-1">
          <Button
            variant={timerType === 'pomodoro' ? 'default' : 'outline'}
            onClick={() => setTimerConfig({ type: 'pomodoro' })}
            className="flex-1"
          >
            <Coffee className="w-4 h-4 mr-2" />
            Pomodoro
          </Button>
          <Button
            variant={timerType === 'custom' ? 'default' : 'outline'}
            onClick={() => setTimerConfig({ type: 'custom' })}
            className="flex-1"
          >
            <Clock className="w-4 h-4 mr-2" />
            Custom
          </Button>
        </div>
        <Button
          variant={timer.focusMode ? 'destructive' : 'outline'}
          onClick={() => setTimerConfig({ focusMode: !timer.focusMode })}
          className={cn("flex-1 sm:flex-none sm:w-48", timer.focusMode && "animate-pulse")}
        >
          {timer.focusMode ? <ShieldAlert className="w-4 h-4 mr-2" /> : <Shield className="w-4 h-4 mr-2" />}
          {timer.focusMode ? 'Focus Mode ON' : 'Enable Focus Mode'}
        </Button>
      </div>

      {timer.focusMode && isRunning && (
        <div className="fixed inset-0 z-[100] bg-black/95 flex flex-col items-center justify-center p-8 text-white animate-in fade-in duration-500">
          <div className="absolute top-10 flex items-center gap-2 opacity-50">
            <Lock className="w-4 h-4" /> Distraction Free Environment Active
          </div>

          <div className="space-y-12 text-center w-full max-w-lg">
            <div className="space-y-4">
              <p className="text-xl font-medium tracking-widest text-primary uppercase">Deep Work Session</p>
              <h2 className="text-9xl font-black font-mono tracking-tighter">{formatTime(timeLeft)}</h2>
              <p className="text-2xl font-bold opacity-60">Focusing on {user?.subjects?.find(s => s.id === selectedSubject)?.name}</p>
            </div>

            <div className="grid gap-4 w-full">
              <Button size="lg" onClick={pauseTimer} className="h-16 text-lg font-bold bg-white text-black hover:bg-white/90">
                <Pause className="w-6 h-6 mr-3" /> Pause Momentarily
              </Button>
              <Button variant="ghost" className="text-white/40 hover:text-white" onClick={() => setTimerConfig({ focusMode: false })}>
                Exit Focus Mode
              </Button>
            </div>
          </div>

          <div className="absolute bottom-20 flex flex-col items-center gap-2">
            <Flame className="w-8 h-8 text-orange-500 animate-bounce" />
            <p className="text-xs font-bold uppercase tracking-widest opacity-30">Keep going, no notifications will bother you.</p>
          </div>
        </div>
      )}

      {/* Subject selection */}
      <Card className="border-border/50">
        <CardHeader>
          <CardTitle className="text-lg">Select Subject</CardTitle>
          <CardDescription>Choose what you will be studying</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
            {user?.subjects?.map((subject) => (
              <button
                key={subject.id}
                onClick={() => setTimerConfig({ subjectId: subject.id })}
                disabled={isRunning}
                className={cn(
                  "p-4 rounded-lg border-2 text-left transition-all",
                  selectedSubject === subject.id
                    ? "border-primary bg-primary/5"
                    : "border-border bg-card hover:border-primary/50",
                  isRunning && "opacity-50 cursor-not-allowed"
                )}
              >
                <span className="text-2xl mb-2 block">{subject.icon}</span>
                <span className="font-medium text-foreground text-sm">{subject.name}</span>
              </button>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Custom time selection */}
      {timerType === 'custom' && (
        <Card className="border-border/50">
          <CardHeader>
            <CardTitle className="text-lg">Study Duration</CardTitle>
            <CardDescription>Select how long you want to study</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-3 sm:grid-cols-6 gap-3">
              {CUSTOM_TIMES.map((time) => (
                <button
                  key={time}
                  onClick={() => setTimerConfig({ duration: time })}
                  disabled={isRunning}
                  className={cn(
                    "p-3 rounded-lg border-2 text-center transition-all",
                    customTime === time
                      ? "border-primary bg-primary/5 text-foreground"
                      : "border-border bg-card text-muted-foreground hover:border-primary/50",
                    isRunning && "opacity-50 cursor-not-allowed"
                  )}
                >
                  {time} min
                </button>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* Timer display */}
      <Card className="border-border/50">
        <CardContent className="pt-8 pb-8">
          <div className="text-center">
            {/* Mode indicator */}
            <div className={cn(
              "inline-flex items-center gap-2 px-4 py-2 rounded-full mb-6",
              mode === 'study' ? "bg-primary/10 text-primary" : "bg-accent/10 text-accent"
            )}>
              {mode === 'study' ? (
                <>
                  <BookOpen className="w-4 h-4" />
                  <span className="font-medium">Study Time</span>
                </>
              ) : (
                <>
                  <Coffee className="w-4 h-4" />
                  <span className="font-medium">Break Time</span>
                </>
              )}
            </div>

            {/* Timer circle */}
            <div className="relative w-64 h-64 mx-auto mb-8">
              <svg className="w-full h-full transform -rotate-90">
                <circle
                  cx="128"
                  cy="128"
                  r="120"
                  stroke="hsl(var(--muted))"
                  strokeWidth="8"
                  fill="none"
                />
                <circle
                  cx="128"
                  cy="128"
                  r="120"
                  stroke={mode === 'study' ? "hsl(var(--primary))" : "hsl(var(--accent))"}
                  strokeWidth="8"
                  fill="none"
                  strokeLinecap="round"
                  strokeDasharray={2 * Math.PI * 120}
                  strokeDashoffset={2 * Math.PI * 120 * (1 - progress / 100)}
                  className="transition-all duration-1000"
                />
              </svg>
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <span className="text-5xl font-bold text-foreground font-mono">
                  {formatTime(timeLeft)}
                </span>
                <span className="text-sm text-muted-foreground mt-2">
                  {selectedSubject
                    ? user?.subjects?.find(s => s.id === selectedSubject)?.name
                    : 'Select a subject'}
                </span>
              </div>
            </div>

            {/* Controls */}
            <div className="flex items-center justify-center gap-4">
              <Button
                size="lg"
                variant="outline"
                onClick={resetTimer}
                disabled={!isRunning && timeLeft === getInitialTime()}
              >
                <RotateCcw className="w-5 h-5" />
              </Button>
              <Button
                size="lg"
                onClick={toggleTimer}
                disabled={!selectedSubject}
                className="w-32"
              >
                {isRunning ? (
                  <>
                    <Pause className="w-5 h-5 mr-2" /> Pause
                  </>
                ) : (
                  <>
                    <Play className="w-5 h-5 mr-2" /> Start
                  </>
                )}
              </Button>
            </div>

            {!selectedSubject && !isRunning && (
              <p className="text-sm text-muted-foreground mt-4">
                Please select a subject to start the timer
              </p>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Session stats */}
      <div className="grid grid-cols-2 gap-4">
        <Card className="border-border/50">
          <CardContent className="pt-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center">
                <CheckCircle2 className="w-6 h-6 text-primary" />
              </div>
              <div>
                <p className="text-2xl font-bold text-foreground">{sessionsCompleted}</p>
                <p className="text-sm text-muted-foreground">Sessions Today</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card className="border-border/50">
          <CardContent className="pt-6">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-xl bg-accent/10 flex items-center justify-center">
                <Clock className="w-6 h-6 text-accent" />
              </div>
              <div>
                <p className="text-2xl font-bold text-foreground">{totalStudyTime} min</p>
                <p className="text-sm text-muted-foreground">Total Study Time</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
