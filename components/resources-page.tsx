"use client"

import { useState } from 'react'
import { useStudy, getSubjectsForProfile } from '@/lib/study-context'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Book, PlayCircle, ExternalLink, Bookmark, Search, GraduationCap } from 'lucide-react'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { cn } from '@/lib/utils'

interface Resource {
  id: string
  title: string
  topics: string[]
  wikiLink: string
  youtubeLink: string
}

const generateResourcesForSubject = (subjectName: string, state?: string): Resource => {
  const name = subjectName.toLowerCase();
  
  let topics: string[] = [];
  
  if (state === 'Andhra Pradesh' || state === 'Telangana') {
    if (name.includes('math1a') || name.includes('maths 1a') || name.includes('1a')) {
      topics = ["Functions", "Mathematical Induction", "Matrices", "Vector Algebra", "Trigonometric Ratios up to Transformations", "Hyperbolic Functions", "Properties of Triangles"];
    } else if (name.includes('math1b') || name.includes('maths 1b') || name.includes('1b')) {
      topics = ["Locus", "Transformation of Axes", "The Straight Line", "Pair of Straight Lines", "Three Dimensional Coordinates", "Direction Cosines and Direction Ratios", "The Plane", "Limits and Continuity", "Differentiation", "Applications of Derivatives"];
    } else if (name.includes('math') && name.includes('2a')) {
      topics = ["Complex Numbers", "De Moivre's Theorem", "Quadratic Expressions", "Theory of Equations", "Permutations and Combinations", "Binomial Theorem", "Partial Fractions", "Measures of Dispersion", "Probability", "Random Variables"];
    } else if (name.includes('math') && name.includes('2b')) {
      topics = ["Circle", "System of Circles", "Parabola", "Ellipse", "Hyperbola", "Integration", "Definite Integrals", "Differential Equations"];
    } else if (name.includes('physics')) {
      topics = ["Physical World", "Units and Measurements", "Motion in a Straight Line", "Motion in a Plane", "Laws of Motion", "Work, Energy and Power", "Systems of Particles", "Oscillations", "Gravitation"];
    } else if (name.includes('chemistry')) {
      topics = ["Atomic Structure", "Classification of Elements", "Chemical Bonding", "States of Matter", "Thermodynamics", "Chemical Equilibrium and Acids-Bases", "Hydrogen and its Compounds", "s-Block Elements"];
    } else if (name.includes('botany')) {
      topics = ["Diversity in the Living World", "Structural Organisation in Plants- Morphology", "Reproduction in Plants", "Plant Systematics", "Cell Structure and Function", "Internal Organisation of Plants", "Plant Ecology"];
    } else if (name.includes('zoology')) {
      topics = ["Diversity of Living World", "Structural Organization in Animals", "Animal Diversity", "Biology & Human Welfare", "Locomotion & Reproduction in Protozoa", "Ecology & Environment"];
    } else if (name.includes('telugu')) {
      topics = ["Poetry (Padya Bhagam)", "Prose (Gadya Bhagam)", "Short Stories (Upavachakam)", "Grammar (Vyakaranam)"];
    } else {
      topics = ["Important AP/TS Board Topics", "Previous Year Question Papers", "Core Chapter Concepts", "Revision Notes"];
    }
  } else if (state === 'Tamil Nadu') {
    if (name.includes('math')) {
      topics = ["Applications of Matrices", "Complex Numbers", "Theory of Equations", "Inverse Trigonometric Functions", "Two Dimensional Analytical Geometry", "Applications of Vector Algebra"];
    } else if (name.includes('physics')) {
      topics = ["Electrostatics", "Current Electricity", "Magnetism", "Electromagnetic Induction", "Electromagnetic Waves", "Ray Optics", "Wave Optics", "Dual Nature of Radiation"];
    } else if (name.includes('chemistry')) {
      topics = ["Metallurgy", "p-Block Elements", "Transition Elements", "Coordination Chemistry", "Solid State", "Chemical Kinetics", "Ionic Equilibrium"];
    } else if (name.includes('biology') || name.includes('botany') || name.includes('zoology')) {
      topics = ["Reproduction in Organisms", "Human Reproduction", "Reproductive Health", "Principles of Inheritance", "Molecular Genetics", "Evolution", "Human Health and Diseases"];
    } else if (name.includes('tamil')) {
      topics = ["Iyal 1: Language", "Iyal 2: Environment", "Iyal 3: Culture", "Grammar (Ilakkanam)"];
    } else {
      topics = ["Tamil Nadu Samacheer Kalvi Topics", "Previous Year Question Papers", "Core Chapter Concepts", "Revision Notes"];
    }
  } else {
    // CBSE / Default / North India
    if (name.includes('math') || name.includes('1a') || name.includes('2a')) {
      topics = ["Matrices & Determinants", "Complex Numbers", "Integration", "Probability", "Differential Equations"];
    } else if (name.includes('physics')) {
      topics = ["Mechanics", "Electromagnetism", "Optics", "Thermodynamics", "Modern Physics"];
    } else if (name.includes('chemistry')) {
      topics = ["Organic Chemistry structure & mechanisms", "Chemical Bonding", "Thermodynamics", "Periodic Table"];
    } else if (name.includes('botany')) {
      topics = ["Plant Physiology", "Genetics", "Cell Biology", "Ecology"];
    } else if (name.includes('zoology')) {
      topics = ["Human Anatomy", "Evolution", "Animal Diversity", "Reproductive System"];
    } else if (name.includes('english')) {
      topics = ["Grammar and Vocabulary", "Reading Comprehension", "Essay Writing", "Literature Analysis"];
    } else if (name.includes('os') || name.includes('operating')) {
      topics = ["Processes & Threads", "Memory Management", "File Systems", "Deadlocks"];
    } else {
      topics = ["Introduction & Basics", "Core Principles", "Advanced Applications", "Previous Year Papers"];
    }
  }

  return {
    id: subjectName,
    title: `${subjectName} Resources`,
    topics,
    wikiLink: `https://en.wikipedia.org/wiki/Special:Search?search=${encodeURIComponent(subjectName)}`,
    youtubeLink: `https://www.youtube.com/results?search_query=${encodeURIComponent(subjectName + ' full course')}`,
  }
}

