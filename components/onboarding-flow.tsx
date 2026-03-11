"use client"

import { useState } from 'react'
import { useStudy, EducationLevel, EngineeringBranch, IntermediateYear } from '@/lib/study-context'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { cn } from '@/lib/utils'
import { 
  GraduationCap, 
  BookOpen, 
  School, 
  Building2, 
  Layers,
  ChevronRight,
  Check
} from 'lucide-react'

type Step = 'education' | 'details' | 'confirm'

const educationLevels = [
  { id: 'class-1-5' as EducationLevel, label: 'Class 1-5', icon: School, description: 'Primary school students' },
  { id: 'class-6-10' as EducationLevel, label: 'Class 6-10', icon: BookOpen, description: 'Middle & high school' },
  { id: 'intermediate' as EducationLevel, label: 'Intermediate', icon: Layers, description: '11th & 12th grade' },
  { id: 'engineering' as EducationLevel, label: 'Engineering', icon: Building2, description: 'B.Tech / B.E. students' },
  { id: 'other' as EducationLevel, label: 'Other Courses', icon: GraduationCap, description: 'Competitive exams & more' },
]

const engineeringBranches: EngineeringBranch[] = ['CSE', 'ECE', 'Mechanical', 'Civil', 'EEE', 'Chemical']
const semesters = [1, 2, 3, 4, 5, 6, 7, 8]
const intermediateYears: IntermediateYear[] = ['1st Year', '2nd Year']
const classes1to5 = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5']
const classes6to10 = ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10']

