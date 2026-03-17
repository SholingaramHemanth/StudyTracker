"use client"

import { useState } from 'react'
import { useStudy, CareerPath, Roadmap } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Briefcase, Target, Map, Shield, Server, Code, ChevronRight, Sparkles, MessageSquare, ExternalLink, Trash2 } from 'lucide-react'
import { cn } from '@/lib/utils'
import { generateRoadmapAction, getCareerGuidance } from '@/app/actions/ai'
import { toast } from 'sonner'
import ReactMarkdown from 'react-markdown'

const CAREER_PATHS: CareerPath[] = [
                  {
                                    id: 'cyber',
                                    title: 'Cybersecurity Analyst',
                                    skills: ['Networking', 'Linux', 'Ethical Hacking', 'Security Tools'],
                                    description: 'Protect organizations from cyber threats and data breaches.',
                                    roadmap: [
                                                      { month: 1, task: 'CompTIA Security+ Fundamentals' },
                                                      { month: 2, task: 'Network Scanning & Reconnaissance' },
                                                      { month: 3, task: 'Incident Response & Forensics' },
                                    ]
                  },
                  {
                                    id: 'swe',
                                    title: 'Software Engineer',
                                    skills: ['Data Structures', 'Algorithms', 'Web Dev', 'Cloud Systems'],
                                    description: 'Design and build complex software systems and applications.',
                                    roadmap: [
                                                      { month: 1, task: 'Mastering DSA Basics' },
                                                      { month: 2, task: 'System Design Patterns' },
                                                      { month: 3, task: 'Building Distributed Systems' },
                                    ]
                  }
]

