"use client"

import { useState } from 'react'
import { useStudy } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import { cn } from '@/lib/utils'
import {
  CheckCircle2,
  XCircle,
  ArrowRight,
  Trophy,
  RotateCcw,
  Clock
} from 'lucide-react'

interface Question {
  id: string
  question: string
  options: string[]
  correctAnswer: number
  explanation: string
}

const QUIZ_DATA: Record<string, Question[]> = {
  cyber: [
    {
      id: '1',
      question: 'What is phishing?',
      options: ['Malware attack', 'Social engineering attack', 'Firewall breach', 'Encryption method'],
      correctAnswer: 1,
      explanation: 'Phishing is a social engineering attack where attackers trick users into revealing sensitive information.',
    },
    {
      id: '2',
      question: 'Which protocol is used for secure web browsing?',
      options: ['HTTP', 'FTP', 'HTTPS', 'SMTP'],
      correctAnswer: 2,
      explanation: 'HTTPS (HTTP Secure) encrypts data between your browser and the website.',
    },
    {
      id: '3',
      question: 'What does a firewall do?',
      options: ['Encrypts files', 'Monitors network traffic', 'Creates backups', 'Compresses data'],
      correctAnswer: 1,
      explanation: 'A firewall monitors and controls incoming and outgoing network traffic based on security rules.',
    },
    {
      id: '4',
      question: 'What is two-factor authentication?',
      options: ['Using two passwords', 'Verifying identity with two methods', 'Logging in twice', 'Having two accounts'],
      correctAnswer: 1,
      explanation: 'Two-factor authentication requires two different verification methods for added security.',
    },
    {
      id: '5',
      question: 'What is ransomware?',
      options: ['Antivirus software', 'Malware that encrypts data for ransom', 'A type of firewall', 'Email filter'],
      correctAnswer: 1,
      explanation: 'Ransomware encrypts victim files and demands payment for the decryption key.',
    },
  ],
  os: [
    {
      id: '1',
      question: 'What is a process in operating systems?',
      options: ['A file', 'A running program', 'A hardware device', 'A network connection'],
      correctAnswer: 1,
      explanation: 'A process is an instance of a program that is being executed.',
    },
    {
      id: '2',
      question: 'What is virtual memory?',
      options: ['Extra RAM', 'Using disk space as RAM extension', 'Cloud storage', 'Cache memory'],
      correctAnswer: 1,
      explanation: 'Virtual memory uses disk space to extend available memory when RAM is full.',
    },
    {
      id: '3',
      question: 'What is a deadlock?',
      options: ['System crash', 'Processes waiting for each other indefinitely', 'Memory leak', 'CPU overload'],
      correctAnswer: 1,
      explanation: 'A deadlock occurs when two or more processes are waiting for each other to release resources.',
    },
    {
      id: '4',
      question: 'What scheduling algorithm gives equal time to all processes?',
      options: ['First Come First Serve', 'Round Robin', 'Shortest Job First', 'Priority Scheduling'],
      correctAnswer: 1,
      explanation: 'Round Robin allocates equal time slices to each process in a cyclic manner.',
    },
    {
      id: '5',
      question: 'What is the kernel?',
      options: ['A user application', 'The core of the OS', 'A file system', 'A network protocol'],
      correctAnswer: 1,
      explanation: 'The kernel is the core component of an OS that manages system resources.',
    },
  ],
  cn: [
    {
      id: '1',
      question: 'What layer does IP belong to in the OSI model?',
      options: ['Transport', 'Network', 'Data Link', 'Application'],
      correctAnswer: 1,
      explanation: 'IP operates at the Network layer (Layer 3) of the OSI model.',
    },
    {
      id: '2',
      question: 'What is a MAC address?',
      options: ['Network address', 'Physical hardware address', 'Email address', 'Website address'],
      correctAnswer: 1,
      explanation: 'A MAC address is a unique physical address assigned to network interfaces.',
    },
    {
      id: '3',
      question: 'What protocol resolves domain names to IP addresses?',
      options: ['HTTP', 'DNS', 'FTP', 'SMTP'],
      correctAnswer: 1,
      explanation: 'DNS (Domain Name System) translates domain names into IP addresses.',
    },
    {
      id: '4',
      question: 'What is the purpose of a router?',
      options: ['Store files', 'Forward packets between networks', 'Display websites', 'Send emails'],
      correctAnswer: 1,
      explanation: 'Routers forward data packets between different networks.',
    },
    {
      id: '5',
      question: 'Which protocol ensures reliable data delivery?',
      options: ['UDP', 'TCP', 'IP', 'ICMP'],
      correctAnswer: 1,
      explanation: 'TCP provides reliable, ordered, and error-checked delivery of data.',
    },
  ],
  dbms: [
    {
      id: '1',
      question: 'What does SQL stand for?',
      options: ['Simple Query Language', 'Structured Query Language', 'System Query Language', 'Standard Query Language'],
      correctAnswer: 1,
      explanation: 'SQL stands for Structured Query Language, used to manage databases.',
    },
    {
      id: '2',
      question: 'What is a primary key?',
      options: ['Any column', 'Unique identifier for records', 'Foreign table link', 'Index type'],
      correctAnswer: 1,
      explanation: 'A primary key uniquely identifies each record in a database table.',
    },
    {
      id: '3',
      question: 'What is normalization?',
      options: ['Data backup', 'Organizing data to reduce redundancy', 'Data encryption', 'Query optimization'],
      correctAnswer: 1,
      explanation: 'Normalization organizes tables to minimize data redundancy and dependency.',
    },
    {
      id: '4',
      question: 'What type of join returns all rows from both tables?',
      options: ['Inner Join', 'Left Join', 'Full Outer Join', 'Cross Join'],
      correctAnswer: 2,
      explanation: 'A Full Outer Join returns all rows when there is a match in either table.',
    },
    {
      id: '5',
      question: 'What is ACID in databases?',
      options: ['A data type', 'Transaction properties', 'Query language', 'Index type'],
      correctAnswer: 1,
      explanation: 'ACID represents Atomicity, Consistency, Isolation, and Durability properties.',
    },
  ],
  math: [
    {
      id: '1',
      question: 'What is 15 x 12?',
      options: ['170', '180', '190', '200'],
      correctAnswer: 1,
      explanation: '15 x 12 = 180',
    },
    {
      id: '2',
      question: 'What is the square root of 144?',
      options: ['10', '11', '12', '13'],
      correctAnswer: 2,
      explanation: 'The square root of 144 is 12 because 12 x 12 = 144.',
    },
    {
      id: '3',
      question: 'What is 25% of 200?',
      options: ['25', '40', '50', '75'],
      correctAnswer: 2,
      explanation: '25% of 200 = 0.25 x 200 = 50',
    },
    {
      id: '4',
      question: 'Solve: 3x + 7 = 22. What is x?',
      options: ['3', '4', '5', '6'],
      correctAnswer: 2,
      explanation: '3x = 22 - 7 = 15, so x = 15/3 = 5',
    },
    {
      id: '5',
      question: 'What is the area of a rectangle with length 8 and width 5?',
      options: ['13', '26', '40', '80'],
      correctAnswer: 2,
      explanation: 'Area = length x width = 8 x 5 = 40',
    },
  ],
  physics: [
    {
      id: '1',
      question: 'What is the unit of force?',
      options: ['Joule', 'Newton', 'Watt', 'Pascal'],
      correctAnswer: 1,
      explanation: 'The Newton (N) is the SI unit of force.',
    },
    {
      id: '2',
      question: 'What is the speed of light?',
      options: ['300,000 km/s', '150,000 km/s', '450,000 km/s', '600,000 km/s'],
      correctAnswer: 0,
      explanation: 'Light travels at approximately 300,000 kilometers per second in a vacuum.',
    },
    {
      id: '3',
      question: 'Which law states that for every action there is an equal and opposite reaction?',
      options: ['Newton\'s First Law', 'Newton\'s Second Law', 'Newton\'s Third Law', 'Law of Gravity'],
      correctAnswer: 2,
      explanation: 'Newton\'s Third Law describes the action-reaction pair.',
    },
    {
      id: '4',
      question: 'What instrument measures electric current?',
      options: ['Voltmeter', 'Ammeter', 'Ohmmeter', 'Barometer'],
      correctAnswer: 1,
      explanation: 'An ammeter is used to measure the current flowing through a circuit.',
    },
    {
      id: '5',
      question: 'What is the most common state of matter in the universe?',
      options: ['Solid', 'Liquid', 'Gas', 'Plasma'],
      correctAnswer: 3,
      explanation: 'Plasma is the most common state of matter, making up stars and interstellar space.',
    },
  ],
  chemistry: [
    {
      id: '1',
      question: 'What is the atomic number of Hydrogen?',
      options: ['1', '2', '3', '4'],
      correctAnswer: 0,
      explanation: 'Hydrogen is the first element with atomic number 1.',
    },
    {
      id: '2',
      question: 'What is the pH of pure water?',
      options: ['5', '6', '7', '8'],
      correctAnswer: 2,
      explanation: 'Pure water has a neutral pH of 7.',
    },
    {
      id: '3',
      question: 'Which gas is most abundant in Earth\'s atmosphere?',
      options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Argon'],
      correctAnswer: 2,
      explanation: 'Nitrogen makes up approximately 78% of the Earth\'s atmosphere.',
    },
    {
      id: '4',
      question: 'What is common table salt?',
      options: ['Sodium Chloride', 'Potassium Chloride', 'Calcium Carbonate', 'Magnesium Sulfate'],
      correctAnswer: 0,
      explanation: 'Table salt is composed of Sodium Chloride (NaCl).',
    },
    {
      id: '5',
      question: 'What is the chemical symbol for Gold?',
      options: ['Gd', 'Go', 'Ag', 'Au'],
      correctAnswer: 3,
      explanation: 'Au (from Latin \'Aurum\') is the symbol for Gold.',
    },
  ],
  science: [
    {
      id: '1',
      question: 'Which part of the cell is known as the powerhouse?',
      options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Vacuole'],
      correctAnswer: 1,
      explanation: 'Mitochondria generate most of the cell\'s supply of adenosine triphosphate (ATP).',
    },
    {
      id: '2',
      question: 'What is the largest organ in the human body?',
      options: ['Liver', 'Brain', 'Skin', 'Heart'],
      correctAnswer: 2,
      explanation: 'The skin is the largest organ by surface area and weight.',
    },
    {
      id: '3',
      question: 'What gas do plants absorb during photosynthesis?',
      options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
      correctAnswer: 1,
      explanation: 'Plants take in carbon dioxide and release oxygen during photosynthesis.',
    },
    {
      id: '4',
      question: 'How many planets are in our solar system?',
      options: ['7', '8', '9', '10'],
      correctAnswer: 1,
      explanation: 'There are 8 recognized planets in our solar system.',
    },
    {
      id: '5',
      question: 'What is the hardest natural substance on Earth?',
      options: ['Gold', 'Iron', 'Diamond', 'Quartz'],
      correctAnswer: 2,
      explanation: 'Diamond is the hardest known natural material.',
    },
  ],
  default: [
    {
      id: '1',
      question: 'What is the capital of France?',
      options: ['London', 'Paris', 'Berlin', 'Madrid'],
      correctAnswer: 1,
      explanation: 'Paris is the capital city of France.',
    },
    {
      id: '2',
      question: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctAnswer: 1,
      explanation: 'Mars appears red due to iron oxide on its surface.',
    },
    {
      id: '3',
      question: 'What is H2O commonly known as?',
      options: ['Oxygen', 'Hydrogen', 'Water', 'Carbon dioxide'],
      correctAnswer: 2,
      explanation: 'H2O is the chemical formula for water.',
    },
    {
      id: '4',
      question: 'How many continents are there on Earth?',
      options: ['5', '6', '7', '8'],
      correctAnswer: 2,
      explanation: 'Earth has 7 continents: Africa, Antarctica, Asia, Australia, Europe, North America, and South America.',
    },
    {
      id: '5',
      question: 'What is the largest mammal in the world?',
      options: ['Elephant', 'Blue Whale', 'Giraffe', 'Shark'],
      correctAnswer: 1,
      explanation: 'The Blue Whale is the largest mammal and animal on Earth.',
    },
  ],
}

