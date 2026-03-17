import { NextResponse } from "next/server";
import prisma from "@/lib/prisma";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const userId = searchParams.get("userId");

  try {
    const sessions = await prisma.studySession.findMany({
      where: userId ? { userId } : undefined,
      orderBy: { createdAt: "desc" },
    });
    return NextResponse.json(sessions);
  } catch (error) {
    console.error("Failed to fetch sessions:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  try {
    const json = await request.json();
    const { userId, duration, subject } = json;

    if (!userId || duration === undefined) {
      return NextResponse.json(
        { error: "Missing required fields (userId, duration)" },
        { status: 400 }
      );
    }

    const session = await prisma.studySession.create({
      data: { userId, duration, subject },
    });
    return NextResponse.json(session, { status: 201 });
  } catch (error) {
    console.error("Failed to create study session:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 }
    );
  }
}