export function GuidancePage() {
                  const { roadmaps, generateRoadmap, deleteRoadmap } = useStudy()
                  const [goal, setGoal] = useState('')
                  const [selectedPath, setSelectedPath] = useState<CareerPath | null>(null)
                  const [isGenerating, setIsGenerating] = useState(false)
                  const [careerQuestion, setCareerQuestion] = useState('')
                  const [careerAdvice, setCareerAdvice] = useState('')
                  const [isAsking, setIsAsking] = useState(false)

                   const handleGenerate = async () => {
                                    if (!goal) return
                                    setIsGenerating(true)
                                    try {
                                                      const roadmapData = await generateRoadmapAction(goal)
                                                      
                                                      // The study-context generateRoadmap expects a string and uses internal mock,
                                                      // so we'll bypass it and add the generated roadmap directly if possible,
                                                      // or update the context to accept a full roadmap object.
                                                      // For now, let's update it to use a new method or just use the local state if context is restricted.
                                                      // Since useStudy has roadmaps state, we'll use generateRoadmap if it's updated, 
                                                      // otherwise we'll inform the user we need to update the context.
                                                      
                                                      // Let's assume we update study-context to handle the AI data.
                                                      generateRoadmap(goal, roadmapData.steps)
                                                      toast.success("Roadmap generated successfully!")
                                                      setGoal('')
                                    } catch (error) {
                                                      console.error(error)
                                                      toast.error("Failed to generate roadmap. Please try again.")
                                    } finally {
                                                      setIsGenerating(false)
                                    }
                  }

                  const handleAskCareer = async () => {
                                    if (!careerQuestion) return
                                    setIsAsking(true)
                                    try {
                                                      const advice = await getCareerGuidance(careerQuestion)
                                                      setCareerAdvice(advice)
                                    } catch (error) {
                                                      toast.error("Failed to get career advice.")
                                    } finally {
                                                      setIsAsking(false)
                                    }
                  }

                  return (
                                    <div className="max-w-5xl mx-auto space-y-12">
                                                      <div className="flex flex-col gap-2">
                                                                        <h2 className="text-3xl font-bold tracking-tight">Career & Goal Planning</h2>
                                                                        <p className="text-muted-foreground">Map your future career or create a custom study roadmap.</p>
                                                      </div>

                                                      <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
                                                                        {/* Roadmap Generator */}
                                                                        <div className="lg:col-span-12">
                                                                                          <Card className="bg-primary/5 border-2 border-primary/20 p-8">
                                                                                                            <div className="flex flex-col md:flex-row gap-8 items-center">
                                                                                                                              <div className="w-20 h-20 rounded-3xl bg-primary flex items-center justify-center shrink-0 shadow-xl shadow-primary/20">
                                                                                                                                                <Target className="w-10 h-10 text-primary-foreground" />
                                                                                                                              </div>
                                                                                                                              <div className="flex-1 space-y-4">
                                                                                                                                                <h3 className="text-2xl font-black">AI Study Roadmap Generator</h3>
                                                                                                                                                <div className="flex flex-col sm:flex-row gap-2">
                                                                                                                                                                  <Input
                                                                                                                                                                                    placeholder="Your goal? (e.g., Crack SBI PO Exam, Learn Full Stack)"
                                                                                                                                                                                    className="h-14 text-lg border-primary/30"
                                                                                                                                                                                    value={goal}
                                                                                                                                                                                    onChange={(e) => setGoal(e.target.value)}
                                                                                                                                                                  />
                                                                                                                                                                  <Button className="h-14 px-8 font-bold" onClick={handleGenerate} disabled={isGenerating || !goal}>
                                                                                                                                                                                    {isGenerating ? "Processing..." : "Generate Plan"}
                                                                                                                                                                  </Button>
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            </div>
                                                                                          </Card>
                                                                        </div>

                                                                        {/* Generated Roadmaps */}
                                                                        {roadmaps.length > 0 && (
                                                                                          <div className="lg:col-span-12 space-y-6">
                                                                                                            <h4 className="text-xs font-black uppercase tracking-widest text-primary">Your Active Roadmaps</h4>
                                                                                                            <div className="grid gap-6">
                                                                                                                              {roadmaps.map((r) => (
                                                                                                                                                <Card key={r.id} className="overflow-hidden">
                                                                                                                                                                  <CardHeader className="bg-muted/50 border-b flex flex-row items-center justify-between">
                                                                                                                                                                                    <CardTitle className="flex items-center gap-3">
                                                                                                                                                                                                      <Map className="w-5 h-5 text-primary" /> {r.goal}
                                                                                                                                                                                    </CardTitle>
                                                                                                                                                                                    <Button variant="ghost" size="icon" className="text-muted-foreground hover:text-red-500 hover:bg-red-500/10" onClick={() => deleteRoadmap(r.id)}>
                                                                                                                                                                                      <Trash2 className="w-5 h-5" />
                                                                                                                                                                                    </Button>
                                                                                                                                                                  </CardHeader>
                                                                                                                                                                  <CardContent className="p-8">
                                                                                                                                                                                    <div className="grid md:grid-cols-3 gap-8 relative">
                                                                                                                                                                                                      {r.steps.map((s, i) => (
                                                                                                                                                                                                                        <div key={i} className="space-y-3 relative group">
                                                                                                                                                                                                                                          <div className="text-[10px] font-black uppercase tracking-tighter text-muted-foreground">{s.month}</div>
                                                                                                                                                                                                                                          <div className="font-bold text-lg group-hover:text-primary transition-colors">{s.target}</div>
                                                                                                                                                                                                                                          <div className="h-1.5 w-full bg-muted rounded-full overflow-hidden">
                                                                                                                                                                                                                                                            <div className="h-full bg-primary/20 w-full" />
                                                                                                                                                                                                                                          </div>
                                                                                                                                                                                                                        </div>
                                                                                                                                                                                                      ))}
                                                                                                                                                                                    </div>
                                                                                                                                                                  </CardContent>
                                                                                                                                                </Card>
                                                                                                                              ))}
                                                                                                            </div>
                                                                                          </div>
                                                                        )}

                                                                        {/* Full Screen AI Career Advisor Area */}
                                                                        {careerAdvice && (
                                                                        <div className="lg:col-span-12 animate-in fade-in slide-in-from-bottom-8">
                                                                          <Card className="border-none shadow-2xl bg-slate-900 text-white p-8 md:p-12 rounded-[3rem] overflow-hidden relative">
                                                                            <div className="absolute top-0 right-0 p-8 opacity-5">
                                                                              <Sparkles className="w-64 h-64" />
                                                                            </div>
                                                                            <div className="relative z-10 max-w-4xl mx-auto space-y-8">
                                                                              <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 border-b border-indigo-500/30 pb-6">
                                                                                <div className="space-y-2">
                                                                                  <div className="flex items-center gap-3 text-indigo-400">
                                                                                    <Sparkles className="w-6 h-6" />
                                                                                    <span className="font-black tracking-widest uppercase text-sm">AI Career Mastery Plan</span>
                                                                                  </div>
                                                                                  <h3 className="text-3xl font-bold">{careerQuestion}</h3>
                                                                                </div>
                                                                                <Button variant="outline" className="border-indigo-500/30 text-indigo-300 hover:text-white hover:bg-indigo-500/20" onClick={() => setCareerAdvice('')}>
                                                                                  Clear Active Plan
                                                                                </Button>
                                                                              </div>
                                                                              
                                                                              <div className="prose prose-invert prose-indigo max-w-none 
                                                                                prose-headings:font-black prose-headings:tracking-tight 
                                                                                prose-h1:text-4xl prose-h2:text-2xl prose-h2:mt-12 prose-h2:mb-6 
                                                                                prose-p:text-slate-300 prose-p:leading-relaxed prose-p:text-lg
                                                                                prose-li:text-slate-300 prose-li:text-lg
                                                                                prose-strong:text-indigo-300
                                                                                prose-hr:border-indigo-500/20">
                                                                                <ReactMarkdown>{careerAdvice}</ReactMarkdown>
                                                                              </div>
                                                                            </div>
                                                                          </Card>
                                                                        </div>
                                                                        )}

                                                                        {/* Career Paths */}
                                                                        <div className="lg:col-span-8 space-y-6">
                                                                                          <h4 className="text-xs font-black uppercase tracking-widest text-primary">Explore Career Paths</h4>
                                                                                          <div className="grid md:grid-cols-2 gap-6">
                                                                                                            {CAREER_PATHS.map((path) => (
                                                                                                                              <Card
                                                                                                                                                key={path.id}
                                                                                                                                                className={cn(
                                                                                                                                                                  "cursor-pointer transition-all hover:scale-105 border-2",
                                                                                                                                                                  selectedPath?.id === path.id ? "border-primary bg-primary/5" : "hover:border-primary/20"
                                                                                                                                                )}
                                                                                                                                                onClick={() => setSelectedPath(path)}
                                                                                                                              >
                                                                                                                                                <CardHeader>
                                                                                                                                                                  <div className="flex items-center gap-4">
                                                                                                                                                                                    <div className="w-12 h-12 rounded-xl bg-muted flex items-center justify-center">
                                                                                                                                                                                                      {path.id === 'cyber' ? <Shield className="w-6 h-6" /> : <Code className="w-6 h-6" />}
                                                                                                                                                                                    </div>
                                                                                                                                                                                    <div>
                                                                                                                                                                                                      <CardTitle>{path.title}</CardTitle>
                                                                                                                                                                                                      <CardDescription>Domain Exploration</CardDescription>
                                                                                                                                                                                    </div>
                                                                                                                                                                  </div>
                                                                                                                                                </CardHeader>
                                                                                                                                                <CardContent className="space-y-4">
                                                                                                                                                                  <p className="text-sm text-muted-foreground">{path.description}</p>
                                                                                                                                                                  <div className="flex flex-wrap gap-2">
                                                                                                                                                                                    {path.skills.map(skill => (
                                                                                                                                                                                                      <span key={skill} className="px-2 py-1 rounded-md bg-muted text-[10px] font-bold">{skill}</span>
                                                                                                                                                                                    ))}
                                                                                                                                                                  </div>
                                                                                                                                                </CardContent>
                                                                                                                              </Card>
                                                                                                            ))}
                                                                                          </div>
                                                                        </div>

                                                                        {/* AI Career Advisor Side Panel */}
                                                                        <div className="lg:col-span-4 space-y-6">
                                                                                          <Card className="h-full border-none shadow-xl bg-gradient-to-br from-indigo-600 to-violet-700 text-white overflow-hidden relative">
                                                                                                            <div className="absolute top-0 right-0 p-4 opacity-10">
                                                                                                                              <MessageSquare className="w-32 h-32" />
                                                                                                            </div>
                                                                                                            <CardHeader>
                                                                                                                              <CardTitle className="flex items-center gap-2">
                                                                                                                                                <Sparkles className="w-5 h-5" />
                                                                                                                                                AI Career Advisor
                                                                                                                              </CardTitle>
                                                                                                                              <CardDescription className="text-indigo-100">
                                                                                                                                                Ask any career-related question!
                                                                                                                              </CardDescription>
                                                                                                            </CardHeader>
                                                                                                            <CardContent className="space-y-4 relative z-10">
                                                                                                                              <textarea
                                                                                                                                                className="w-full h-32 bg-white/10 border border-white/20 rounded-xl p-3 text-sm placeholder:text-indigo-200 focus:outline-none focus:ring-2 focus:ring-white/30 transition-all resize-none"
                                                                                                                                                placeholder="Example: What's the best path to become a Data Scientist in 2025?"
                                                                                                                                                value={careerQuestion}
                                                                                                                                                onChange={(e) => setCareerQuestion(e.target.value)}
                                                                                                                              />
                                                                                                                              <Button 
                                                                                                                                                className="w-full bg-white text-indigo-600 hover:bg-neutral-100 font-bold h-12 rounded-xl"
                                                                                                                                                onClick={handleAskCareer}
                                                                                                                                                disabled={isAsking || !careerQuestion}
                                                                                                                              >
                                                                                                                                                {isAsking ? "Generating Professional Plan..." : "Get Expert Advice"}
                                                                                                                              </Button>
                                                                                                                              
                                                                                                                              {careerAdvice && (
                                                                                                                                                <div className="mt-4 p-4 bg-black/20 rounded-xl backdrop-blur-sm space-y-3 animate-in fade-in slide-in-from-bottom-4">
                                                                                                                                                                  <div className="text-[10px] font-black uppercase tracking-widest text-indigo-200">Advisor Response</div>
                                                                                                                                                                  <p className="text-xs leading-relaxed text-indigo-50 whitespace-pre-wrap">{careerAdvice}</p>
                                                                                                                                                                  <Button variant="ghost" size="sm" className="h-7 text-[10px] text-indigo-200 hover:text-white hover:bg-white/10 p-0" onClick={() => setCareerAdvice('')}>
                                                                                                                                                                                    Clear Advice
                                                                                                                                                                  </Button>
                                                                                                                                                </div>
                                                                                                                              )}
                                                                                                            </CardContent>
                                                                                          </Card>
                                                                        </div>

                                                                        {selectedPath && (
                                                                                          <div className="lg:col-span-12 animate-in fade-in slide-in-from-bottom-8">
                                                                                                            <Card className="border-none shadow-2xl bg-slate-900 text-white p-12 rounded-[3rem]">
                                                                                                                              <div className="flex flex-col md:flex-row gap-12">
                                                                                                                                                <div className="md:w-1/3 space-y-6">
                                                                                                                                                                  <Sparkles className="w-12 h-12 text-blue-400" />
                                                                                                                                                                  <h3 className="text-4xl font-black">Path to {selectedPath.title}</h3>
                                                                                                                                                                  <p className="text-slate-400 leading-relaxed font-medium">To become a domain expert, you need to follow a structured progression starting from fundamentals to expert tools.</p>
                                                                                                                                                </div>
                                                                                                                                                <div className="flex-1 space-y-8">
                                                                                                                                                                  {selectedPath.roadmap.map((step, i) => (
                                                                                                                                                                                    <div key={i} className="flex gap-8 group">
                                                                                                                                                                                                      <div className="text-4xl font-black text-slate-800 group-hover:text-blue-500/50 transition-colors">0{step.month}</div>
                                                                                                                                                                                                      <div className="space-y-1 pt-2">
                                                                                                                                                                                                                        <div className="text-xs font-black uppercase tracking-[0.2em] text-blue-400">Phase {step.month}</div>
                                                                                                                                                                                                                        <div className="text-xl font-bold">{step.task}</div>
                                                                                                                                                                                                      </div>
                                                                                                                                                                                    </div>
                                                                                                                                                                  ))}
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            </Card>
                                                                                          </div>
                                                                        )}
                                                      </div>
                                    </div>
                  )
}
