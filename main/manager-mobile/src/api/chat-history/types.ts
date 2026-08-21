// Chat session list item
export interface ChatSession {
  sessionId: string
  createdAt: string
  chatCount: number
  title: string
}

// Chat session list response
export interface ChatSessionsResponse {
  total: number
  list: ChatSession[]
}

// Chat message
export interface ChatMessage {
  createdAt: string
  chatType: 1 | 2 | 3 // 1 is user, 2 is AI, 3 is parameter description
  content: string
  audioId: string | null
  macAddress: string
}

// User message content (needs JSON parsing)
export interface UserMessageContent {
  speaker: string
  content: string
}

// Get chat session list params
export interface GetSessionsParams {
  page: number
  limit: number
}

// Audio playback related
export interface AudioResponse {
  data: string // Audio download ID
}
