"use client"

import React, { createContext, useContext, useState, useEffect, useCallback, ReactNode } from 'react'

export type EducationLevel = 'class-1-5' | 'class-6-10' | 'intermediate' | 'engineering' | 'other'
export type EngineeringBranch = 'CSE' | 'ECE' | 'Mechanical' | 'Civil' | 'EEE' | 'Chemical'
export type IntermediateYear = '1st Year' | '2nd Year'
export type IntermediateGroup = 'MPC' | 'BiPC' | 'CEC' | 'MEC'
export type RegionState = 'Andhra Pradesh' | 'Telangana' | 'Tamil Nadu' | 'North India' | 'Other'

export interface Subject {
  id: string
  name: string
  icon: string
}

export interface StudySession {
  id: string
  subjectId: string
  date: string
  duration: number // in minutes
  type: 'study' | 'pomodoro' | 'custom'
}

export interface QuizResult {
  id: string
  subjectId: string
  date: string
  totalQuestions: number
  correctAnswers: number
  timeTaken: number // in seconds
}

export interface UserProfile {
  id: string
  name: string
  email: string
  state?: RegionState
  educationLevel: EducationLevel
  class?: string
  branch?: EngineeringBranch
  semester?: number
  year?: IntermediateYear
  group?: IntermediateGroup
  subjects: Subject[]
  dailyGoal: number // in minutes
  streak: number
  lastStudyDate: string
}

export interface Flashcard {
  id: string
  subjectId: string
  front: string
  back: string
  lastReviewed: string
  nextReview: string
  easeFactor: number
  interval: number // in days
}

export interface CareerPath {
  id: string
  title: string
  skills: string[]
  description: string
  roadmap: { month: number; task: string }[]
}

export interface Roadmap {
  id: string
  goal: string
  steps: { month: string; target: string }[]
}

interface StudyContextType {
  user: UserProfile | null
  setUser: (user: UserProfile | null) => void
  studySessions: StudySession[]
  addStudySession: (session: Omit<StudySession, 'id'>) => void
  quizResults: QuizResult[]
  addQuizResult: (result: Omit<QuizResult, 'id'>) => void
  isAuthenticated: boolean
  login: (email: string, password: string) => Promise<boolean>
  signup: (name: string, email: string, password: string) => Promise<boolean>
  logout: () => void
  updateProfile: (updates: Partial<UserProfile>) => void
  getTodayStudyTime: () => number
  getWeeklyStudyData: () => { day: string; hours: number }[]
  getSubjectStrength: () => { subject: string; accuracy: number; status: 'Strong' | 'Average' | 'Weak' }[]
  // Advanced Features
  flashcards: Flashcard[]
  addFlashcard: (flashcard: Omit<Flashcard, 'id' | 'lastReviewed' | 'nextReview' | 'easeFactor' | 'interval'>) => void
  reviewFlashcard: (id: string, quality: number) => void
  offlineMode: boolean
  toggleOfflineMode: () => void
  downloadedTopics: string[]
  downloadTopic: (topicId: string) => void
  roadmaps: Roadmap[]
  generateRoadmap: (goal: string, steps?: { month: string; target: string }[]) => void
  deleteRoadmap: (id: string) => void
  revisionReminders: { id: string; topicName: string; date: string }[]
  // Timer state
  timer: {
    timeLeft: number
    isRunning: boolean
    mode: 'study' | 'break'
    type: 'pomodoro' | 'custom'
    selectedSubject: string | null
    customDuration: number
    focusMode: boolean
  }
  startTimer: () => void
  pauseTimer: () => void
  resetTimer: () => void
  setTimerConfig: (config: { type?: 'pomodoro' | 'custom'; mode?: 'study' | 'break'; duration?: number; subjectId?: string | null; focusMode?: boolean }) => void
}

const StudyContext = createContext<StudyContextType | undefined>(undefined)

