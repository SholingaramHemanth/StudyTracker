"use server"

import { GoogleGenerativeAI } from "@google/generative-ai";

const apiKey = process.env.GOOGLE_GENERATIVE_AI_API_KEY;
console.log("AI Action: API Key present?", !!apiKey);
const genAI = new GoogleGenerativeAI(apiKey || "");

export async function chatWithAssistant(messages: { role: "user" | "model"; content: string }[]) {
  try {
    const model = genAI.getGenerativeModel({ 
      model: "gemini-1.5-flash",
      systemInstruction: "You are a friendly, cool, and highly intelligent AI Study Companion. While your primary purpose is to help students with their studies, timers, and academic goals, you should also be a supportive friend. Feel free to have more open, natural conversations, crack occasional study-related jokes, and offer emotional support for exam stress. Don't be too robotic—be the 'study buddy' everyone wants. If asked to set a timer, mention you've done it so the user knows to look at the UI."
    });

    const chat = model.startChat({
      history: messages.slice(0, -1).map(m => ({
        role: m.role,
        parts: [{ text: m.content }]
      })),
    });

    const result = await chat.sendMessage(messages[messages.length - 1].content);
    return result.response.text();
  } catch (error) {
    console.error("Gemini API Error:", error);
    throw new Error("Failed to get response from AI assistant.");
  }
}

export async function generateRoadmapAction(goal: string) {
  try {
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    const prompt = `
      Create a structured 3-month study roadmap for the following goal: "${goal}".
      Return the roadmap as a JSON object with exactly the following structure:
      {
        "steps": [
          { "month": "Month 1", "target": "Specific milestone for month 1" },
          { "month": "Month 2", "target": "Specific milestone for month 2" },
          { "month": "Month 3", "target": "Specific milestone for month 3" }
        ]
      }
      Focus on actionable learning outcomes. Do not include any text outside the JSON block.
    `;

    const result = await model.generateContent(prompt);
    const responseText = result.response.text();
    
    // Extract JSON from potential markdown blocks
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error("Invalid response format from AI.");
    
    return JSON.parse(jsonMatch[0]) as { steps: { month: string; target: string }[] };
  } catch (error) {
    console.error("Gemini Roadmap Error:", error);
    throw new Error("Failed to generate roadmap.");
  }
}

export async function getCareerGuidance(question: string) {
  try {
    const model = genAI.getGenerativeModel({ 
      model: "gemini-1.5-flash",
      systemInstruction: "You are an elite, highly professional AI Career Advisor & Planner. Your goal is to provide deeply insightful, practical career advice and a highly structured roadmap. ALWAYS format your response in professional Markdown with clear headings. Use sections like '🚀 Career Overview', '📊 Required Skills', '🗺️ Step-by-Step Roadmap (0-12 months)', '⏰ Suggested Daily Schedule', '⚠️ Pitfalls to Avoid', and '📚 Recommended Resources (Books & Websites)'. Do not just give generic advice; be specific, actionable, and impressive."
    });

    const result = await model.generateContent(question);
    return result.response.text();
  } catch (error) {
    console.error("Gemini Career Error:", error);
    throw new Error("Failed to get career guidance.");
  }
}