export function OnboardingFlow() {
  const { user, updateProfile } = useStudy()
  const [step, setStep] = useState<Step>('education')
  const [selectedLevel, setSelectedLevel] = useState<EducationLevel | null>(null)
  const [selectedBranch, setSelectedBranch] = useState<EngineeringBranch | null>(null)
  const [selectedSemester, setSelectedSemester] = useState<number | null>(null)
  const [selectedYear, setSelectedYear] = useState<IntermediateYear | null>(null)
  const [selectedClass, setSelectedClass] = useState<string | null>(null)

  const handleLevelSelect = (level: EducationLevel) => {
    setSelectedLevel(level)
    setSelectedBranch(null)
    setSelectedSemester(null)
    setSelectedYear(null)
    setSelectedClass(null)
  }

  const canProceedToDetails = selectedLevel !== null
  const canProceedToConfirm = () => {
    if (!selectedLevel) return false
    if (selectedLevel === 'engineering') return selectedBranch !== null && selectedSemester !== null
    if (selectedLevel === 'intermediate') return selectedYear !== null
    if (selectedLevel === 'class-1-5' || selectedLevel === 'class-6-10') return selectedClass !== null
    return true // 'other' doesn't need additional details
  }

  const handleComplete = () => {
    if (!selectedLevel) return

    updateProfile({
      educationLevel: selectedLevel,
      branch: selectedBranch || undefined,
      semester: selectedSemester || undefined,
      year: selectedYear || undefined,
      class: selectedClass || undefined,
    })
  }

  const renderStep = () => {
    switch (step) {
      case 'education':
        return (
          <div className="space-y-6">
            <div className="text-center">
              <h2 className="text-2xl font-bold text-foreground mb-2">Select Your Education Level</h2>
              <p className="text-muted-foreground">Choose your current academic level to personalize your experience</p>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {educationLevels.map((level) => (
                <button
                  key={level.id}
                  onClick={() => handleLevelSelect(level.id)}
                  className={cn(
                    "p-6 rounded-xl border-2 text-left transition-all hover:border-primary/50",
                    selectedLevel === level.id
                      ? "border-primary bg-primary/5"
                      : "border-border bg-card hover:bg-muted/50"
                  )}
                >
                  <div className={cn(
                    "w-12 h-12 rounded-lg flex items-center justify-center mb-4",
                    selectedLevel === level.id ? "bg-primary text-primary-foreground" : "bg-muted text-muted-foreground"
                  )}>
                    <level.icon className="w-6 h-6" />
                  </div>
                  <h3 className="font-semibold text-foreground mb-1">{level.label}</h3>
                  <p className="text-sm text-muted-foreground">{level.description}</p>
                  {selectedLevel === level.id && (
                    <div className="mt-3 flex items-center text-primary text-sm font-medium">
                      <Check className="w-4 h-4 mr-1" /> Selected
                    </div>
                  )}
                </button>
              ))}
            </div>

            <div className="flex justify-end">
              <Button
                onClick={() => setStep('details')}
                disabled={!canProceedToDetails}
                className="gap-2"
              >
                Continue <ChevronRight className="w-4 h-4" />
              </Button>
            </div>
          </div>
        )

      case 'details':
        return (
          <div className="space-y-6">
            <div className="text-center">
              <h2 className="text-2xl font-bold text-foreground mb-2">
                {selectedLevel === 'engineering' && 'Select Your Branch & Semester'}
                {selectedLevel === 'intermediate' && 'Select Your Year'}
                {(selectedLevel === 'class-1-5' || selectedLevel === 'class-6-10') && 'Select Your Class'}
                {selectedLevel === 'other' && 'Almost Done!'}
              </h2>
              <p className="text-muted-foreground">This helps us show you the right subjects</p>
            </div>

            {selectedLevel === 'engineering' && (
              <div className="space-y-6">
                <div>
                  <h3 className="text-sm font-medium text-foreground mb-3">Branch</h3>
                  <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                    {engineeringBranches.map((branch) => (
                      <button
                        key={branch}
                        onClick={() => setSelectedBranch(branch)}
                        className={cn(
                          "p-4 rounded-lg border-2 text-center transition-all",
                          selectedBranch === branch
                            ? "border-primary bg-primary/5 text-foreground"
                            : "border-border bg-card text-muted-foreground hover:border-primary/50"
                        )}
                      >
                        {branch}
                      </button>
                    ))}
                  </div>
                </div>

                <div>
                  <h3 className="text-sm font-medium text-foreground mb-3">Semester</h3>
                  <div className="grid grid-cols-4 gap-3">
                    {semesters.map((sem) => (
                      <button
                        key={sem}
                        onClick={() => setSelectedSemester(sem)}
                        className={cn(
                          "p-3 rounded-lg border-2 text-center transition-all",
                          selectedSemester === sem
                            ? "border-primary bg-primary/5 text-foreground"
                            : "border-border bg-card text-muted-foreground hover:border-primary/50"
                        )}
                      >
                        Sem {sem}
                      </button>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {selectedLevel === 'intermediate' && (
              <div className="grid grid-cols-2 gap-4 max-w-md mx-auto">
                {intermediateYears.map((year) => (
                  <button
                    key={year}
                    onClick={() => setSelectedYear(year)}
                    className={cn(
                      "p-6 rounded-lg border-2 text-center transition-all",
                      selectedYear === year
                        ? "border-primary bg-primary/5 text-foreground"
                        : "border-border bg-card text-muted-foreground hover:border-primary/50"
                    )}
                  >
                    <span className="text-lg font-medium">{year}</span>
                  </button>
                ))}
              </div>
            )}

            {selectedLevel === 'class-1-5' && (
              <div className="grid grid-cols-3 sm:grid-cols-5 gap-3 max-w-lg mx-auto">
                {classes1to5.map((cls) => (
                  <button
                    key={cls}
                    onClick={() => setSelectedClass(cls)}
                    className={cn(
                      "p-4 rounded-lg border-2 text-center transition-all",
                      selectedClass === cls
                        ? "border-primary bg-primary/5 text-foreground"
                        : "border-border bg-card text-muted-foreground hover:border-primary/50"
                    )}
                  >
                    {cls}
                  </button>
                ))}
              </div>
            )}

            {selectedLevel === 'class-6-10' && (
              <div className="grid grid-cols-3 sm:grid-cols-5 gap-3 max-w-lg mx-auto">
                {classes6to10.map((cls) => (
                  <button
                    key={cls}
                    onClick={() => setSelectedClass(cls)}
                    className={cn(
                      "p-4 rounded-lg border-2 text-center transition-all",
                      selectedClass === cls
                        ? "border-primary bg-primary/5 text-foreground"
                        : "border-border bg-card text-muted-foreground hover:border-primary/50"
                    )}
                  >
                    {cls}
                  </button>
                ))}
              </div>
            )}

            {selectedLevel === 'other' && (
              <Card className="max-w-md mx-auto">
                <CardContent className="pt-6 text-center">
                  <GraduationCap className="w-12 h-12 text-primary mx-auto mb-4" />
                  <p className="text-muted-foreground">
                    You will have access to general study materials including reasoning, aptitude, and general knowledge.
                  </p>
                </CardContent>
              </Card>
            )}

            <div className="flex justify-between">
              <Button variant="outline" onClick={() => setStep('education')}>
                Back
              </Button>
              <Button
                onClick={() => setStep('confirm')}
                disabled={!canProceedToConfirm()}
                className="gap-2"
              >
                Continue <ChevronRight className="w-4 h-4" />
              </Button>
            </div>
          </div>
        )

      case 'confirm':
        return (
          <div className="space-y-6 max-w-md mx-auto">
            <div className="text-center">
              <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center mx-auto mb-4">
                <Check className="w-8 h-8 text-primary" />
              </div>
              <h2 className="text-2xl font-bold text-foreground mb-2">You are all set!</h2>
              <p className="text-muted-foreground">Here is a summary of your profile</p>
            </div>

            <Card>
              <CardHeader>
                <CardTitle className="text-lg">Profile Summary</CardTitle>
                <CardDescription>Review your selections</CardDescription>
              </CardHeader>
              <CardContent className="space-y-3">
                <div className="flex justify-between py-2 border-b border-border">
                  <span className="text-muted-foreground">Name</span>
                  <span className="font-medium text-foreground">{user?.name}</span>
                </div>
                <div className="flex justify-between py-2 border-b border-border">
                  <span className="text-muted-foreground">Level</span>
                  <span className="font-medium text-foreground">
                    {educationLevels.find(l => l.id === selectedLevel)?.label}
                  </span>
                </div>
                {selectedClass && (
                  <div className="flex justify-between py-2 border-b border-border">
                    <span className="text-muted-foreground">Class</span>
                    <span className="font-medium text-foreground">{selectedClass}</span>
                  </div>
                )}
                {selectedYear && (
                  <div className="flex justify-between py-2 border-b border-border">
                    <span className="text-muted-foreground">Year</span>
                    <span className="font-medium text-foreground">{selectedYear}</span>
                  </div>
                )}
                {selectedBranch && (
                  <div className="flex justify-between py-2 border-b border-border">
                    <span className="text-muted-foreground">Branch</span>
                    <span className="font-medium text-foreground">{selectedBranch}</span>
                  </div>
                )}
                {selectedSemester && (
                  <div className="flex justify-between py-2">
                    <span className="text-muted-foreground">Semester</span>
                    <span className="font-medium text-foreground">Semester {selectedSemester}</span>
                  </div>
                )}
              </CardContent>
            </Card>

            <div className="flex justify-between">
              <Button variant="outline" onClick={() => setStep('details')}>
                Back
              </Button>
              <Button onClick={handleComplete} className="gap-2">
                Start Learning <ChevronRight className="w-4 h-4" />
              </Button>
            </div>
          </div>
        )
    }
  }

  return (
    <div className="min-h-screen bg-background p-6 lg:p-12">
      {/* Progress indicator */}
      <div className="max-w-3xl mx-auto mb-8">
        <div className="flex items-center justify-center gap-2">
          {['education', 'details', 'confirm'].map((s, i) => (
            <div key={s} className="flex items-center">
              <div
                className={cn(
                  "w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium transition-colors",
                  step === s
                    ? "bg-primary text-primary-foreground"
                    : ['education', 'details', 'confirm'].indexOf(step) > i
                    ? "bg-primary/20 text-primary"
                    : "bg-muted text-muted-foreground"
                )}
              >
                {i + 1}
              </div>
              {i < 2 && (
                <div
                  className={cn(
                    "w-12 h-0.5 mx-1",
                    ['education', 'details', 'confirm'].indexOf(step) > i
                      ? "bg-primary"
                      : "bg-muted"
                  )}
                />
              )}
            </div>
          ))}
        </div>
      </div>

      {/* Step content */}
      <div className="max-w-4xl mx-auto">
        {renderStep()}
      </div>
    </div>
  )
}
