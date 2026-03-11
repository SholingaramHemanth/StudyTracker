"use client"

import { useState } from 'react'
import { useStudy, CareerPath, Roadmap } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Briefcase, Target, Map, Shield, Server, Code, ChevronRight, Sparkles } from 'lucide-react'
import { cn } from '@/lib/utils'

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
                  const { roadmaps, generateRoadmap } = useStudy()
                  const [goal, setGoal] = useState('')
                  const [selectedPath, setSelectedPath] = useState<CareerPath | null>(null)
                  const [isGenerating, setIsGenerating] = useState(false)

                  const handleGenerate = () => {
                                    if (!goal) return
                                    setIsGenerating(true)
                                    setTimeout(() => {
                                                      generateRoadmap(goal)
                                                      setIsGenerating(false)
                                                      setGoal('')
                                    }, 2000)
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
                                                                                                                                                                  <CardHeader className="bg-muted/50 border-b">
                                                                                                                                                                                    <CardTitle className="flex items-center gap-3">
                                                                                                                                                                                                      <Map className="w-5 h-5 text-primary" /> {r.goal}
                                                                                                                                                                                    </CardTitle>
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

                                                                        {/* Career Paths */}
                                                                        <div className="lg:col-span-12 space-y-6">
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
