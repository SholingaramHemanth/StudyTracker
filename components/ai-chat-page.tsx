"use client"

import { useState, useRef, useEffect } from 'react'
import { useStudy } from '@/lib/study-context'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { ScrollArea } from '@/components/ui/scroll-area'
import { cn } from '@/lib/utils'
import {
                  Bot,
                  Send,
                  User,
                  Sparkles,
                  Timer,
                  BookOpen,
                  AlertCircle
} from 'lucide-react'

interface Message {
                  id: string
                  role: 'user' | 'assistant'
                  content: string
                  timestamp: Date
                  isAction?: boolean
}

export function AIChatPage() {
                  const { user, setTimerConfig, startTimer, timer } = useStudy()
                  const [messages, setMessages] = useState<Message[]>([
                                    {
                                                      id: '1',
                                                      role: 'assistant',
                                                      content: `Hello ${user?.name}! I'm your Study Assistant. I can help you focus, set study timers, and answer academic questions. How can I help you today?`,
                                                      timestamp: new Date()
                                    }
                  ])
                  const [input, setInput] = useState('')
                  const [isTyping, setIsTyping] = useState(false)
                  const scrollAreaRef = useRef<HTMLDivElement>(null)

                  useEffect(() => {
                                    if (scrollAreaRef.current) {
                                                      const scrollContainer = scrollAreaRef.current.querySelector('[data-radix-scroll-area-viewport]')
                                                      if (scrollContainer) {
                                                                        scrollContainer.scrollTop = scrollContainer.scrollHeight
                                                      }
                                    }
                  }, [messages, isTyping])

                  const handleSend = async () => {
                                    if (!input.trim() || isTyping) return

                                    const userMessage: Message = {
                                                      id: Date.now().toString(),
                                                      role: 'user',
                                                      content: input,
                                                      timestamp: new Date()
                                    }

                                    setMessages(prev => [...prev, userMessage])
                                    setInput('')
                                    setIsTyping(true)

                                    // Simulate AI response
                                    setTimeout(() => {
                                                      const response = generateAIResponse(input)
                                                      setMessages(prev => [...prev, response])
                                                      setIsTyping(false)
                                    }, 1000)
                  }

                  const generateAIResponse = (text: string): Message => {
                                    const lowerText = text.toLowerCase()
                                    const studyKeywords = ['study', 'learn', 'math', 'science', 'quiz', 'timer', 'exam', 'book', 'test', 'homework', 'physics', 'chemistry', 'biology', 'history']

                                    // Check if it's a study-related query
                                    const isStudyRelated = studyKeywords.some(keyword => lowerText.includes(keyword)) || lowerText.length < 5

                                    if (!isStudyRelated) {
                                                      return {
                                                                        id: Date.now().toString(),
                                                                        role: 'assistant',
                                                                        content: "I'm sorry, I'm designed to help you with your studies only. Please ask me something related to your learning journey, or ask me to set a study timer!",
                                                                        timestamp: new Date()
                                                      }
                                    }

                                    // Timer logic
                                    if (lowerText.includes('timer') || lowerText.includes('start') || lowerText.includes('set')) {
                                                      // Try to find minutes
                                                      const minMatch = text.match(/(\d+)\s*(minutes|min|m)/i)
                                                      const minutes = minMatch ? parseInt(minMatch[1]) : 25

                                                      // Try to find subject
                                                      const subject = user?.subjects?.find(s => lowerText.includes(s.name.toLowerCase()))

                                                      if (subject) {
                                                                        setTimerConfig({ subjectId: subject.id, duration: minutes, type: 'custom' })
                                                                        setTimeout(() => startTimer(), 500)
                                                                        return {
                                                                                          id: Date.now().toString(),
                                                                                          role: 'assistant',
                                                                                          content: `Perfect! I've set a ${minutes}-minute study timer for ${subject.name} and started it for you. Good luck!`,
                                                                                          timestamp: new Date(),
                                                                                          isAction: true
                                                                        }
                                                      } else if (lowerText.includes('timer')) {
                                                                        setTimerConfig({ duration: minutes, type: 'custom' })
                                                                        return {
                                                                                          id: Date.now().toString(),
                                                                                          role: 'assistant',
                                                                                          content: `I've prepared a ${minutes}-minute timer for you. Please select a subject so we can get started!`,
                                                                                          timestamp: new Date(),
                                                                                          isAction: true
                                                                        }
                                                      }
                                    }

                                    // Default study response
                                    const studyResponses = [
                                                      "That's a great area to focus on! Have you tried breaking down the topic into smaller chunks?",
                                                      "Consistency is key! Even 25 minutes of focused study can make a big difference.",
                                                      "Don't forget to take short breaks to keep your mind fresh. Would you like me to set a Pomodoro timer?",
                                                      "I'm here to support your learning goals. You're doing a great job staying focused!",
                                                      "If you're finding this topic difficult, try explaining it to someone else (or me!) to reinforce your understanding."
                                    ]

                                    return {
                                                      id: Date.now().toString(),
                                                      role: 'assistant',
                                                      content: studyResponses[Math.floor(Math.random() * studyResponses.length)],
                                                      timestamp: new Date()
                                    }
                  }

                  return (
                                    <div className="max-w-4xl mx-auto h-[calc(100vh-12rem)] flex flex-col gap-4">
                                                      <div className="flex items-center gap-3">
                                                                        <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center">
                                                                                          <Bot className="w-6 h-6 text-primary" />
                                                                        </div>
                                                                        <div>
                                                                                          <h2 className="text-2xl font-bold text-foreground">AI Study Assistant</h2>
                                                                                          <p className="text-sm text-muted-foreground flex items-center gap-1">
                                                                                                            <Sparkles className="w-3 h-3 text-primary" />
                                                                                                            Always here to help you stay focused
                                                                                          </p>
                                                                        </div>
                                                      </div>

                                                      <Card className="flex-1 border-border/50 flex flex-col overflow-hidden">
                                                                        <ScrollArea className="flex-1 p-4" ref={scrollAreaRef}>
                                                                                          <div className="space-y-4">
                                                                                                            {messages.map((message) => (
                                                                                                                              <div
                                                                                                                                                key={message.id}
                                                                                                                                                className={cn(
                                                                                                                                                                  "flex items-start gap-3 max-w-[80%]",
                                                                                                                                                                  message.role === 'user' ? "ml-auto flex-row-reverse" : "mr-auto"
                                                                                                                                                )}
                                                                                                                              >
                                                                                                                                                <div className={cn(
                                                                                                                                                                  "w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 mt-1",
                                                                                                                                                                  message.role === 'user' ? "bg-muted" : "bg-primary/20 text-primary"
                                                                                                                                                )}>
                                                                                                                                                                  {message.role === 'user' ? <User className="w-4 h-4" /> : <Bot className="w-4 h-4" />}
                                                                                                                                                </div>
                                                                                                                                                <div className={cn(
                                                                                                                                                                  "p-3 rounded-2xl text-sm",
                                                                                                                                                                  message.role === 'user'
                                                                                                                                                                                    ? "bg-primary text-primary-foreground rounded-tr-none"
                                                                                                                                                                                    : "bg-muted text-foreground rounded-tl-none",
                                                                                                                                                                  message.isAction && "border-2 border-primary/20 bg-primary/5"
                                                                                                                                                )}>
                                                                                                                                                                  {message.content}
                                                                                                                                                                  {message.isAction && message.role === 'assistant' && (
                                                                                                                                                                                    <div className="mt-2 pt-2 border-t border-primary/10 flex items-center gap-2 text-xs font-medium text-primary">
                                                                                                                                                                                                      <Timer className="w-3 h-3" />
                                                                                                                                                                                                      Timer synced with dashboard
                                                                                                                                                                                    </div>
                                                                                                                                                                  )}
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            ))}
                                                                                                            {isTyping && (
                                                                                                                              <div className="flex items-start gap-3 mr-auto">
                                                                                                                                                <div className="w-8 h-8 rounded-full bg-primary/20 text-primary flex items-center justify-center">
                                                                                                                                                                  <Bot className="w-4 h-4" />
                                                                                                                                                </div>
                                                                                                                                                <div className="bg-muted p-3 rounded-2xl rounded-tl-none flex gap-1 items-center h-10">
                                                                                                                                                                  <span className="w-1.5 h-1.5 bg-muted-foreground/40 rounded-full animate-bounce" />
                                                                                                                                                                  <span className="w-1.5 h-1.5 bg-muted-foreground/40 rounded-full animate-bounce [animation-delay:0.2s]" />
                                                                                                                                                                  <span className="w-1.5 h-1.5 bg-muted-foreground/40 rounded-full animate-bounce [animation-delay:0.4s]" />
                                                                                                                                                </div>
                                                                                                                              </div>
                                                                                                            )}
                                                                                          </div>
                                                                        </ScrollArea>

                                                                        <div className="p-4 border-t border-border bg-card">
                                                                                          <form
                                                                                                            onSubmit={(e) => { e.preventDefault(); handleSend(); }}
                                                                                                            className="flex gap-2"
                                                                                          >
                                                                                                            <Input
                                                                                                                              value={input}
                                                                                                                              onChange={(e) => setInput(e.target.value)}
                                                                                                                              placeholder="Ask me to set a timer or help with studies..."
                                                                                                                              className="flex-1 bg-background"
                                                                                                            />
                                                                                                            <Button type="submit" size="icon" disabled={!input.trim() || isTyping}>
                                                                                                                              <Send className="w-4 h-4" />
                                                                                                            </Button>
                                                                                          </form>
                                                                                          <div className="mt-2 flex items-center gap-4 text-[10px] text-muted-foreground uppercase tracking-wider font-semibold">
                                                                                                            <span>Commands:</span>
                                                                                                            <span className="hover:text-primary cursor-pointer" onClick={() => setInput("Set a 25 minute timer for math")}>"Set timer for 25m"</span>
                                                                                                            <span className="hover:text-primary cursor-pointer" onClick={() => setInput("Start studying science for 45 minutes")}>"Start studying science"</span>
                                                                                          </div>
                                                                        </div>
                                                      </Card>

                                                      <div className="p-3 rounded-xl bg-orange-500/5 border border-orange-500/10 flex gap-3 items-center">
                                                                        <AlertCircle className="w-5 h-5 text-orange-500 flex-shrink-0" />
                                                                        <p className="text-xs text-orange-600 font-medium">
                                                                                          Note: This AI assistant is strictly for study-related purposes. Off-topic conversations will be filtered.
                                                                        </p>
                                                      </div>
                                    </div>
                  )
}
