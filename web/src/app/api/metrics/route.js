// web/src/app/api/metrics/route.js
import { NextResponse } from 'next/server';

export async function GET() {
  const memoryUsage = process.memoryUsage();

  const payload = {
    status: 'optimal',
    uptime: process.uptime(),
    memory: {
      heapUsed: memoryUsage.heapUsed,
      heapTotal: memoryUsage.heapTotal,
      rss: memoryUsage.rss,
      external: memoryUsage.external,
    },
    timestamp: new Date().toISOString(),
  };

  return NextResponse.json(payload, { status: 200 });
}
