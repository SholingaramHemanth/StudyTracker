"use client"

import { useState } from 'react'
import { useStudy } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Separator } from '@/components/ui/separator'
import { cn } from '@/lib/utils'
import {
                  BookOpen,
                  ChevronRight,
                  ArrowLeft,
                  GraduationCap,
                  Lightbulb,
                  Trophy,
                  HelpCircle,
                  FileText,
                  CheckCircle2,
                  XCircle,
                  Image as ImageIcon,
                  ExternalLink,
                  History,
                  AlertCircle,
                  Youtube,
                  Globe,
                  FileBadge,
                  Sparkles as SparklesIcon
} from 'lucide-react'
import { SUBJECT_TOPICS, getTutorModule, LearningModule } from '@/lib/tutor-data'

type TutorStage = 'SELECT_SUBJECT' | 'SELECT_TOPIC' | 'LEARNING_MODULE'

export function TutorPage() {
                  const { user } = useStudy()
                  const [stage, setStage] = useState<TutorStage>('SELECT_SUBJECT')
                  const [selectedSubjectId, setSelectedSubjectId] = useState<string | null>(null)
                  const [selectedTopic, setSelectedTopic] = useState<string | null>(null)
                  const [moduleData, setModuleData] = useState<LearningModule | null>(null)
                  const [quizState, setQuizState] = useState<{ active: boolean; currentQuestion: number; score: number; answers: (number | null)[] }>({
                                    active: false,
                                    currentQuestion: 0,
                                    score: 0,
                                    answers: []
                  })

                  const handleSubjectSelect = (id: string) => {
                                    setSelectedSubjectId(id)
                                    setStage('SELECT_TOPIC')
                  }

                  const handleTopicSelect = (topic: string) => {
                                    setSelectedTopic(topic)
                                    const data = getTutorModule(selectedSubjectId || 'default', topic)
                                    setModuleData(data)
                                    setStage('LEARNING_MODULE')
                                    window.scrollTo(0, 0)
                  }

                  const backToSubjects = () => {
                                    setStage('SELECT_SUBJECT')
                                    setSelectedTopic(null)
                                    setModuleData(null)
                  }

                  const backToTopics = () => {
                                    setStage('SELECT_TOPIC')
                                    setSelectedTopic(null)
                                    setModuleData(null)
                                    setQuizState({ active: false, currentQuestion: 0, score: 0, answers: [] })
                  }

                  const startQuiz = () => {
                                    setQuizState({ active: true, currentQuestion: 0, score: 0, answers: [] })
                  }

                  const handleQuizAnswer = (answerIndex: number) => {
                                    if (!moduleData) return
                                    const isCorrect = answerIndex === moduleData.practiceQuestions.mcqs[quizState.currentQuestion].answer
                                    const newAnswers = [...quizState.answers, answerIndex]

                                    setQuizState(prev => ({
                                                      ...prev,
                                                      score: isCorrect ? prev.score + 1 : prev.score,
                                                      answers: newAnswers
                                    }))

                                    setTimeout(() => {
                                                      if (quizState.currentQuestion < moduleData.practiceQuestions.mcqs.length - 1) {
                                                                        setQuizState(prev => ({ ...prev, currentQuestion: prev.currentQuestion + 1 }))
                                                      }
                                    }, 1000)
                  }

                  if (stage === 'SELECT_SUBJECT') {
                                    return (
                                                      <div className="max-w-4xl mx-auto space-y-6">
                                                                        <div className="flex flex-col gap-2">
                                                                                          <h2 className="text-3xl font-bold tracking-tight bg-gradient-to-r from-primary to-primary/60 bg-clip-text text-transparent">AI Expert Tutor</h2>
                                                                                          <p className="text-muted-foreground">Select a subject to begin your personalized learning journey.</p>
                                                                        </div>

                                                                        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                                                                                          {user?.subjects?.map((subject) => (
                                                                                                            <Card
                                                                                                                              key={subject.id}
                                                                                                                              className="cursor-pointer hover:border-primary/50 transition-all hover:shadow-lg hover:-translate-y-1 bg-card/50 backdrop-blur group border-2"
                                                                                                                              onClick={() => handleSubjectSelect(subject.id)}
                                                                                                            >
                                                                                                                              <CardHeader className="flex flex-row items-center justify-between space-y-0">
                                                                                                                                                <div className="flex items-center gap-4">
                                                                                                                                                                  <div className="text-4xl p-2 bg-primary/5 rounded-xl group-hover:bg-primary/10 transition-colors">{subject.icon}</div>
                                                                                                                                                                  <div>
                                                                                                                                                                                    <CardTitle className="text-lg font-bold">{subject.name}</CardTitle>
                                                                                                                                                                                    <CardDescription>{SUBJECT_TOPICS[subject.id]?.length || 0} Core Modules</CardDescription>
                                                                                                                                                                  </div>
                                                                                                                                                </div>
                                                                                                                                                <ChevronRight className="w-5 h-5 text-muted-foreground group-hover:text-primary transition-all group-hover:translate-x-1" />
                                                                                                                              </CardHeader>
                                                                                                            </Card>
                                                                                          ))}
                                                                        </div>
                                                      </div>
                                    )
                  }

                  if (stage === 'SELECT_TOPIC') {
                                    const subject = user?.subjects?.find(s => s.id === selectedSubjectId)
                                    const topics = SUBJECT_TOPICS[selectedSubjectId || 'default'] || []

                                    return (
                                                      <div className="max-w-4xl mx-auto space-y-8">
                                                                        <div className="flex items-center gap-4 p-4 bg-muted/30 rounded-2xl border border-dashed border-primary/20">
                                                                                          <Button variant="ghost" size="icon" onClick={backToSubjects} className="hover:bg-primary/10">
                                                                                                            <ArrowLeft className="w-5 h-5" />
                                                                                          </Button>
                                                                                          <div>
                                                                                                            <h2 className="text-2xl font-bold">{subject?.name} Syllabus</h2>
                                                                                                            <p className="text-sm text-muted-foreground">Pick a module to dive into the details.</p>
                                                                                          </div>
                                                                        </div>

                                                                        <div className="grid gap-4">
                                                                                          {topics.map((topic, index) => (
                                                                                                            <Card
                                                                                                                              key={index}
                                                                                                                              className="group cursor-pointer hover:border-primary/40 transition-all shadow-sm active:scale-[0.98]"
                                                                                                                              onClick={() => handleTopicSelect(topic)}
                                                                                                            >
                                                                                                                              <CardContent className="flex items-center justify-between p-6">
                                                                                                                                                <div className="flex items-center gap-6">
                                                                                                                                                                  <div className="w-12 h-12 rounded-2xl bg-primary/10 flex items-center justify-center font-bold text-lg text-primary group-hover:scale-110 transition-transform">
                                                                                                                                                                                    {index + 1}
                                                                                                                                                                  </div>
                                                                                                                                                                  <div>
                                                                                                                                                                                    <h3 className="text-lg font-semibold">{topic}</h3>
                                                                                                                                                                                    <p className="text-xs text-muted-foreground mt-1">Foundational Concept • High Importance</p>
                                                                                                                                                                  </div>
                                                                                                                                                </div>
                                                                                                                                                <Button variant="outline" className="group-hover:bg-primary group-hover:text-primary-foreground transition-all">
                                                                                                                                                                  Access Content <BookOpen className="w-4 h-4 ml-2" />
                                                                                                                                                </Button>
                                                                                                                              </CardContent>
                                                                                                            </Card>
                                                                                          ))}
                                                                        </div>
                                                      </div>
                                    )
                  }

                  if (stage === 'LEARNING_MODULE' && moduleData) {
                                    const subject = user?.subjects?.find(s => s.id === selectedSubjectId)

                                    return (
                                                      <div className="max-w-4xl mx-auto space-y-12 pb-32 pt-4">
                                                                        {/* Navigation Sticky Bar */}
                                                                        <div className="fixed bottom-8 left-1/2 -translate-x-1/2 z-50 flex items-center gap-2 p-2 bg-background/80 backdrop-blur-xl border border-primary/20 rounded-full shadow-2xl">
                                                                                          <Button variant="ghost" size="sm" onClick={backToTopics} className="rounded-full">
                                                                                                            <ArrowLeft className="w-4 h-4 mr-2" /> All Topics
                                                                                          </Button>
                                                                                          <div className="h-6 w-[1px] bg-border mx-1" />
                                                                                          <Button size="sm" className="rounded-full bg-primary shadow-lg shadow-primary/20" onClick={() => window.scrollTo({ top: document.getElementById('section-12')?.offsetTop ? document.getElementById('section-12')!.offsetTop - 100 : 0, behavior: 'smooth' })}>
                                                                                                            Jump to Quiz
                                                                                          </Button>
                                                                        </div>

                                                                        {/* SECTION 1: TOPIC TITLE */}
                                                                        <div id="section-1" className="text-center space-y-4 py-8">
                                                                                          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-widest border border-primary/20">
                                                                                                            {subject?.name} • Learning Module
                                                                                          </div>
                                                                                          <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight">{moduleData.title}</h1>
                                                                                          <div className="flex items-center justify-center gap-6 text-sm text-muted-foreground">
                                                                                                            <span className="flex items-center gap-1"><BookOpen className="w-4 h-4" /> Comprehensive</span>
                                                                                                            <span className="flex items-center gap-1"><Trophy className="w-4 h-4" /> Exam Optimized</span>
                                                                                                            <span className="flex items-center gap-1"><ImageIcon className="w-4 h-4" /> Visual Aided</span>
                                                                                          </div>
                                                                        </div>

                                                                        {/* SECTION 2: TOPIC OVERVIEW */}
                                                                        <section id="section-2" className="space-y-4">
                                                                                          <div className="flex items-center gap-3">
                                                                                                            <div className="w-1.5 h-8 bg-primary rounded-full" />
                                                                                                            <h2 className="text-2xl font-bold">2. Topic Overview</h2>
                                                                                          </div>
                                                                                          <Card className="bg-primary/5 border-primary/20 shadow-none">
                                                                                                            <CardContent className="p-8 text-lg leading-relaxed text-foreground/80 italic">
                                                                                                                              "{moduleData.overview}"
                                                                                                            </CardContent>
                                                                                          </Card>
                                                                        </section>

                                                                        {/* SECTION 3: DETAILED EXPLANATION */}
                                                                        <section id="section-3" className="space-y-4">
                                                                                          <div className="flex items-center gap-3">
                                                                                                            <div className="w-1.5 h-8 bg-blue-500 rounded-full" />
                                                                                                            <h2 className="text-2xl font-bold">3. Detailed Explanation</h2>
                                                                                          </div>
                                                                                          <Card className="border-none shadow-sm bg-muted/20">
                                                                                                            <CardContent className="p-8 prose prose-blue dark:prose-invert max-w-none">
                                                                                                                              <p className="text-lg leading-loose text-muted-foreground">
                                                                                                                                                {moduleData.detailedExplanation}
                                                                                                                              </p>
                                                                                                            </CardContent>
                                                                                          </Card>
                                                                        </section>

                                                                        {/* SECTION 4: KEY CONCEPTS */}
                                                                        <section id="section-4" className="space-y-6">
                                                                                          <div className="flex items-center gap-3">
                                                                                                            <div className="w-1.5 h-8 bg-amber-500 rounded-full" />
                                                                                                            <h2 className="text-2xl font-bold text-amber-600 dark:text-amber-400">4. Key Concepts</h2>
                                                                                          </div>
                                                                                          <div className="grid gap-4">
                                                                                                            {moduleData.keyConcepts.map((concept, i) => (
                                                                                                                              <div key={i} className="group p-6 rounded-2xl border bg-card hover:border-amber-500/50 transition-colors">
                                                                                                                                                <div className="flex items-start gap-4">
                                                                                                                                                                  <div className="w-10 h-10 rounded-xl bg-amber-500/10 flex items-center justify-center text-amber-600 font-bold shrink-0">
                                                                                                                                                                                    {i + 1}
                                                                                                                                                                  </div>
                                                                                                                                                                  <div className="space-y-2">
                                                                                                                                                                                    <h4 className="font-bold text-lg">{concept.name}</h4>
                                                                                                                                                                                    <p className="text-muted-foreground text-sm leading-relaxed">{concept.explanation}</p>
                                                                                                                                                                  </div>
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            ))}
                                                                                          </div>
                                                                        </section>

                                                                        {/* SECTION 5: REAL-WORLD EXAMPLE */}
                                                                        <section id="section-5" className="space-y-4">
                                                                                          <div className="flex items-center gap-3">
                                                                                                            <div className="w-1.5 h-8 bg-emerald-500 rounded-full" />
                                                                                                            <h2 className="text-2xl font-bold">5. Real-world Example</h2>
                                                                                          </div>
                                                                                          <div className="p-8 rounded-[2rem] bg-emerald-50 border-2 border-emerald-100 dark:bg-emerald-950/20 dark:border-emerald-500/20 relative overflow-hidden">
                                                                                                            <div className="absolute top-0 right-0 p-8 text-emerald-500/10">
                                                                                                                              <Globe className="w-32 h-32" />
                                                                                                            </div>
                                                                                                            <p className="text-emerald-900 dark:text-emerald-200 text-lg leading-relaxed relative z-10 font-medium">
                                                                                                                              {moduleData.realWorldExample}
                                                                                                            </p>
                                                                                          </div>
                                                                        </section>

                                                                        {/* SECTION 6: DIAGRAM OR IMAGE */}
                                                                        {moduleData.diagramUrl && (
                                                                                          <section id="section-6" className="space-y-6">
                                                                                                            <div className="flex items-center gap-3">
                                                                                                                              <div className="w-1.5 h-8 bg-purple-500 rounded-full" />
                                                                                                                              <h2 className="text-2xl font-bold group-hover:underline decoration-purple-500/30">6. Visual Explanation</h2>
                                                                                                            </div>
                                                                                                            <Card className="overflow-hidden border-2 border-purple-500/10">
                                                                                                                              <div className="bg-white p-8">
                                                                                                                                                <img src={moduleData.diagramUrl} alt="Visual explanation" className="w-full max-h-[500px] object-contain mx-auto" />
                                                                                                                              </div>
                                                                                                                              <CardFooter className="bg-purple-500/5 border-t border-purple-500/10 p-6">
                                                                                                                                                <div className="flex gap-4">
                                                                                                                                                                  <ImageIcon className="w-6 h-6 text-purple-600 shrink-0" />
                                                                                                                                                                  <p className="text-sm text-purple-900 dark:text-purple-300 italic">
                                                                                                                                                                                    <span className="font-bold uppercase tracking-wider text-[10px] block not-italic mb-1 text-purple-500">Diagram Insight</span>
                                                                                                                                                                                    {moduleData.diagramExplanation}
                                                                                                                                                                  </p>
                                                                                                                                                </div>
                                                                                                                              </CardFooter>
                                                                                                            </Card>
                                                                                          </section>
                                                                        )}

                                                                        <Separator className="opacity-50" />

                                                                        {/* SECTION 7: IMPORTANT POINTS FOR EXAMS */}
                                                                        <section id="section-7" className="space-y-6">
                                                                                          <div className="flex items-center gap-3">
                                                                                                            <div className="w-1.5 h-8 bg-red-500 rounded-full" />
                                                                                                            <h2 className="text-2xl font-bold text-red-600 dark:text-red-400">7. Important Points for Exams</h2>
                                                                                          </div>
                                                                                          <div className="grid gap-3">
                                                                                                            {moduleData.examPoints.map((point, i) => (
                                                                                                                              <div key={i} className="flex items-center gap-4 p-4 rounded-xl bg-red-500/5 border border-red-500/10 hover:border-red-500/30 transition-all">
                                                                                                                                                <FileBadge className="w-5 h-5 text-red-600 shrink-0" />
                                                                                                                                                <span className="text-sm font-medium">{point}</span>
                                                                                                                              </div>
                                                                                                            ))}
                                                                                          </div>
                                                                        </section>

                                                                        {/* SECTION 8: ADDITIONAL INFORMATION */}
                                                                        {moduleData.additionalInfo && (
                                                                                          <section id="section-8" className="space-y-6">
                                                                                                            <div className="flex items-center gap-3">
                                                                                                                              <div className="w-1.5 h-8 bg-indigo-500 rounded-full" />
                                                                                                                              <h2 className="text-2xl font-bold">8. Additional Context</h2>
                                                                                                            </div>
                                                                                                            <div className="grid md:grid-cols-2 gap-6">
                                                                                                                              {moduleData.additionalInfo.historical && (
                                                                                                                                                <div className="p-6 rounded-2xl bg-indigo-500/5 border border-indigo-500/20 space-y-3">
                                                                                                                                                                  <div className="flex items-center gap-2 text-indigo-600 font-bold text-sm">
                                                                                                                                                                                    <History className="w-4 h-4" /> Historical Background
                                                                                                                                                                  </div>
                                                                                                                                                                  <p className="text-sm text-muted-foreground leading-relaxed">{moduleData.additionalInfo.historical}</p>
                                                                                                                                                </div>
                                                                                                                              )}
                                                                                                                              {moduleData.additionalInfo.commonMistakes && (
                                                                                                                                                <div className="p-6 rounded-2xl bg-orange-500/5 border border-orange-500/20 space-y-3">
                                                                                                                                                                  <div className="flex items-center gap-2 text-orange-600 font-bold text-sm">
                                                                                                                                                                                    <AlertCircle className="w-4 h-4" /> Common Mistakes
                                                                                                                                                                  </div>
                                                                                                                                                                  <ul className="text-sm text-muted-foreground space-y-2">
                                                                                                                                                                                    {moduleData.additionalInfo.commonMistakes.map((m, i) => <li key={i} className="flex gap-2"><span>•</span> {m}</li>)}
                                                                                                                                                                  </ul>
                                                                                                                                                </div>
                                                                                                                              )}
                                                                                                            </div>
                                                                                          </section>
                                                                        )}

                                                                        {/* SECTION 9: EXTERNAL LEARNING RESOURCES */}
                                                                        {moduleData.externalResources && moduleData.externalResources.length > 0 && (
                                                                                          <section id="section-9" className="space-y-6">
                                                                                                            <div className="flex items-center gap-3">
                                                                                                                              <div className="w-1.5 h-8 bg-primary rounded-full" />
                                                                                                                              <h2 className="text-2xl font-bold">9. Deep Dive Resources</h2>
                                                                                                            </div>
                                                                                                            <div className="grid sm:grid-cols-3 gap-4">
                                                                                                                              {moduleData.externalResources.map((res, i) => (
                                                                                                                                                <a key={i} href={res.url} target="_blank" rel="noopener noreferrer" className="group p-4 rounded-xl border bg-muted/20 hover:bg-primary/10 hover:border-primary/50 transition-all flex items-center gap-4">
                                                                                                                                                                  <div className="w-10 h-10 rounded-lg bg-background flex items-center justify-center border group-hover:border-primary/50 transition-all">
                                                                                                                                                                                    {res.type === 'video' ? <Youtube className="w-5 h-5 text-red-500" /> : res.type === 'doc' ? <FileText className="w-5 h-5 text-blue-500" /> : <Globe className="w-5 h-5 text-emerald-500" />}
                                                                                                                                                                  </div>
                                                                                                                                                                  <div className="overflow-hidden">
                                                                                                                                                                                    <p className="text-xs font-bold truncate">{res.title}</p>
                                                                                                                                                                                    <p className="text-[10px] text-muted-foreground capitalize flex items-center gap-1">
                                                                                                                                                                                                      {res.type} <ExternalLink className="w-2 h-2" />
                                                                                                                                                                                    </p>
                                                                                                                                                                  </div>
                                                                                                                                                </a>
                                                                                                                              ))}
                                                                                                            </div>
                                                                                          </section>
                                                                        )}

                                                                        {/* SECTION 10: PRACTICE QUESTIONS */}
                                                                        <section id="section-10" className="space-y-8 p-10 bg-slate-100/50 dark:bg-slate-900/50 rounded-[3rem] border border-slate-200 dark:border-slate-800">
                                                                                          <div className="text-center space-y-2">
                                                                                                            <h2 className="text-3xl font-extrabold tracking-tight">10. Practice Zone</h2>
                                                                                                            <p className="text-muted-foreground">Test your knowledge with these conceptual and factual drills.</p>
                                                                                          </div>

                                                                                          <div className="space-y-4">
                                                                                                            <h4 className="text-xs font-black uppercase tracking-widest text-primary/60 text-center">Conceptual Challenges</h4>
                                                                                                            <div className="grid gap-4">
                                                                                                                              {moduleData.practiceQuestions.conceptual.map((c, i) => (
                                                                                                                                                <div key={i} className="p-5 rounded-2xl bg-background border-2 border-dashed border-primary/20 flex gap-4 items-center">
                                                                                                                                                                  <div className="text-primary font-black opacity-20 text-4xl leading-none">?</div>
                                                                                                                                                                  <p className="text-sm font-semibold">{c}</p>
                                                                                                                                                </div>
                                                                                                                              ))}
                                                                                                            </div>
                                                                                          </div>

                                                                                          <div className="space-y-4 pt-6">
                                                                                                            <h4 className="text-xs font-black uppercase tracking-widest text-primary/60 text-center">Sample MCQ Review</h4>
                                                                                                            {moduleData.practiceQuestions.mcqs.slice(0, 1).map((q, i) => (
                                                                                                                              <Card key={i} className="border-none shadow-none bg-background/80">
                                                                                                                                                <CardContent className="pt-6">
                                                                                                                                                                  <p className="font-bold text-center mb-6">{q.question}</p>
                                                                                                                                                                  <div className="grid grid-cols-2 gap-3">
                                                                                                                                                                                    {q.options.map((opt, oi) => (
                                                                                                                                                                                                      <div key={oi} className={cn("p-4 rounded-xl border text-center text-xs font-medium transition-all cursor-default", oi === q.answer ? "bg-primary/5 border-primary/50 text-primary" : "bg-muted/50")}>
                                                                                                                                                                                                                        {opt}
                                                                                                                                                                                                      </div>
                                                                                                                                                                                    ))}
                                                                                                                                                                  </div>
                                                                                                                                                </CardContent>
                                                                                                                              </Card>
                                                                                                            ))}
                                                                                          </div>
                                                                        </section>

                                                                        {/* SECTION 11: PRACTICE PROBLEMS */}
                                                                        {moduleData.practiceProblems && moduleData.practiceProblems.length > 0 && (
                                                                                          <section id="section-11" className="space-y-6">
                                                                                                            <div className="flex items-center gap-3">
                                                                                                                              <div className="w-1.5 h-8 bg-black dark:bg-white rounded-full" />
                                                                                                                              <h2 className="text-2xl font-bold">11. Practice Problems</h2>
                                                                                                            </div>
                                                                                                            <div className="space-y-6">
                                                                                                                              {moduleData.practiceProblems.map((prob, i) => (
                                                                                                                                                <div key={i} className="group border-2 rounded-3xl overflow-hidden shadow-sm hover:shadow-md transition-shadow">
                                                                                                                                                                  <div className="p-8 bg-muted/30">
                                                                                                                                                                                    <p className="text-xs font-black text-muted-foreground uppercase tracking-widest mb-4">Problem Specification</p>
                                                                                                                                                                                    <p className="text-lg font-bold leading-relaxed">{prob.problem}</p>
                                                                                                                                                                  </div>
                                                                                                                                                                  <div className="p-8 border-t-2 bg-background">
                                                                                                                                                                                    <p className="text-xs font-black text-emerald-600 uppercase tracking-widest mb-4">Step-by-step Solution</p>
                                                                                                                                                                                    <p className="text-muted-foreground font-medium">{prob.solution}</p>
                                                                                                                                                                  </div>
                                                                                                                                                </div>
                                                                                                                              ))}
                                                                                                            </div>
                                                                                          </section>
                                                                        )}

                                                                        {/* SECTION 12: QUICK QUIZ */}
                                                                        <section id="section-12" className="mt-12">
                                                                                          <div className="p-12 rounded-[4rem] bg-gradient-to-br from-primary to-indigo-700 text-primary-foreground shadow-2xl relative overflow-hidden group">
                                                                                                            {/* Animated Background Decor */}
                                                                                                            <div className="absolute top-0 right-0 p-12 opacity-[0.03] group-hover:rotate-12 transition-transform duration-700">
                                                                                                                              <Trophy className="w-96 h-96" />
                                                                                                            </div>

                                                                                                            {!quizState.active ? (
                                                                                                                              <div className="relative z-10 text-center space-y-8">
                                                                                                                                                <div className="space-y-4">
                                                                                                                                                                  <h2 className="text-4xl font-extrabold">12. Master Skills Quiz</h2>
                                                                                                                                                                  <p className="text-primary-foreground/70 max-w-lg mx-auto leading-relaxed">
                                                                                                                                                                                    You've covered the module. Now prove your expertise by answering 5 critical knowledge questions.
                                                                                                                                                                  </p>
                                                                                                                                                </div>
                                                                                                                                                <div className="flex justify-center gap-8 py-4">
                                                                                                                                                                  <div className="flex flex-col">
                                                                                                                                                                                    <span className="text-3xl font-black">5</span>
                                                                                                                                                                                    <span className="text-[10px] uppercase font-bold opacity-60">High-Impact Qs</span>
                                                                                                                                                                  </div>
                                                                                                                                                                  <div className="w-[1px] h-10 bg-white/20" />
                                                                                                                                                                  <div className="flex flex-col">
                                                                                                                                                                                    <span className="text-3xl font-black">100</span>
                                                                                                                                                                                    <span className="text-[10px] uppercase font-bold opacity-60">Total Points</span>
                                                                                                                                                                  </div>
                                                                                                                                                </div>
                                                                                                                                                <Button size="lg" onClick={startQuiz} className="bg-white text-primary hover:bg-white/90 rounded-full h-14 px-12 text-lg font-bold shadow-2xl shadow-black/20">
                                                                                                                                                                  Begin Assessment Now
                                                                                                                                                </Button>
                                                                                                                              </div>
                                                                                                            ) : quizState.currentQuestion < moduleData.practiceQuestions.mcqs.length ? (
                                                                                                                              <div className="relative z-10 space-y-8">
                                                                                                                                                <div className="flex items-center justify-between">
                                                                                                                                                                  <span className="text-xs font-black uppercase tracking-widest opacity-60">Quest {quizState.currentQuestion + 1} / {moduleData.practiceQuestions.mcqs.length}</span>
                                                                                                                                                                  <div className="flex gap-1">
                                                                                                                                                                                    {Array.from({ length: moduleData.practiceQuestions.mcqs.length }).map((_, i) => (
                                                                                                                                                                                                      <div key={i} className={cn("h-1.5 rounded-full transition-all", i < quizState.currentQuestion ? "bg-white w-6" : i === quizState.currentQuestion ? "bg-white/50 w-8" : "bg-white/20 w-4")} />
                                                                                                                                                                                    ))}
                                                                                                                                                                  </div>
                                                                                                                                                </div>
                                                                                                                                                <h3 className="text-2xl font-bold min-h-[80px]">{moduleData.practiceQuestions.mcqs[quizState.currentQuestion].question}</h3>
                                                                                                                                                <div className="grid gap-4">
                                                                                                                                                                  {moduleData.practiceQuestions.mcqs[quizState.currentQuestion].options.map((option, idx) => (
                                                                                                                                                                                    <button
                                                                                                                                                                                                      key={idx}
                                                                                                                                                                                                      onClick={() => handleQuizAnswer(idx)}
                                                                                                                                                                                                      disabled={quizState.answers[quizState.currentQuestion] !== undefined}
                                                                                                                                                                                                      className={cn(
                                                                                                                                                                                                                        "w-full p-5 rounded-2xl border-2 text-left transition-all flex items-center gap-4 relative overflow-hidden group/opt",
                                                                                                                                                                                                                        quizState.answers[quizState.currentQuestion] === idx
                                                                                                                                                                                                                                          ? idx === moduleData.practiceQuestions.mcqs[quizState.currentQuestion].answer
                                                                                                                                                                                                                                                            ? "bg-emerald-500 border-emerald-400"
                                                                                                                                                                                                                                                            : "bg-rose-500 border-rose-400"
                                                                                                                                                                                                                                          : "bg-white/10 border-white/10 hover:bg-white/20 hover:border-white/30"
                                                                                                                                                                                                      )}
                                                                                                                                                                                    >
                                                                                                                                                                                                      <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center font-black text-sm shrink-0">
                                                                                                                                                                                                                        {String.fromCharCode(65 + idx)}
                                                                                                                                                                                                      </div>
                                                                                                                                                                                                      <span className="font-bold flex-grow">{option}</span>
                                                                                                                                                                                                      {quizState.answers[quizState.currentQuestion] === idx && (
                                                                                                                                                                                                                        idx === moduleData.practiceQuestions.mcqs[quizState.currentQuestion].answer
                                                                                                                                                                                                                                          ? <CheckCircle2 className="w-6 h-6" />
                                                                                                                                                                                                                                          : <XCircle className="w-6 h-6" />
                                                                                                                                                                                                      )}
                                                                                                                                                                                    </button>
                                                                                                                                                                  ))}
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            ) : (
                                                                                                                              <div className="relative z-10 text-center space-y-8">
                                                                                                                                                <div className="w-24 h-24 bg-white/20 rounded-full flex items-center justify-center mx-auto">
                                                                                                                                                                  <SparklesIcon className="w-12 h-12 text-yellow-300 animate-pulse" />
                                                                                                                                                </div>
                                                                                                                                                <div className="space-y-2">
                                                                                                                                                                  <h4 className="text-4xl font-black">Assessment Complete!</h4>
                                                                                                                                                                  <p className="text-primary-foreground/70">Your domain mastery score is ready for review.</p>
                                                                                                                                                </div>
                                                                                                                                                <div className="text-7xl font-black">{Math.round((quizState.score / moduleData.practiceQuestions.mcqs.length) * 100)}%</div>
                                                                                                                                                <p className="font-bold tracking-widest uppercase text-xs opacity-60">Performance Profile: {quizState.score < 2 ? 'Novice' : 'Expert'}</p>
                                                                                                                                                <Button onClick={startQuiz} className="bg-white/10 hover:bg-white/20 border-white/20 rounded-full">
                                                                                                                                                                  Retry Calibration
                                                                                                                                                </Button>
                                                                                                                              </div>
                                                                                                            )}
                                                                                          </div>
                                                                        </section>

                                                                        {/* SECTION 13: REVISION SUMMARY */}
                                                                        <section id="section-13" className="pt-12">
                                                                                          <div className="p-16 rounded-[4rem] bg-slate-900 text-white shadow-2xl relative overflow-hidden">
                                                                                                            <div className="absolute top-0 right-0 p-16 opacity-[0.05]">
                                                                                                                              <GraduationCap className="w-64 h-64" />
                                                                                                            </div>
                                                                                                            <div className="max-w-2xl space-y-6 relative z-10">
                                                                                                                              <div className="flex items-center gap-3 text-primary">
                                                                                                                                                <SparklesIcon className="w-8 h-8" />
                                                                                                                                                <h3 className="text-2xl font-black uppercase tracking-tighter">13. Revision Summary</h3>
                                                                                                                              </div>
                                                                                                                              <p className="text-xl text-slate-400 leading-relaxed font-medium">
                                                                                                                                                {moduleData.summary}
                                                                                                                              </p>
                                                                                                                              <div className="pt-8 flex flex-wrap gap-4">
                                                                                                                                                <div className="px-4 py-2 rounded-full bg-white/5 border border-white/10 text-xs font-bold text-slate-500 uppercase">Module Completed</div>
                                                                                                                                                <div className="px-4 py-2 rounded-full bg-white/5 border border-white/10 text-xs font-bold text-slate-500 uppercase">A+ Rating</div>
                                                                                                                              </div>
                                                                                                            </div>
                                                                                          </div>
                                                                        </section>

                                                                        <div className="flex justify-center pt-24">
                                                                                          <Button size="lg" onClick={backToTopics} variant="ghost" className="text-muted-foreground hover:text-primary rounded-full px-12 py-8 bg-muted/50 border border-dashed">
                                                                                                            Finalize Session & Return to Syllabus
                                                                                          </Button>
                                                                        </div>
                                                      </div>
                                    )
                  }

                  return null
}

function CardFooter({ children, className }: { children: React.ReactNode; className?: string }) {
                  return <div className={cn("p-4", className)}>{children}</div>
}