export function ResourcesPage() {
  const { user } = useStudy()
  const subjects = user ? getSubjectsForProfile(user.state, user.educationLevel, user.branch, user.group) : getSubjectsForProfile()
  
  const [selectedSubject, setSelectedSubject] = useState<string | null>(subjects.length > 0 ? subjects[0].name : null)
  const [search, setSearch] = useState('')

  const activeSubject = selectedSubject || (subjects.length > 0 ? subjects[0].name : 'General');
  const activeResource = generateResourcesForSubject(activeSubject, user?.state);

  const filteredSubjects = subjects.filter(s => s.name.toLowerCase().includes(search.toLowerCase()))

  return (
    <div className="max-w-6xl mx-auto space-y-8">
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div className="space-y-2">
          <h2 className="text-3xl font-bold tracking-tight">Study Resources</h2>
          <p className="text-muted-foreground">Access important topics, wiki articles, and video lectures per subject.</p>
        </div>
        <div className="relative w-full md:w-64">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input
            placeholder="Search your subjects..."
            className="pl-10"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
        {/* Subject Sidebar */}
        <Card className="lg:col-span-1 h-fit border-none shadow-sm dark:bg-card/50">
          <CardHeader className="pb-3 border-b">
            <CardTitle className="text-lg flex items-center gap-2">
              <GraduationCap className="h-5 w-5 text-primary" />
              Your Subjects
            </CardTitle>
          </CardHeader>
          <CardContent className="p-2 space-y-1">
            {filteredSubjects.length > 0 ? (
              filteredSubjects.map((subject) => (
                <button
                  key={subject.id}
                  onClick={() => setSelectedSubject(subject.name)}
                  className={cn(
                    "w-full flex items-center gap-3 px-3 py-3 rounded-lg text-left transition-all",
                    activeSubject === subject.name
                      ? "bg-primary/10 text-primary font-medium"
                      : "hover:bg-muted text-muted-foreground hover:text-foreground"
                  )}
                >
                  <span className="text-xl">{subject.icon}</span>
                  <span className="flex-1 truncate">{subject.name}</span>
                </button>
              ))
            ) : (
              <div className="text-center py-6 text-muted-foreground text-sm">
                No subjects found.
              </div>
            )}
          </CardContent>
        </Card>

        {/* Selected Subject Content */}
        <div className="lg:col-span-3 space-y-6">
          <div className="flex items-center justify-between">
            <h3 className="text-2xl font-bold flex items-center gap-3">
              <Book className="text-primary w-6 h-6" /> 
              {activeResource.title}
            </h3>
            <div className="flex gap-2">
              <Button size="sm" variant="outline" className="gap-2" asChild>
                <a href={activeResource.wikiLink} target="_blank" rel="noreferrer">
                  <ExternalLink className="w-4 h-4" /> Wikipedia
                </a>
              </Button>
              <Button size="sm" className="gap-2 bg-red-600 hover:bg-red-700 text-white" asChild>
                <a href={activeResource.youtubeLink} target="_blank" rel="noreferrer">
                  <PlayCircle className="w-4 h-4" /> YouTube Tutorials
                </a>
              </Button>
            </div>
          </div>

          <Card className="border-border/50">
            <CardHeader className="bg-primary/5 border-b pb-4">
              <CardTitle className="text-lg flex items-center gap-2">
                <Bookmark className="w-5 h-5 text-primary" /> Highly Repeated & Important Topics
              </CardTitle>
              <CardDescription>Master these topics first to boost your score.</CardDescription>
            </CardHeader>
            <CardContent className="p-6">
              <ul className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {activeResource.topics.map((topic, i) => (
                  <li key={i} className="flex items-start gap-3 p-3 rounded-lg border bg-card hover:bg-accent/50 transition-colors">
                    <div className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center font-bold text-xs shrink-0 mt-0.5">
                      {i + 1}
                    </div>
                    <div>
                      <span className="font-medium text-foreground">{topic}</span>
                      <p className="text-xs text-muted-foreground mt-1 text-balance">Frequently appears in exams and competitive tests.</p>
                    </div>
                  </li>
                ))}
              </ul>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
