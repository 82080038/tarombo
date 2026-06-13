import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Link } from 'react-router-dom'
import { Search, Plus, User } from 'lucide-react'
import { personApi } from '../services/api'

const PersonsPage: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('')
  const [page, setPage] = useState(1)

  const { data, isLoading, error } = useQuery({
    queryKey: ['persons', page, searchTerm],
    queryFn: () => personApi.getAll({ page, search: searchTerm }),
  })

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="bg-red-50 border border-red-200 rounded-lg p-4">
        <p className="text-red-600">Error loading persons. Please try again.</p>
      </div>
    )
  }

  const persons = data?.data?.data || []
  const meta = data?.data?.meta || {}

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">Daftar Person</h1>
        <button className="bg-blue-600 text-white px-4 py-2 rounded-lg flex items-center space-x-2 hover:bg-blue-700">
          <Plus className="h-4 w-4" />
          <span>Tambah Person</span>
        </button>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
        <input
          type="text"
          placeholder="Cari person..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
      </div>

      {/* Persons List */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {persons.map((person: any) => (
          <PersonCard key={person.id} person={person} />
        ))}
      </div>

      {/* Pagination */}
      {meta.total > 0 && (
        <div className="flex justify-between items-center">
          <p className="text-gray-600">
            Showing {((meta.current_page - 1) * meta.per_page) + 1} - {Math.min(meta.current_page * meta.per_page, meta.total)} of {meta.total}
          </p>
          <div className="flex space-x-2">
            <button
              onClick={() => setPage(p => Math.max(1, p - 1))}
              disabled={meta.current_page === 1}
              className="px-4 py-2 border border-gray-300 rounded-lg disabled:opacity-50 hover:bg-gray-50"
            >
              Previous
            </button>
            <button
              onClick={() => setPage(p => p + 1)}
              disabled={meta.current_page === meta.last_page}
              className="px-4 py-2 border border-gray-300 rounded-lg disabled:opacity-50 hover:bg-gray-50"
            >
              Next
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

const PersonCard: React.FC<{ person: any }> = ({ person }) => (
  <Link
    to={`/persons/${person.id}`}
    className="bg-white rounded-lg shadow-md p-4 hover:shadow-lg transition-shadow"
  >
    <div className="flex items-start space-x-3">
      <div className="bg-blue-100 rounded-full p-3">
        <User className="h-6 w-6 text-blue-600" />
      </div>
      <div>
        <h3 className="font-semibold text-lg">{person.nama}</h3>
        <p className="text-gray-600">Marga {person.marga?.nama}</p>
        <span className="inline-block mt-2 px-2 py-1 text-xs rounded bg-gray-100">
          {person.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan'}
        </span>
      </div>
    </div>
  </Link>
)

export default PersonsPage
