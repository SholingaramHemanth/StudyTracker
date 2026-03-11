"use client"

import { useState } from 'react'
import { useStudy, Flashcard } from '@/lib/study-context'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Plus, RotateCcw, Brain, Check, X, ChevronRight, ChevronLeft } from 'lucide-react'
import { Input } from '@/components/ui/input'
import { cn } from '@/lib/utils'

export function FlashcardsPage() {
                  const { flashcards, addFlashcard, reviewFlashcard, user } = useStudy()
                  const [isAdding, setIsAdding] = useState(false)
                  const [newFront, setNewFront] = useState('')
                  const [newBack, setNewBack] = useState('')
                  const [newSubject, setNewSubject] = useState('')

                  const [currentIndex, setCurrentIndex] = useState(0)
                  const [isFlipped, setIsFlipped] = useState(false)

                  const handleCreate = () => {
                                    if (!newFront || !newBack) return
                                    addFlashcard({
                                                      subjectId: newSubject || 'general',
                                                      front: newFront,
                                                      back: newBack
                                    })
                                    setNewFront('')
                                    setNewBack('')
                                    setIsAdding(false)
                  }

                  const handleReview = (quality: number) => {
                                    reviewFlashcard(flashcards[currentIndex].id, quality)
                                    setIsFlipped(false)
                                    if (currentIndex < flashcards.length - 1) {
                                                      setCurrentIndex(currentIndex + 1)
                                    } else {
                                                      setCurrentIndex(0)
                                    }
                  }

                  return (
                                    <div className="max-w-4xl mx-auto space-y-8">
                                                      <div className="flex items-center justify-between">
                                                                        <div>
                                                                                          <h2 className="text-3xl font-bold tracking-tight">Active Recall Flashcards</h2>
                                                                                          <p className="text-muted-foreground">Master concepts using spaced repetition.</p>
                                                                        </div>
                                                                        <Button onClick={() => setIsAdding(!isAdding)}>
                                                                                          {isAdding ? 'Cancel' : <><Plus className="w-4 h-4 mr-2" /> Create Card</>}
                                                                        </Button>
                                                      </div>

                                                      {isAdding && (
                                                                        <Card className="border-2 border-dashed border-primary/30 bg-muted/20">
                                                                                          <CardContent className="p-6 space-y-4">
                                                                                                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                                                                                              <div className="space-y-2">
                                                                                                                                                <label className="text-xs font-bold uppercase tracking-wider opacity-60">Front (Question/Term)</label>
                                                                                                                                                <Input value={newFront} onChange={(e) => setNewFront(e.target.value)} placeholder="e.g. What is Phishing?" />
                                                                                                                              </div>
                                                                                                                              <div className="space-y-2">
                                                                                                                                                <label className="text-xs font-bold uppercase tracking-wider opacity-60">Back (Answer/Definition)</label>
                                                                                                                                                <Input value={newBack} onChange={(e) => setNewBack(e.target.value)} placeholder="e.g. An attack to steal credentials." />
                                                                                                                              </div>
                                                                                                            </div>
                                                                                                            <div className="flex justify-end gap-2">
                                                                                                                              <Button variant="ghost" onClick={() => setIsAdding(false)}>Discard</Button>
                                                                                                                              <Button onClick={handleCreate}>Save Flashcard</Button>
                                                                                                            </div>
                                                                                          </CardContent>
                                                                        </Card>
                                                      )}

                                                      {flashcards.length > 0 ? (
                                                                        <div className="space-y-8">
                                                                                          <div className="flex flex-col items-center gap-12 pt-10">
                                                                                                            <div
                                                                                                                              className="relative w-full max-w-xl aspect-[3/2] cursor-pointer group rounded-[2rem] [perspective:1000px]"
                                                                                                                              onClick={() => setIsFlipped(!isFlipped)}
                                                                                                            >
                                                                                                                              <div className={cn(
                                                                                                                                                "w-full h-full transition-all duration-500 [transform-style:preserve-3d] relative shadow-2xl rounded-[2rem]",
                                                                                                                                                isFlipped ? "[transform:rotateY(180deg)]" : ""
                                                                                                                              )}>
                                                                                                                                                {/* Front */}
                                                                                                                                                <div className="absolute inset-0 bg-primary text-primary-foreground rounded-[2rem] flex flex-col items-center justify-center p-12 [backface-visibility:hidden]">
                                                                                                                                                                  <p className="text-xs font-black uppercase tracking-widest opacity-50 mb-4">Question</p>
                                                                                                                                                                  <p className="text-3xl font-bold text-center leading-tight">{flashcards[currentIndex].front}</p>
                                                                                                                                                                  <p className="absolute bottom-10 text-[10px] font-bold uppercase tracking-[0.2em] opacity-40">Tap to Reveal Answer</p>
                                                                                                                                                </div>
                                                                                                                                                {/* Back */}
                                                                                                                                                <div className="absolute inset-0 bg-white text-slate-900 border-4 border-primary/20 rounded-[2rem] flex flex-col items-center justify-center p-12 [backface-visibility:hidden] [transform:rotateY(180deg)] shadow-inner">
                                                                                                                                                                  <p className="text-xs font-black uppercase tracking-widest text-primary opacity-50 mb-4">Definition / Answer</p>
                                                                                                                                                                  <p className="text-2xl font-medium text-center leading-relaxed italic">"{flashcards[currentIndex].back}"</p>
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            </div>

                                                                                                            {isFlipped && (
                                                                                                                              <div className="flex flex-col items-center gap-6 animate-in fade-in slide-in-from-top-4">
                                                                                                                                                <p className="text-sm font-bold text-muted-foreground uppercase tracking-widest">How well did you know this?</p>
                                                                                                                                                <div className="flex gap-3">
                                                                                                                                                                  <Button size="lg" variant="outline" className="h-16 w-24 border-rose-200 hover:bg-rose-50 text-rose-600 rounded-2xl" onClick={() => handleReview(1)}>
                                                                                                                                                                                    <X className="w-6 h-6" />
                                                                                                                                                                  </Button>
                                                                                                                                                                  <Button size="lg" variant="outline" className="h-16 w-24 border-blue-200 hover:bg-blue-50 text-blue-600 rounded-2xl" onClick={() => handleReview(3)}>
                                                                                                                                                                                    <RotateCcw className="w-6 h-6" />
                                                                                                                                                                  </Button>
                                                                                                                                                                  <Button size="lg" variant="outline" className="h-16 w-24 border-emerald-200 hover:bg-emerald-50 text-emerald-600 rounded-2xl" onClick={() => handleReview(5)}>
                                                                                                                                                                                    <Check className="w-6 h-6" />
                                                                                                                                                                  </Button>
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            )}

                                                                                                            <div className="flex items-center gap-6 pt-4">
                                                                                                                              <Button variant="ghost" size="icon" disabled={currentIndex === 0} onClick={() => setCurrentIndex(currentIndex - 1)}>
                                                                                                                                                <ChevronLeft className="w-6 h-6" />
                                                                                                                              </Button>
                                                                                                                              <span className="text-sm font-black tabular-nums">{currentIndex + 1} / {flashcards.length}</span>
                                                                                                                              <Button variant="ghost" size="icon" disabled={currentIndex === flashcards.length - 1} onClick={() => setCurrentIndex(currentIndex + 1)}>
                                                                                                                                                <ChevronRight className="w-6 h-6" />
                                                                                                                              </Button>
                                                                                                            </div>
                                                                                          </div>
                                                                        </div>
                                                      ) : (
                                                                        <div className="py-20 text-center space-y-4 opacity-50">
                                                                                          <Brain className="w-16 h-16 mx-auto" />
                                                                                          <p className="text-xl font-medium">No flashcards yet. Create your first one!</p>
                                                                        </div>
                                                      )}
                                    </div>
                  )
}
