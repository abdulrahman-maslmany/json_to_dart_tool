// web/src/app/api/metrics/route.test.js
import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { GET } from './route.js';

describe('Telemetry Metrics API Endpoint Suite', () => {
  it('should return HTTP 200 with optimal status', async () => {
    const response = await GET();
    assert.equal(response.status, 200);

    const data = await response.json();
    assert.equal(data.status, 'optimal');
  });

  it('should include valid uptime and heap memory telemetry', async () => {
    const response = await GET();
    const data = await response.json();

    // التحقق من مدة التشغيل (uptime)
    assert.equal(typeof data.uptime, 'number');
    assert.ok(data.uptime >= 0, 'Uptime must be a positive number');

    // التحقق من استهلاك الذاكرة (heap memory)
    assert.ok(data.memory, 'Memory object must be defined');
    assert.equal(typeof data.memory.heapUsed, 'number');
    assert.equal(typeof data.memory.heapTotal, 'number');
    assert.ok(data.memory.heapUsed > 0, 'heapUsed should be greater than 0');
    assert.ok(data.memory.heapTotal >= data.memory.heapUsed, 'heapTotal must be >= heapUsed');

    // التحقق من التاريخ بصيغة ISO
    assert.ok(!isNaN(Date.parse(data.timestamp)), 'Timestamp must be valid ISO string');
  });
});
