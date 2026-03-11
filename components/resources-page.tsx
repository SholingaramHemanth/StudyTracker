"use client"

import { useState } from 'react'
import { useStudy } from '@/lib/study-context'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { FileText, Download, TrendingUp, AlertCircle, Bookmark, Search } from 'lucide-react'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'

interface QuestionPaper {
                  id: string
                  subject: string
                  year: string
                  type: 'Mid-term' | 'Final' | 'Sessional'
                  questions: string[]
                  repeatedCount: number
}

const MOCK_PAPERS: QuestionPaper[] = [
                  {
                                    id: '1',
                                    subject: 'Operating Systems',
                                    year: '2023',
                                    type: 'Final',
                                    questions: ["What is a deadlock?", "Explain Banker's Algorithm", "Difference between Paging and Segmentation"],
                                    repeatedCount: 12
                  },
                  {
                                    id: '2',
                                    subject: 'Computer Networks',
                                    year: '2022',
                                    type: 'Final',
                                    questions: ["Explain OSI Layers", "What is TCP 3-way handshake?", "IPv4 vs IPv6"],
                                    repeatedCount: 8
                  },
                  {
                                    id: '3',
                                    subject: 'DBMS',
                                    year: '2023',
                                    type: 'Mid-term',
                                    questions: ["Explain ACID properties", "What is Normalization?", "SQL Join types"],
                                    repeatedCount: 15
                  }
]

export function ResourcesPage() {
                  const { user } = useStudy()
                  const [search, setSearch] = useState('')

                  const filteredPapers = MOCK_PAPERS.filter(p =>
                                    p.subject.toLowerCase().includes(search.toLowerCase()) ||
                                    p.year.includes(search)
                  )

                  return (
                                    <div className="max-w-5xl mx-auto space-y-8">
                                                      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
                                                                        <div className="space-y-2">
                                                                                          <h2 className="text-3xl font-bold tracking-tight">Previous Year Content</h2>
                                                                                          <p className="text-muted-foreground">Access bank of question papers and high-yield topics.</p>
                                                                        </div>
                                                                        <div className="relative w-full md:w-64">
                                                                                          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                                                                                          <Input
                                                                                                            placeholder="Search subject or year..."
                                                                                                            className="pl-10"
                                                                                                            value={search}
                                                                                                            onChange={(e) => setSearch(e.target.value)}
                                                                                          />
                                                                        </div>
                                                      </div>

                                                      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                                                                        <div className="lg:col-span-2 space-y-6">
                                                                                          <div className="flex items-center gap-2 text-sm font-bold uppercase tracking-widest text-primary">
                                                                                                            <TrendingUp className="w-4 h-4" /> Most Repeated Questions
                                                                                          </div>
                                                                                          <Card className="border-none shadow-sm bg-primary/5">
                                                                                                            <CardContent className="p-0">
                                                                                                                              {filteredPapers.slice(0, 3).map((paper, i) => (
                                                                                                                                                <div key={paper.id} className="p-6 border-b last:border-0 hover:bg-primary/10 transition-colors">
                                                                                                                                                                  <div className="flex items-start justify-between mb-4">
                                                                                                                                                                                    <div className="space-y-1">
                                                                                                                                                                                                      <h4 className="font-bold text-lg">{paper.subject}</h4>
                                                                                                                                                                                                      <div className="flex gap-2">
                                                                                                                                                                                                                        <Badge variant="secondary" className="text-[10px]">{paper.year}</Badge>
                                                                                                                                                                                                                        <Badge variant="outline" className="text-[10px]">{paper.type}</Badge>
                                                                                                                                                                                                      </div>
                                                                                                                                                                                    </div>
                                                                                                                                                                                    <Button size="sm" variant="ghost" className="h-8 px-2">
                                                                                                                                                                                                      <Download className="w-4 h-4 mr-2" /> PDF
                                                                                                                                                                                    </Button>
                                                                                                                                                                  </div>
                                                                                                                                                                  <ul className="space-y-2">
                                                                                                                                                                                    {paper.questions.map((q, j) => (
                                                                                                                                                                                                      <li key={j} className="text-sm flex gap-3 text-muted-foreground">
                                                                                                                                                                                                                        <Bookmark className="w-4 h-4 shrink-0 text-amber-500" />
                                                                                                                                                                                                                        {q}
                                                                                                                                                                                                      </li>
                                                                                                                                                                                    ))}
                                                                                                                                                                  </ul>
                                                                                                                                                </div>
                                                                                                                              ))}
                                                                                                            </CardContent>
                                                                                          </Card>
                                                                        </div>

                                                                        <div className="space-y-6">
                                                                                          <div className="flex items-center gap-2 text-sm font-bold uppercase tracking-widest text-orange-600">
                                                                                                            <AlertCircle className="w-4 h-4" /> Exam Strategy
                                                                                          </div>
                                                                                          <Card className="bg-orange-50 border-orange-100 dark:bg-orange-950/20 dark:border-orange-500/20">
                                                                                                            <CardHeader>
                                                                                                                              <CardTitle className="text-orange-700 dark:text-orange-400">Repeated Analysis</CardTitle>
                                                                                                            </CardHeader>
                                                                                                            <CardContent className="space-y-4">
                                                                                                                              <div className="p-4 bg-white dark:bg-black/40 rounded-xl border border-orange-200 dark:border-orange-800 flex items-center justify-between">
                                                                                                                                                <span className="text-xs font-bold">Deadlocks</span>
                                                                                                                                                <Badge className="bg-orange-600">85% Likely</Badge>
                                                                                                                              </div>
                                                                                                                              <div className="p-4 bg-white dark:bg-black/40 rounded-xl border border-orange-200 dark:border-orange-800 flex items-center justify-between">
                                                                                                                                                <span className="text-xs font-bold">OSI Model</span>
                                                                                                                                                <Badge className="bg-orange-600">72% Likely</Badge>
                                                                                                                              </div>
                                                                                                                              <p className="text-xs text-orange-600/80 leading-relaxed">
                                                                                                                                                Our AI analyzed 10 years of papers. Topics marked with high likelihood appear in 8 out of every 10 exams.
                                                                                                                              </p>
                                                                                                            </CardContent>
                                                                                          </Card>
                                                                        </div>
                                                      </div>
                                    </div>
                  )
}
