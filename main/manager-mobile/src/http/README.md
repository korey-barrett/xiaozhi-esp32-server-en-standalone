# Request Library

The current project uses Alova as the sole HTTP request library:

## Usage

- **Alova HTTP**: path (src/http/request/alova.ts)
- **Example code**: src/api/foo-alova.ts and src/api/foo.ts
- **API docs**: https://alova.js.org/

## Configuration Notes

The Alova instance is configured with:
- Automatic Token authentication and refresh
- Unified error handling and notifications
- Support for dynamic domain switching
- Built-in request/response interceptors

## Usage Examples

```typescript
import { http } from '@/http/request/alova'

// GET request
http.Get<ResponseType>('/api/path', {
  params: { id: 1 },
  headers: { 'Custom-Header': 'value' },
  meta: { toast: false } // disable error toast
})

// POST request  
http.Post<ResponseType>('/api/path', data, {
  params: { query: 'param' },
  headers: { 'Content-Type': 'application/json' }
})
```