export function QuizPage() {
  const { user, addQuizResult } = useStudy()
  const [selectedSubject, setSelectedSubject] = useState<string | null>(null)
  const [quizStarted, setQuizStarted] = useState(false)
  const [currentQuestion, setCurrentQuestion] = useState(0)
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null)
  const [showResult, setShowResult] = useState(false)
  const [answers, setAnswers] = useState<(number | null)[]>([])
  const [startTime, setStartTime] = useState<number>(0)
  const [quizCompleted, setQuizCompleted] = useState(false)

  const getQuestions = (): Question[] => {
    if (!selectedSubject) return QUIZ_DATA.default
    return QUIZ_DATA[selectedSubject] || QUIZ_DATA.default
  }

  const questions = getQuestions()

  const startQuiz = () => {
    setQuizStarted(true)
    setCurrentQuestion(0)
    setSelectedAnswer(null)
    setShowResult(false)
    setAnswers([])
    setQuizCompleted(false)
    setStartTime(Date.now())
  }

  const handleAnswerSelect = (index: number) => {
    if (showResult) return
    setSelectedAnswer(index)
  }

  const handleSubmitAnswer = () => {
    if (selectedAnswer === null) return
    setShowResult(true)
    setAnswers([...answers, selectedAnswer])
  }

  const handleNextQuestion = () => {
    if (currentQuestion < questions.length - 1) {
      setCurrentQuestion(currentQuestion + 1)
      setSelectedAnswer(null)
      setShowResult(false)
    } else {
      // Quiz completed
      const timeTaken = Math.round((Date.now() - startTime) / 1000)
      const correctAnswers = answers.filter(
        (a, i) => i < questions.length && a === questions[i].correctAnswer
      ).length

      if (selectedSubject) {
        addQuizResult({
          subjectId: selectedSubject,
          date: new Date().toISOString().split('T')[0],
          totalQuestions: questions.length,
          correctAnswers,
          timeTaken,
        })
      }

      setQuizCompleted(true)
    }
  }

  const getScore = () => {
    const correctAnswers = answers.filter(
      (a, i) => i < questions.length && a === questions[i].correctAnswer
    ).length
    return {
      correct: correctAnswers,
      total: questions.length,
      percentage: Math.round((correctAnswers / questions.length) * 100),
    }
  }

  if (!quizStarted) {
    return (
      <div className="max-w-4xl mx-auto space-y-6">
        <div>
          <h2 className="text-2xl font-bold text-foreground mb-2">Daily Quizzes</h2>
          <p className="text-muted-foreground">Test your knowledge and track your progress</p>
        </div>

        <Card className="border-border/50">
          <CardHeader>
            <CardTitle>Select Subject</CardTitle>
            <CardDescription>Choose a subject to start your quiz</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
              {user?.subjects?.map((subject) => (
                <button
                  key={subject.id}
                  onClick={() => setSelectedSubject(subject.id)}
                  className={cn(
                    "p-6 rounded-xl border-2 text-center transition-all hover:border-primary/50",
                    selectedSubject === subject.id
                      ? "border-primary bg-primary/5"
                      : "border-border bg-card"
                  )}
                >
                  <span className="text-3xl mb-3 block">{subject.icon}</span>
                  <span className="font-medium text-foreground">{subject.name}</span>
                  <p className="text-xs text-muted-foreground mt-1">5 Questions</p>
                </button>
              ))}
            </div>

            <div className="mt-6 flex justify-center">
              <Button
                size="lg"
                onClick={startQuiz}
                disabled={!selectedSubject}
                className="gap-2"
              >
                Start Quiz <ArrowRight className="w-4 h-4" />
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    )
  }

  if (quizCompleted) {
    const score = getScore()
    return (
      <div className="max-w-2xl mx-auto">
        <Card className="border-border/50">
          <CardContent className="pt-8 pb-8 text-center">
            <div className={cn(
              "w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6",
              score.percentage >= 80 ? "bg-success/10" :
                score.percentage >= 50 ? "bg-warning/10" : "bg-destructive/10"
            )}>
              <Trophy className={cn(
                "w-10 h-10",
                score.percentage >= 80 ? "text-success" :
                  score.percentage >= 50 ? "text-warning" : "text-destructive"
              )} />
            </div>

            <h2 className="text-2xl font-bold text-foreground mb-2">Quiz Completed!</h2>
            <p className="text-muted-foreground mb-8">
              {score.percentage >= 80 ? 'Excellent work!' :
                score.percentage >= 50 ? 'Good effort!' : 'Keep practicing!'}
            </p>

            <div className="grid grid-cols-3 gap-4 mb-8">
              <div className="p-4 rounded-lg bg-muted">
                <p className="text-2xl font-bold text-foreground">{score.correct}</p>
                <p className="text-sm text-muted-foreground">Correct</p>
              </div>
              <div className="p-4 rounded-lg bg-muted">
                <p className="text-2xl font-bold text-foreground">{score.total - score.correct}</p>
                <p className="text-sm text-muted-foreground">Wrong</p>
              </div>
              <div className="p-4 rounded-lg bg-muted">
                <p className="text-2xl font-bold text-foreground">{score.percentage}%</p>
                <p className="text-sm text-muted-foreground">Accuracy</p>
              </div>
            </div>

            <div className="flex gap-4 justify-center">
              <Button variant="outline" onClick={() => setQuizStarted(false)}>
                <RotateCcw className="w-4 h-4 mr-2" /> Try Another
              </Button>
              <Button onClick={startQuiz}>
                Retry Quiz
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    )
  }

  const question = questions[currentQuestion]

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      {/* Progress */}
      <div className="space-y-2">
        <div className="flex items-center justify-between text-sm">
          <span className="text-muted-foreground">
            Question {currentQuestion + 1} of {questions.length}
          </span>
          <div className="flex items-center gap-2 text-muted-foreground">
            <Clock className="w-4 h-4" />
            <span>{user?.subjects?.find(s => s.id === selectedSubject)?.name}</span>
          </div>
        </div>
        <Progress value={((currentQuestion + 1) / questions.length) * 100} className="h-2" />
      </div>

      {/* Question */}
      <Card className="border-border/50">
        <CardHeader>
          <CardTitle className="text-xl">{question.question}</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          {question.options.map((option, index) => (
            <button
              key={index}
              onClick={() => handleAnswerSelect(index)}
              disabled={showResult}
              className={cn(
                "w-full p-4 rounded-lg border-2 text-left transition-all flex items-center gap-3",
                showResult
                  ? index === question.correctAnswer
                    ? "border-success bg-success/10"
                    : selectedAnswer === index
                      ? "border-destructive bg-destructive/10"
                      : "border-border bg-card"
                  : selectedAnswer === index
                    ? "border-primary bg-primary/5"
                    : "border-border bg-card hover:border-primary/50"
              )}
            >
              <span className={cn(
                "w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium flex-shrink-0",
                showResult
                  ? index === question.correctAnswer
                    ? "bg-success text-success-foreground"
                    : selectedAnswer === index
                      ? "bg-destructive text-destructive-foreground"
                      : "bg-muted text-muted-foreground"
                  : selectedAnswer === index
                    ? "bg-primary text-primary-foreground"
                    : "bg-muted text-muted-foreground"
              )}>
                {String.fromCharCode(65 + index)}
              </span>
              <span className="text-foreground">{option}</span>
              {showResult && index === question.correctAnswer && (
                <CheckCircle2 className="w-5 h-5 text-success ml-auto" />
              )}
              {showResult && selectedAnswer === index && index !== question.correctAnswer && (
                <XCircle className="w-5 h-5 text-destructive ml-auto" />
              )}
            </button>
          ))}

          {showResult && (
            <div className="mt-4 p-4 rounded-lg bg-muted">
              <p className="text-sm text-muted-foreground">
                <span className="font-medium text-foreground">Explanation: </span>
                {question.explanation}
              </p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Actions */}
      <div className="flex justify-end gap-4">
        {!showResult ? (
          <Button onClick={handleSubmitAnswer} disabled={selectedAnswer === null}>
            Submit Answer
          </Button>
        ) : (
          <Button onClick={handleNextQuestion} className="gap-2">
            {currentQuestion < questions.length - 1 ? (
              <>Next Question <ArrowRight className="w-4 h-4" /></>
            ) : (
              <>See Results <Trophy className="w-4 h-4" /></>
            )}
          </Button>
        )}
      </div>
    </div>
  )
}
