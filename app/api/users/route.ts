import { NextResponse } from "next/server";
import prisma from "@/lib/prisma";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const email = searchParams.get("email");

  try {
    if (email) {
      const user = await prisma.user.findUnique({
        where: { email },
        include: { tasks: true, sessions: true },
      });
      return NextResponse.json(user);
    }

    const users = await prisma.user.findMany();
    return NextResponse.json(users);
  } catch (error) {
    console.error("Failed to fetch users:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  try {
    const json = await request.json();
    const { email, name } = json;

    if (!email) {
      return NextResponse.json(
        { error: "Missing required field (email)" },
        { status: 400 }
      );
    }

    // Upsert user (create if not exists, otherwise return existing)
    const user = await prisma.user.upsert({
      where: { email },
      update: { name },
      create: { email, name },
    });

    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    console.error("Failed to create user:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500 }
    );
  }
}
