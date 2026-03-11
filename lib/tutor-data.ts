export const SUBJECT_TOPICS: Record<string, string[]> = {
                  'os': ['Process Management', 'Deadlocks', 'CPU Scheduling', 'Memory Management', 'File Systems'],
                  'cn': ['OSI Model', 'TCP/IP Protocol Suite', 'IP Addressing & Subnetting', 'Routing Algorithms', 'Network Security'],
                  'cyber': ['Introduction to Cryptography', 'Network Security Fundamentals', 'Web Application Security', 'Malware Analysis', 'Ethical Hacking Basics'],
                  'dbms': ['Relational Database Design', 'SQL Queries & Optimization', 'Normalization Techniques', 'Transaction Management (ACID)', 'NoSQL Databases'],
                  'math': ['Calculus & Integration', 'Linear Algebra', 'Probability & Statistics', 'Discrete Mathematics', 'Trigonometry'],
                  'physics': ['Classical Mechanics', 'Thermodynamics', 'Electromagnetism', 'Optics & Light', 'Modern Physics'],
                  'dsa': ['Array & Linked Lists', 'Stacks & Queues', 'Trees & Graphs', 'Sorting & Searching', 'Dynamic Programming'],
                  'algo': ['Asymptotic Analysis', 'Divide and Conquer', 'Greedy Algorithms', 'Graph Algorithms', 'Complexity Classes (P vs NP)'],
                  'default': ['General Learning Strategies', 'Note Taking Methods', 'Exam Preparation Tips', 'Time Management for Students', 'Active Recall Techniques']
};

export interface Resource {
                  title: string;
                  url: string;
                  type: 'video' | 'article' | 'doc' | 'tutorial';
}

export interface LearningModule {
                  title: string;
                  overview: string;
                  detailedExplanation: string;
                  keyConcepts: { name: string; explanation: string }[];
                  realWorldExample: string;
                  diagramUrl?: string;
                  diagramExplanation?: string;
                  examPoints: string[];
                  additionalInfo?: { historical?: string; commonMistakes?: string[]; tips?: string[] };
                  externalResources?: Resource[];
                  practiceQuestions: {
                                    mcqs: { question: string; options: string[]; answer: number; explanation: string; difficulty: 'Easy' | 'Medium' | 'Hard' }[];
                                    shortAnswer: { question: string; answer: string; difficulty: 'Easy' | 'Medium' | 'Hard' }[];
                                    conceptual: string[];
                  };
                  practiceProblems?: { problem: string; solution: string }[];
                  summary: string;
}

