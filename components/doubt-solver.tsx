"use client"

import { useState, useRef } from 'react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Camera, Send, Loader2, Image as ImageIcon, CheckCircle2, ChevronRight } from 'lucide-react'
import { cn } from '@/lib/utils'

interface Step {
                  title: string
                  detail: string
}

export function DoubtSolver() {
                  const [query, setQuery] = useState('')
                  const [isAnalyzing, setIsAnalyzing] = useState(false)
                  const [solution, setSolution] = useState<{ question: string; steps: Step[] } | null>(null)
                  const [mode, setMode] = useState<'type' | 'scan'>('type')
                  const fileInputRef = useRef<HTMLInputElement>(null)

                  const handleSolve = async () => {
                                    if (!query.trim()) return
                                    setIsAnalyzing(true)

                                    // Simulate AI analysis
                                    await new Promise(r => setTimeout(r, 2000))

                                    setSolution({
                                                      question: query,
                                                      steps: [
                                                                        { title: "Identify the terms", detail: "Move constants to one side by subtracting 5 from both sides." },
                                                                        { title: "Simplify equation", detail: "2x = 15 - 5 => 2x = 10" },
                                                                        { title: "Isolate x", detail: "Divide both sides by 2." },
                                                                        { title: "Final Result", detail: "x = 5" }
                                                      ]
                                    })
                                    setIsAnalyzing(false)
                                    setQuery('')
                  }

                  const handleFileSelect = () => {
                                    fileInputRef.current?.click()
                  }

                  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
                                    const file = e.target.files?.[0]
                                    if (file) {
                                                      setIsAnalyzing(true)
                                                      setTimeout(() => {
                                                                        setQuery("Solve 2x + 5 = 15")
                                                                        setIsAnalyzing(false)
                                                                        setMode('type')
                                                      }, 1500)
                                    }
                  }

                  return (
                                    <div className="max-w-4xl mx-auto space-y-6">
                                                      <div className="flex flex-col gap-2">
                                                                        <h2 className="text-3xl font-bold tracking-tight">AI Doubt Solver</h2>
                                                                        <p className="text-muted-foreground">Get instant, step-by-step solutions to your toughest questions.</p>
                                                      </div>

                                                      <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
                                                                        <Card className="md:col-span-12 border-2 border-primary/20 bg-primary/5">
                                                                                          <CardContent className="pt-6">
                                                                                                            <div className="flex flex-col sm:flex-row gap-4">
                                                                                                                              <div className="flex-1 relative">
                                                                                                                                                <Input
                                                                                                                                                                  placeholder="Type your question here (e.g., Solve 2x + 5 = 15)"
                                                                                                                                                                  value={query}
                                                                                                                                                                  onChange={(e) => setQuery(e.target.value)}
                                                                                                                                                                  className="pr-12 h-12 text-lg"
                                                                                                                                                                  onKeyDown={(e) => e.key === 'Enter' && handleSolve()}
                                                                                                                                                />
                                                                                                                                                <Button
                                                                                                                                                                  size="icon"
                                                                                                                                                                  variant="ghost"
                                                                                                                                                                  className="absolute right-2 top-1/2 -translate-y-1/2"
                                                                                                                                                                  onClick={handleSolve}
                                                                                                                                                                  disabled={isAnalyzing || !query.trim()}
                                                                                                                                                >
                                                                                                                                                                  {isAnalyzing ? <Loader2 className="w-5 h-5 animate-spin" /> : <Send className="w-5 h-5" />}
                                                                                                                                                </Button>
                                                                                                                              </div>
                                                                                                                              <div className="flex gap-2">
                                                                                                                                                <Button variant="outline" className="h-12 border-primary/30" onClick={handleFileSelect}>
                                                                                                                                                                  <Camera className="w-4 h-4 mr-2" /> Scan Photo
                                                                                                                                                </Button>
                                                                                                                                                <input
                                                                                                                                                                  type="file"
                                                                                                                                                                  ref={fileInputRef}
                                                                                                                                                                  className="hidden"
                                                                                                                                                                  accept="image/*"
                                                                                                                                                                  onChange={handleFileChange}
                                                                                                                                                />
                                                                                                                              </div>
                                                                                                            </div>
                                                                                          </CardContent>
                                                                        </Card>

                                                                        {isAnalyzing && (
                                                                                          <div className="md:col-span-12 py-20 flex flex-col items-center gap-4 text-center">
                                                                                                            <div className="w-16 h-16 rounded-full border-4 border-primary border-t-transparent animate-spin" />
                                                                                                            <div className="space-y-1">
                                                                                                                              <p className="text-xl font-bold">Analyzing your question...</p>
                                                                                                                              <p className="text-muted-foreground text-sm italic">AI is extracting text and calculating solutions</p>
                                                                                                            </div>
                                                                                          </div>
                                                                        )}

                                                                        {solution && !isAnalyzing && (
                                                                                          <Card className="md:col-span-12 border-none shadow-xl bg-card overflow-hidden">
                                                                                                            <CardHeader className="bg-primary text-primary-foreground p-8">
                                                                                                                              <div className="flex items-center gap-3 opacity-80 text-xs font-bold uppercase tracking-wider mb-2">
                                                                                                                                                <CheckCircle2 className="w-4 h-4" /> Solution Generated
                                                                                                                              </div>
                                                                                                                              <CardTitle className="text-2xl font-black">"{solution.question}"</CardTitle>
                                                                                                            </CardHeader>
                                                                                                            <CardContent className="p-0">
                                                                                                                              <div className="p-8 space-y-8">
                                                                                                                                                {solution.steps.map((step, i) => (
                                                                                                                                                                  <div key={i} className="flex gap-6 relative">
                                                                                                                                                                                    {i !== solution.steps.length - 1 && (
                                                                                                                                                                                                      <div className="absolute left-5 top-10 w-0.5 h-full bg-border" />
                                                                                                                                                                                    )}
                                                                                                                                                                                    <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center text-primary font-bold shrink-0 z-10">
                                                                                                                                                                                                      {i + 1}
                                                                                                                                                                                    </div>
                                                                                                                                                                                    <div className="space-y-2 pt-1">
                                                                                                                                                                                                      <h4 className="font-bold text-lg">{step.title}</h4>
                                                                                                                                                                                                      <p className="text-muted-foreground leading-relaxed">{step.detail}</p>
                                                                                                                                                                                    </div>
                                                                                                                                                                  </div>
                                                                                                                                                ))}
                                                                                                                              </div>
                                                                                                                              <div className="bg-muted/30 p-8 border-t flex items-center justify-between">
                                                                                                                                                <p className="text-sm text-muted-foreground">Was this solution helpful?</p>
                                                                                                                                                <div className="flex gap-2">
                                                                                                                                                                  <Button variant="ghost" size="sm">No, explain more</Button>
                                                                                                                                                                  <Button size="sm">Yes, thank you!</Button>
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            </CardContent>
                                                                                          </Card>
                                                                        )}
                                                      </div>
                                    </div>
                  )
}
