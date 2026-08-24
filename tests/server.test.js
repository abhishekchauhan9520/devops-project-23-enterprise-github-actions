import test from 'node:test';
import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import http from 'node:http';

const port = 43123;
let child;

function request(path) {
  return new Promise((resolve, reject) => {
    const req = http.request({ host: '127.0.0.1', port, path }, (res) => {
      let body = '';
      res.on('data', (chunk) => { body += chunk; });
      res.on('end', () => resolve({ status: res.statusCode, body }));
    });
    req.on('error', reject);
    req.end();
  });
}

test.before(async () => {
  child = spawn(process.execPath, ['src/server.js'], { env: { ...process.env, PORT: String(port) } });
  await new Promise((resolve, reject) => {
    const deadline = Date.now() + 5000;
    const poll = () => {
      http.get(`http://127.0.0.1:${port}/healthz`, (res) => {
        if (res.statusCode === 200) return resolve();
        res.resume();
        if (Date.now() > deadline) return reject(new Error('server did not become ready'));
        setTimeout(poll, 50);
      }).on('error', () => {
        if (Date.now() > deadline) reject(new Error('server did not become ready'));
        else setTimeout(poll, 50);
      });
    };
    poll();
  });
});

test.after(() => child?.kill('SIGTERM'));

test('health endpoint is healthy', async () => {
  const result = await request('/healthz');
  assert.equal(result.status, 200);
  assert.equal(JSON.parse(result.body).status, 'ok');
});

test('root endpoint responds', async () => {
  const result = await request('/');
  assert.equal(result.status, 200);
  assert.match(result.body, /Enterprise GitHub Actions CI\/CD/);
});
