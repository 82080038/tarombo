import { useParams } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { ArrowLeft, User, Calendar, MapPin } from 'lucide-react'
import { Link } from 'react-router-dom'
import { personApi } from '../services/api'

const PersonDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>()

  const { data, isLoading, error } = useQuery({
    queryKey: ['person', id],
    queryFn: () => personApi.getById(id!),
    enabled: !!id,
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
        <p className="text-red-600">Error loading person details.</p>
      </div>
    )
  }

  const person = data?.data?.data
  const relationships = data?.data?.relationships || {}

  return (
    <div className="space-y-6">
      <Link
        to="/persons"
        className="inline-flex items-center text-blue-600 hover:underline"
      >
        <ArrowLeft className="h-4 w-4 mr-1" />
        Kembali ke Daftar
      </Link>

      {person && (
        <>
          {/* Person Info Card */}
          <div className="bg-white rounded-xl shadow-lg p-8">
            <div className="flex items-start space-x-6">
              <div className="bg-blue-100 rounded-full p-6">
                <User className="h-12 w-12 text-blue-600" />
              </div>
              <div className="flex-1">
                <h1 className="text-3xl font-bold mb-2">{person.nama}</h1>
                <p className="text-xl text-gray-600">Marga {person.marga?.nama}</p>
                <span className="inline-block mt-2 px-3 py-1 text-sm rounded bg-gray-100">
                  {person.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan'}
                </span>
              </div>
            </div>

            <div className="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4">
              {person.tanggal_lahir && (
                <div className="flex items-center space-x-2 text-gray-600">
                  <Calendar className="h-4 w-4" />
                  <span>Lahir: {person.tanggal_lahir}</span>
                </div>
              )}
              {person.tempat_lahir && (
                <div className="flex items-center space-x-2 text-gray-600">
                  <MapPin className="h-4 w-4" />
                  <span>Tempat: {person.tempat_lahir}</span>
                </div>
              )}
            </div>
          </div>

          {/* Relationships */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <RelationshipCard
              title="Tulang"
              persons={relationships.tulang || []}
              description="Saudara laki-laki dari ibu"
            />
            <RelationshipCard
              title="Namboru"
              persons={relationships.namboru || []}
              description="Saudara perempuan dari ayah"
            />
          </div>

          {/* Family Members */}
          <div className="bg-white rounded-xl shadow-md p-6">
            <h2 className="text-xl font-semibold mb-4">Keluarga Terdekat</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {person.father && (
                <FamilyMemberCard
                  label="Ayah"
                  person={person.father}
                />
              )}
              {person.mother && (
                <FamilyMemberCard
                  label="Ibu"
                  person={person.mother}
                />
              )}
            </div>
          </div>
        </>
      )}
    </div>
  )
}

const RelationshipCard: React.FC<{
  title: string
  persons: any[]
  description: string
}> = ({ title, persons, description }) => (
  <div className="bg-white rounded-xl shadow-md p-6">
    <h3 className="text-lg font-semibold mb-2">{title}</h3>
    <p className="text-sm text-gray-600 mb-4">{description}</p>
    {persons.length > 0 ? (
      <ul className="space-y-2">
        {persons.map((person: any) => (
          <li key={person.id} className="text-gray-700">
            {person.nama} {person.marga?.nama}
          </li>
        ))}
      </ul>
    ) : (
      <p className="text-gray-500 italic">Tidak ada data</p>
    )}
  </div>
)

const FamilyMemberCard: React.FC<{
  label: string
  person: any
}> = ({ label, person }) => (
  <div className="bg-gray-50 rounded-lg p-4">
    <p className="text-sm text-gray-600 mb-1">{label}</p>
    <p className="font-medium">{person.nama}</p>
    <p className="text-sm text-gray-500">Marga {person.marga?.nama}</p>
  </div>
)

export default PersonDetailPage