const SUBJECTS_BY_LEVEL: Record<string, Subject[]> = {
  // We'll generate dynamic ones for class-1-5, class-6-10, intermediate based on region
  'engineering-CSE': [
    { id: 'os', name: 'Operating Systems', icon: '💻' },
    { id: 'cn', name: 'Computer Networks', icon: '🌐' },
    { id: 'cyber', name: 'Cybersecurity', icon: '🔒' },
    { id: 'dbms', name: 'DBMS', icon: '🗄️' },
    { id: 'dsa', name: 'Data Structures', icon: '📊' },
    { id: 'algo', name: 'Algorithms', icon: '🧮' },
  ],
  'engineering-ECE': [
    { id: 'signals', name: 'Signals & Systems', icon: '📡' },
    { id: 'digital', name: 'Digital Electronics', icon: '🔌' },
    { id: 'comm', name: 'Communication Systems', icon: '📶' },
    { id: 'micro', name: 'Microprocessors', icon: '🖥️' },
    { id: 'vlsi', name: 'VLSI Design', icon: '⚡' },
  ],
  'engineering-Mechanical': [
    { id: 'thermo', name: 'Thermodynamics', icon: '🔥' },
    { id: 'fluid', name: 'Fluid Mechanics', icon: '💧' },
    { id: 'som', name: 'Strength of Materials', icon: '🔩' },
    { id: 'machine', name: 'Machine Design', icon: '⚙️' },
    { id: 'manufacturing', name: 'Manufacturing', icon: '🏭' },
  ],
  'other': [
    { id: 'general', name: 'General Studies', icon: '📚' },
    { id: 'reasoning', name: 'Reasoning', icon: '🧠' },
    { id: 'aptitude', name: 'Aptitude', icon: '📊' },
  ],
}

// Helper to get subjects based on State and Level
export const getSubjectsForProfile = (state?: RegionState, level?: EducationLevel, branch?: string, group?: string): Subject[] => {
  if (level === 'engineering' && branch) {
    return SUBJECTS_BY_LEVEL[`engineering-${branch}`] || SUBJECTS_BY_LEVEL['other'];
  }
  if (level === 'other' || !level) {
    return SUBJECTS_BY_LEVEL['other'];
  }

  // Define subjects based on region for schools/inter
  if (state === 'Andhra Pradesh' || state === 'Telangana') {
    if (level === 'class-1-5') {
      return [
        { id: 'telugu', name: 'Telugu', icon: '📝' },
        { id: 'english', name: 'English', icon: '📖' },
        { id: 'math', name: 'Mathematics', icon: '📐' },
        { id: 'evs', name: 'Environmental Science', icon: '🌍' },
      ];
    }
    if (level === 'class-6-10') {
      return [
        { id: 'telugu', name: 'Telugu', icon: '📝' },
        { id: 'hindi', name: 'Hindi', icon: '📝' },
        { id: 'english', name: 'English', icon: '📖' },
        { id: 'math', name: 'Mathematics', icon: '📐' },
        { id: 'physics', name: 'Physical Science', icon: '⚡' },
        { id: 'biology', name: 'Biological Science', icon: '🧬' },
        { id: 'social', name: 'Social Studies', icon: '🌍' },
      ];
    }
    if (level === 'intermediate') {
      const isMpc = group === 'MPC';
      const isBipc = group === 'BiPC';
      
      const common = [
        { id: 'english', name: 'English', icon: '📖' },
        { id: 'sanskrit', name: 'Sanskrit/Telugu', icon: '📝' },
      ];
      
      if (isMpc) {
        return [
          { id: 'math1a', name: 'Maths 1A/2A', icon: '📐' },
          { id: 'math1b', name: 'Maths 1B/2B', icon: '📐' },
          { id: 'physics', name: 'Physics', icon: '⚡' },
          { id: 'chemistry', name: 'Chemistry', icon: '🧪' },
          ...common
        ];
      } else if (isBipc) {
        return [
          { id: 'botany', name: 'Botany', icon: '🌿' },
          { id: 'zoology', name: 'Zoology', icon: '🦓' },
          { id: 'physics', name: 'Physics', icon: '⚡' },
          { id: 'chemistry', name: 'Chemistry', icon: '🧪' },
          ...common
        ];
      } else {
        return [
          { id: 'commerce', name: 'Commerce', icon: '💼' },
          { id: 'economics', name: 'Economics', icon: '📊' },
          { id: 'civics', name: 'Civics', icon: '🏛️' },
          ...common
        ];
      }
    }
  }

  if (state === 'Tamil Nadu') {
    if (level === 'class-1-5' || level === 'class-6-10') {
      return [
        { id: 'tamil', name: 'Tamil', icon: '📝' },
        { id: 'english', name: 'English', icon: '📖' },
        { id: 'math', name: 'Mathematics', icon: '📐' },
        { id: 'science', name: 'Science', icon: '🔬' },
        { id: 'social', name: 'Social Science', icon: '🌍' },
      ];
    }
    if (level === 'intermediate') {
      return [
        { id: 'math', name: 'Mathematics', icon: '📐' },
        { id: 'physics', name: 'Physics', icon: '⚡' },
        { id: 'chemistry', name: 'Chemistry', icon: '🧪' },
        { id: 'biology', name: 'Biology', icon: '🧬' },
        { id: 'cscience', name: 'Computer Science', icon: '💻' },
        { id: 'tamil', name: 'Tamil', icon: '📝' },
        { id: 'english', name: 'English', icon: '📖' },
      ];
    }
  }

  // Default North India / Other State CBSE structure
  if (level === 'class-1-5') {
    return [
      { id: 'hindi', name: 'Hindi', icon: '📝' },
      { id: 'english', name: 'English', icon: '📖' },
      { id: 'math', name: 'Mathematics', icon: '📐' },
      { id: 'evs', name: 'EVS', icon: '🌍' },
    ];
  }
  if (level === 'class-6-10') {
    return [
      { id: 'hindi', name: 'Hindi', icon: '📝' },
      { id: 'english', name: 'English', icon: '📖' },
      { id: 'math', name: 'Mathematics', icon: '📐' },
      { id: 'science', name: 'Science', icon: '🔬' },
      { id: 'social', name: 'Social Science', icon: '🌍' },
    ];
  }
  if (level === 'intermediate') {
    return [
      { id: 'math', name: 'Mathematics', icon: '📐' },
      { id: 'physics', name: 'Physics', icon: '⚡' },
      { id: 'chemistry', name: 'Chemistry', icon: '🧪' },
      { id: 'biology', name: 'Biology', icon: '🧬' },
      { id: 'english', name: 'English Core', icon: '📖' },
    ];
  }

  return SUBJECTS_BY_LEVEL['other'];
}

