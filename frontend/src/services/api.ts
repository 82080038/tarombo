import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api/v1'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Person API
export const personApi = {
  getAll: (params?: { page?: number; search?: string; marga_id?: number }) =>
    api.get('/persons', { params }),
  
  getById: (id: number | string) =>
    api.get(`/persons/${id}`),
  
  create: (data: any) =>
    api.post('/persons', data),
  
  update: (id: number | string, data: any) =>
    api.put(`/persons/${id}`, data),
  
  delete: (id: number | string) =>
    api.delete(`/persons/${id}`),
  
  calculatePartuturan: (fromId: number, toId: number) =>
    api.get('/partuturan/calculate', {
      params: { from: fromId, to: toId }
    }),
}

// Marga API
export const margaApi = {
  getAll: () =>
    api.get('/marga'),
  
  getById: (id: number | string) =>
    api.get(`/marga/${id}`),
}

export default api