export const getTutorModule = (subject: string, topic: string): LearningModule => {
                  if (topic === 'Deadlocks') {
                                    return {
                                                      title: "Deadlocks in Operating Systems",
                                                      overview: "A deadlock is a situation where two or more processes are unable to proceed because each is waiting for the other to release a resource. It's a critical synchronization problem in multiprogramming systems.",
                                                      detailedExplanation: "In an operating system, processes compete for a limited number of resources. A process requests resources; if they are not available, it enters a waiting state. If a waiting process is never again able to change state because the resources it has requested are held by other waiting processes, then the system is in a deadlock. All four Coffman conditions must hold for a deadlock to occur.",
                                                      keyConcepts: [
                                                                        { name: "Mutual Exclusion", explanation: "Only one process can use a resource at a time." },
                                                                        { name: "Hold and Wait", explanation: "A process must be holding at least one resource and waiting to acquire additional resources that are currently being held by other processes." },
                                                                        { name: "No Preemption", explanation: "Resources cannot be preempted; they can only be released voluntarily by the process holding them." },
                                                                        { name: "Circular Wait", explanation: "A set of waiting processes {P0, P1, ..., Pn} must exist such that P0 is waiting for a resource held by P1, P1 for P2, and Pn for P0." }
                                                      ],
                                                      realWorldExample: "A classic example is a 'gridlock' at a four-way intersection where every car has moved forward enough to block the car to its left, and no one can move until someone else moves backward.",
                                                      diagramUrl: "file:///C:/Users/solin/.gemini/antigravity/brain/485b0ea6-0e94-4b80-9db6-4a7317c7108c/deadlock_process_diagram_1773083201148.png",
                                                      diagramExplanation: "This diagram shows a standard circular wait. Process P1 holds Resource R1 and requests R2, while Process P2 holds Resource R2 and requests R1. Neither can proceed.",
                                                      examPoints: [
                                                                        "Memorize the 4 Coffman conditions - they are always asked.",
                                                                        "Banker's Algorithm is the primary method for Deadlock Avoidance.",
                                                                        "A Resource Allocation Graph (RAG) with a cycle indicates a potential deadlock (definite in single-instance resource systems).",
                                                                        "Ostrich Algorithm: The strategy of ignoring the problem (used in Unix/Windows for non-critical deadlocks)."
                                                      ],
                                                      additionalInfo: {
                                                                        historical: "The concept was first formally described by E.G. Coffman in 1971, hence the name 'Coffman Conditions'.",
                                                                        commonMistakes: [
                                                                                          "Confusing Deadlock with Starvation (Starvation is when a process perpetually waits but others are still moving).",
                                                                                          "Assuming a cycle in a RAG always means deadlock (only true if each resource has 1 instance)."
                                                                        ],
                                                                        tips: ["Remember the acronym 'MHNC' (Mutual, Hold, No preemption, Circular) to recall the factors."]
                                                      },
                                                      externalResources: [
                                                                        { title: "Deadlock Detection & Recovery", url: "https://en.wikipedia.org/wiki/Deadlock", type: "doc" },
                                                                        { title: "Banker's Algorithm Visualization", url: "https://www.geeksforgeeks.org/bankers-algorithm-in-operating-system-2/", type: "article" },
                                                                        { title: "Operating Systems: Deadlocks Video", url: "https://www.youtube.com/results?search_query=deadlocks+operating+systems", type: "video" }
                                                      ],
                                                      practiceQuestions: {
                                                                        mcqs: [
                                                                                          {
                                                                                                            question: "Which condition is violated if we allow the OS to take back a resource from a process?",
                                                                                                            options: ["Mutual Exclusion", "Hold and Wait", "No Preemption", "Circular Wait"],
                                                                                                            answer: 2,
                                                                                                            explanation: "Allowing the OS to take back resources is 'Preemption', which breaks the 'No Preemption' condition.",
                                                                                                            difficulty: 'Easy'
                                                                                          },
                                                                                          {
                                                                                                            question: "The Banker's Algorithm ensures that the system is always in a:",
                                                                                                            options: ["Deadlock state", "Safe state", "Unsafe state", "Preempted state"],
                                                                                                            answer: 1,
                                                                                                            explanation: "Banker's algorithm checks if an allocation keeps the system in a 'Safe' state.",
                                                                                                            difficulty: 'Medium'
                                                                                          }
                                                                        ],
                                                                        shortAnswer: [
                                                                                          { question: "What is a Safe State?", answer: "A state is safe if the system can allocate resources to each process in some order and still avoid a deadlock.", difficulty: "Medium" }
                                                                        ],
                                                                        conceptual: ["Explain how breaking the Circular Wait condition can prevent deadlocks.", "Compare Deadlock Avoidance vs Deadlock Prevention."]
                                                      },
                                                      practiceProblems: [
                                                                        {
                                                                                          problem: "System has 5 processes (P0-P4) and 3 resource types (A, B, C). A has 10, B 5, C 7 instances. Currently, 7 units of A are held. Is there enough to satisfy a new request of 4 units of A?",
                                                                                          solution: "No. 10 - 7 = 3 available units. A request for 4 units cannot be satisfied immediately."
                                                                        }
                                                      ],
                                                      summary: "Deadlocks are a stalemate in resource allocation. By understanding the 4 necessary conditions, we can implement strategies like the Banker's Algorithm to maintain system stability and performance."
                                    };
                  }

                  // Generic fallback
                  return {
                                    title: topic,
                                    overview: `Learning module for ${topic}, a key subject in ${subject}.`,
                                    detailedExplanation: `A comprehensive look at ${topic} including its theoretical foundations and practical implementations within the current curriculum.`,
                                    keyConcepts: [
                                                      { name: "Concept Alpha", explanation: "The foundational principle of this topic." },
                                                      { name: "Concept Beta", explanation: "How this topic interacts with other systems." }
                                    ],
                                    realWorldExample: `In a professional setting, ${topic} is used to optimize performance and ensure system reliability.`,
                                    examPoints: [`Definition of ${topic}`, `Historical context`, `Practical applications`],
                                    practiceQuestions: {
                                                      mcqs: [
                                                                        { question: "Sample MCQ?", options: ["A", "B", "C", "D"], answer: 0, explanation: "A is correct.", difficulty: "Easy" }
                                                      ],
                                                      shortAnswer: [{ question: "Sample Short Answer?", answer: "Sample Answer.", difficulty: "Medium" }],
                                                      conceptual: ["Briefly explain the main idea."]
                                    },
                                    summary: `End of ${topic} overview. Review the key concepts for exams.`
                  };
};