export function StudyProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<UserProfile | null>(null)
  const [studySessions, setStudySessions] = useState<StudySession[]>([])
  const [quizResults, setQuizResults] = useState<QuizResult[]>([])
  const [isAuthenticated, setIsAuthenticated] = useState(false)

  // Advanced Features State
  const [flashcards, setFlashcards] = useState<Flashcard[]>([])
  const [offlineMode, setOfflineMode] = useState(false)
  const [downloadedTopics, setDownloadedTopics] = useState<string[]>([])
  const [roadmaps, setRoadmaps] = useState<Roadmap[]>([])
  const [revisionReminders, setRevisionReminders] = useState<{ id: string; topicName: string; date: string }[]>([])

  // Timer state
  const [timerType, setTimerType] = useState<'pomodoro' | 'custom'>('pomodoro')
  const [timerMode, setTimerMode] = useState<'study' | 'break'>('study')
  const [timerSubject, setTimerSubject] = useState<string | null>(null)
  const [customDuration, setCustomDuration] = useState(30)
  const [timeLeft, setTimeLeft] = useState(25 * 60)
  const [isRunning, setIsRunning] = useState(false)
  const [focusMode, setFocusMode] = useState(false)

  const loadUserData = useCallback((email: string) => {
    const savedSessions = localStorage.getItem(`study-sessions-${email}`)
    const savedResults = localStorage.getItem(`quiz-results-${email}`)
    const savedFlashcards = localStorage.getItem(`study-flashcards-${email}`)
    const savedRoadmaps = localStorage.getItem(`study-roadmaps-${email}`)
    const savedDownloads = localStorage.getItem(`study-downloads-${email}`)

    setStudySessions(savedSessions ? JSON.parse(savedSessions) : [])
    setQuizResults(savedResults ? JSON.parse(savedResults) : [])
    setFlashcards(savedFlashcards ? JSON.parse(savedFlashcards) : [])
    setRoadmaps(savedRoadmaps ? JSON.parse(savedRoadmaps) : [])
    setDownloadedTopics(savedDownloads ? JSON.parse(savedDownloads) : [])
  }, [])

  useEffect(() => {
    // Load from localStorage on mount
    const savedUser = localStorage.getItem('study-user')

    if (savedUser) {
      const parsedUser = JSON.parse(savedUser)
      setUser(parsedUser)
      setIsAuthenticated(true)
      loadUserData(parsedUser.email)
    }
  }, [loadUserData])

  useEffect(() => {
    if (user && user.subjects && user.subjects.length > 0) {
      setRevisionReminders([
        { id: '1', topicName: user.subjects[0].name + ' Basics', date: new Date().toISOString() }
      ])
    } else {
      setRevisionReminders([])
    }
  }, [user])

  useEffect(() => {
    if (user) {
      localStorage.setItem('study-user', JSON.stringify(user))
      localStorage.setItem(`study-sessions-${user.email}`, JSON.stringify(studySessions))
      localStorage.setItem(`quiz-results-${user.email}`, JSON.stringify(quizResults))
      localStorage.setItem(`study-flashcards-${user.email}`, JSON.stringify(flashcards))
      localStorage.setItem(`study-roadmaps-${user.email}`, JSON.stringify(roadmaps))
      localStorage.setItem(`study-downloads-${user.email}`, JSON.stringify(downloadedTopics))
    }
  }, [user, studySessions, quizResults, flashcards, roadmaps, downloadedTopics])

  const login = async (email: string, password: string): Promise<boolean> => {
    // Simulate login - in production, this would call an API
    const savedUsers = localStorage.getItem('registered-users')
    if (savedUsers) {
      const users = JSON.parse(savedUsers)
      const foundUser = users.find((u: { email: string; password: string }) =>
        u.email === email && u.password === password
      )
      if (foundUser) {
        const savedProfile = localStorage.getItem(`profile-${email}`)
        if (savedProfile) {
          setUser(JSON.parse(savedProfile))
        } else {
          setUser({
            id: foundUser.id,
            name: foundUser.name,
            email: foundUser.email,
            educationLevel: 'class-6-10',
            subjects: [],
            dailyGoal: 120,
            streak: 0,
            lastStudyDate: '',
          })
        }
        loadUserData(email)
        setIsAuthenticated(true)
        return true
      }
    }
    return false
  }

  const signup = async (name: string, email: string, password: string): Promise<boolean> => {
    // Simulate signup - in production, this would call an API
    const savedUsers = localStorage.getItem('registered-users')
    const users = savedUsers ? JSON.parse(savedUsers) : []

    if (users.find((u: { email: string }) => u.email === email)) {
      return false // Email already exists
    }

    const newUser = {
      id: crypto.randomUUID(),
      name,
      email,
      password,
    }

    users.push(newUser)
    localStorage.setItem('registered-users', JSON.stringify(users))

    const newProfile: UserProfile = {
      id: newUser.id,
      name,
      email,
      educationLevel: 'class-6-10',
      subjects: [],
      dailyGoal: 120,
      streak: 0,
      lastStudyDate: '',
    }

    setUser(newProfile)
    loadUserData(email)
    setIsAuthenticated(true)
    return true
  }

  const logout = () => {
    setUser(null)
    setIsAuthenticated(false)
    localStorage.removeItem('study-user')
    setStudySessions([])
    setQuizResults([])
    setFlashcards([])
    setRoadmaps([])
    setDownloadedTopics([])
  }

  const updateProfile = (updates: Partial<UserProfile>) => {
    if (user) {
      const updatedUser = { ...user, ...updates }

      // Update subjects based on education level, branch, and state
      if (updates.educationLevel || updates.branch || updates.state || updates.group) {
        const level = updates.educationLevel || user.educationLevel
        const branch = updates.branch || user.branch
        const state = updates.state || user.state
        const group = updates.group || user.group

        updatedUser.subjects = getSubjectsForProfile(state, level, branch, group)
      }

      setUser(updatedUser)
      localStorage.setItem(`profile-${user.email}`, JSON.stringify(updatedUser))
    }
  }

  const addStudySession = (session: Omit<StudySession, 'id'>) => {
    const newSession = { ...session, id: crypto.randomUUID() }
    setStudySessions(prev => [...prev, newSession])

    // Update streak
    if (user) {
      const today = new Date().toISOString().split('T')[0]
      const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0]

      let newStreak = user.streak
      if (user.lastStudyDate === yesterday) {
        newStreak = user.streak + 1
      } else if (user.lastStudyDate !== today) {
        newStreak = 1
      }

      updateProfile({ streak: newStreak, lastStudyDate: today })
    }
  }

  const addQuizResult = (result: Omit<QuizResult, 'id'>) => {
    const newResult = { ...result, id: crypto.randomUUID() }
    setQuizResults(prev => [...prev, newResult])
  }

  // Timer effects and controls
  const getInitialTime = useCallback(() => {
    if (timerType === 'pomodoro') {
      return timerMode === 'study' ? 25 * 60 : 5 * 60
    }
    return customDuration * 60
  }, [timerType, timerMode, customDuration])

  useEffect(() => {
    let interval: NodeJS.Timeout | null = null

    if (isRunning && timeLeft > 0) {
      interval = setInterval(() => {
        setTimeLeft((time) => time - 1)
      }, 1000)
    } else if (timeLeft === 0 && isRunning) {
      if (timerMode === 'study') {
        const duration = timerType === 'pomodoro' ? 25 : customDuration
        if (timerSubject) {
          addStudySession({
            subjectId: timerSubject,
            date: new Date().toISOString().split('T')[0],
            duration,
            type: timerType,
          })
        }
        if (timerType === 'pomodoro') {
          setTimerMode('break')
          setTimeLeft(5 * 60)
        }
      } else {
        setTimerMode('study')
        setTimeLeft(25 * 60)
      }
      setIsRunning(false)
    }

    return () => {
      if (interval) clearInterval(interval)
    }
  }, [isRunning, timeLeft, timerMode, timerType, customDuration, timerSubject])

  const startTimer = () => {
    if (timerSubject) setIsRunning(true)
  }
  const pauseTimer = () => setIsRunning(false)
  const resetTimer = () => {
    setIsRunning(false)
    setTimeLeft(getInitialTime())
  }
  const setTimerConfig = (config: { type?: 'pomodoro' | 'custom'; mode?: 'study' | 'break'; duration?: number; subjectId?: string | null; focusMode?: boolean }) => {
    if (config.type !== undefined) setTimerType(config.type)
    if (config.mode !== undefined) setTimerMode(config.mode)
    if (config.duration !== undefined) {
      setCustomDuration(config.duration)
      if (timerType === 'custom') setTimeLeft(config.duration * 60)
    }
    if (config.subjectId !== undefined) setTimerSubject(config.subjectId)
    if (config.focusMode !== undefined) setFocusMode(config.focusMode)

    // Auto-update timeLeft if mode/type changes
    if (config.type === 'pomodoro' || config.mode !== undefined) {
      const isStudy = config.mode === 'study' || (config.mode === undefined && timerMode === 'study')
      const isPom = config.type === 'pomodoro' || (config.type === undefined && timerType === 'pomodoro')
      if (isPom) setTimeLeft(isStudy ? 25 * 60 : 5 * 60)
    }
  }

  const addFlashcard = (f: Omit<Flashcard, 'id' | 'lastReviewed' | 'nextReview' | 'easeFactor' | 'interval'>) => {
    const newCard: Flashcard = {
      ...f,
      id: crypto.randomUUID(),
      lastReviewed: new Date().toISOString(),
      nextReview: new Date().toISOString(),
      easeFactor: 2.5,
      interval: 0,
    }
    setFlashcards(prev => [...prev, newCard])
  }

  const reviewFlashcard = (id: string, quality: number) => {
    setFlashcards(prev => prev.map(c => {
      if (c.id === id) {
        // Simple SM-2 like logic
        const newInterval = c.interval === 0 ? 1 : Math.ceil(c.interval * c.easeFactor)
        return {
          ...c,
          lastReviewed: new Date().toISOString(),
          nextReview: new Date(Date.now() + newInterval * 86400000).toISOString(),
          interval: newInterval
        }
      }
      return c
    }))
  }

  const toggleOfflineMode = () => setOfflineMode(!offlineMode)

  const downloadTopic = (topicId: string) => {
    if (!downloadedTopics.includes(topicId)) {
      setDownloadedTopics(prev => [...prev, topicId])
    }
  }

  const generateRoadmap = (goal: string, steps?: { month: string; target: string }[]) => {
    const newRoadmap: Roadmap = {
      id: crypto.randomUUID(),
      goal,
      steps: steps || [
        { month: 'Month 1', target: 'Foundation & Core Concepts' },
        { month: 'Month 2', target: 'Advanced Modules & Practice' },
        { month: 'Month 3', target: 'Full Mock Tests & Revision' },
      ]
    }
    setRoadmaps(prev => [...prev, newRoadmap])
  }

  const deleteRoadmap = (id: string) => {
    setRoadmaps(prev => prev.filter(r => r.id !== id));
  }

  const getTodayStudyTime = (): number => {
    const today = new Date().toISOString().split('T')[0]
    return studySessions
      .filter(s => s.date === today)
      .reduce((acc, s) => acc + s.duration, 0)
  }

  const getWeeklyStudyData = () => {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    const today = new Date()
    const weekData: { day: string; hours: number }[] = []

    for (let i = 6; i >= 0; i--) {
      const date = new Date(today)
      date.setDate(today.getDate() - i)
      const dateStr = date.toISOString().split('T')[0]
      const dayName = days[date.getDay()]

      const totalMinutes = studySessions
        .filter(s => s.date === dateStr)
        .reduce((acc, s) => acc + s.duration, 0)

      weekData.push({ day: dayName, hours: Math.round(totalMinutes / 60 * 10) / 10 })
    }

    return weekData
  }

  const getSubjectStrength = () => {
    if (!user?.subjects) return []

    return user.subjects.map(subject => {
      const subjectResults = quizResults.filter(r => r.subjectId === subject.id)

      if (subjectResults.length === 0) {
        return { subject: subject.name, accuracy: 0, status: 'Weak' as const }
      }

      const totalCorrect = subjectResults.reduce((acc, r) => acc + r.correctAnswers, 0)
      const totalQuestions = subjectResults.reduce((acc, r) => acc + r.totalQuestions, 0)
      const accuracy = Math.round((totalCorrect / totalQuestions) * 100)

      let status: 'Strong' | 'Average' | 'Weak'
      if (accuracy >= 75) status = 'Strong'
      else if (accuracy >= 50) status = 'Average'
      else status = 'Weak'

      return { subject: subject.name, accuracy, status }
    })
  }

  return (
    <StudyContext.Provider
      value={{
        user,
        setUser,
        studySessions,
        addStudySession,
        quizResults,
        addQuizResult,
        isAuthenticated,
        login,
        signup,
        logout,
        updateProfile,
        getTodayStudyTime,
        getWeeklyStudyData,
        getSubjectStrength,
        flashcards,
        addFlashcard,
        reviewFlashcard,
        offlineMode,
        toggleOfflineMode,
        downloadedTopics,
        downloadTopic,
        roadmaps,
        generateRoadmap,
        deleteRoadmap,
        revisionReminders,
        timer: {
          timeLeft,
          isRunning,
          mode: timerMode,
          type: timerType,
          selectedSubject: timerSubject,
          customDuration,
          focusMode
        },
        startTimer,
        pauseTimer,
        resetTimer,
        setTimerConfig,
      }}
    >
      {children}
    </StudyContext.Provider>
  )
}

export function useStudy() {
  const context = useContext(StudyContext)
  if (context === undefined) {
    throw new Error('useStudy must be used within a StudyProvider')
  }
  return context
}

export { SUBJECTS_BY_LEVEL }
