import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Calculator, Users } from 'lucide-react'
import { personApi } from '../services/api'

const PartuturanPage: React.FC = () => {
  const [personA, setPersonA] = useState<any>(null)
  const [personB, setPersonB] = useState<any>(null)

  const { data: result, isLoading, error } = useQuery({
    queryKey: ['partuturan', personA?.id, personB?.id],
    queryFn: () => {
      if (!personA || !personB) return null
      return personApi.calculatePartuturan(personA.id, personB.id)
    },
    enabled: !!personA && !!personB,
  })

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">Kalkulator Partuturan</h1>

      <div className="partuturan-card">
        <h2 className="text-xl font-semibold text-amber-900 mb-4">
          <Calculator className="inline-block h-5 w-5 mr-2" />
          Hitung Hubungan Kekerabatan
        </h2>
        <p className="text-amber-800 mb-6">
          Masukkan dua orang untuk menghitung hubungan partuturan mereka
          (Tulang, Namboru, Bere, dll.)
        </p>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <PersonSelector
            label="Orang A"
            selected={personA}
            onSelect={setPersonA}
          />
          <PersonSelector
            label="Orang B"
            selected={personB}
            onSelect={setPersonB}
          />
        </div>
      </div>

      {isLoading && (
        <div className="text-center py-8">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-2 text-gray-600">Menghitung hubungan...</p>
        </div>
      )}

      {error && (
        <div className="bg-red-50 border border-red-200 rounded-lg p-4">
          <p className="text-red-600">Error calculating relationship</p>
        </div>
      )}

      {result?.data && (
        <div className="bg-white rounded-xl shadow-lg p-8 text-center">
          <h3 className="text-lg text-gray-600 mb-2">Hubungan:</h3>
          <div className="text-4xl font-bold text-blue-600 mb-2">
            {result.data.relationship}
          </div>
          <p className="text-xl text-gray-700 mb-4">
            {result.data.indonesian}
          </p>

          <div className="bg-gray-50 rounded-lg p-4 mt-4 text-left">
            <h4 className="font-semibold mb-2">Jalur Kekerabatan:</h4>
            <p className="text-gray-700">{result.data.explanation}</p>
          </div>

          <div className="mt-4 text-sm text-gray-500">
            {result.data.from_person.nama} → {result.data.to_person.nama}
          </div>
        </div>
      )}

      {/* Quick Info */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <InfoCard
          title="Tulang"
          description="Saudara laki-laki dari ibu. Posisi terhormat dalam keluarga."
        />
        <InfoCard
          title="Namboru"
          description="Saudara perempuan dari ayah."
        />
        <InfoCard
          title="Bere"
          description="Anak dari saudara perempuan."
        />
      </div>
    </div>
  )
}

interface PersonSelectorProps {
  label: string
  selected: any
  onSelect: (person: any) => void
}

const PersonSelector: React.FC<PersonSelectorProps> = ({ label, selected, onSelect }) => {
  const [search, setSearch] = useState('')
  const { data: persons } = useQuery({
    queryKey: ['persons', search],
    queryFn: () => personApi.getAll({ search }),
    enabled: search.length > 2,
  })

  return (
    <div className="bg-white rounded-lg p-4">
      <label className="block font-semibold mb-2">{label}</label>
      {selected ? (
        <div className="bg-blue-50 rounded-lg p-3 mb-2">
          <p className="font-medium">{selected.nama}</p>
          <p className="text-sm text-gray-600">Marga {selected.marga?.nama}</p>
          <button
            onClick={() => onSelect(null)}
            className="text-sm text-red-600 mt-2 hover:underline"
          >
            Ganti
          </button>
        </div>
      ) : (
        <>
          <div className="relative">
            <Users className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <input
              type="text"
              placeholder="Cari person..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          {persons?.data?.data && (
            <div className="mt-2 max-h-40 overflow-y-auto border rounded">
              {persons.data.data.map((person: any) => (
                <button
                  key={person.id}
                  onClick={() => onSelect(person)}
                  className="w-full text-left px-3 py-2 hover:bg-gray-50"
                >
                  <p className="font-medium">{person.nama}</p>
                  <p className="text-sm text-gray-500">Marga {person.marga?.nama}</p>
                </button>
              ))}
            </div>
          )}
        </>
      )}
    </div>
  )
}

const InfoCard: React.FC<{ title: string; description: string }> = ({ title, description }) => (
  <div className="bg-white rounded-lg shadow p-4">
    <h4 className="font-semibold text-blue-600 mb-2">{title}</h4>
    <p className="text-sm text-gray-600">{description}</p>
  </div>
)

export default PartuturanPage
