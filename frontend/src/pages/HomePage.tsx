import { Link } from 'react-router-dom'
import { Users, GitBranch, Calculator, BookOpen } from 'lucide-react'

const HomePage: React.FC = () => {
  return (
    <div className="space-y-8">
      {/* Hero Section */}
      <div className="text-center py-12 bg-gradient-to-r from-blue-600 to-blue-800 rounded-2xl text-white">
        <h1 className="text-4xl font-bold mb-4">Selamat Datang di Tarombo Digital</h1>
        <p className="text-xl mb-8">Sistem Silsilah Keluarga Batak Berbasis Web</p>
        <div className="flex justify-center space-x-4">
          <Link
            to="/persons"
            className="bg-white text-blue-600 px-6 py-3 rounded-lg font-semibold hover:bg-gray-100"
          >
            Mulai Eksplorasi
          </Link>
          <Link
            to="/partuturan"
            className="bg-amber-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-amber-600"
          >
            Kalkulator Partuturan
          </Link>
        </div>
      </div>

      {/* Features Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <FeatureCard
          icon={<Users className="h-8 w-8 text-blue-600" />}
          title="Kelola Person"
          description="Tambah, edit, dan kelola data anggota keluarga dengan mudah"
          to="/persons"
        />
        <FeatureCard
          icon={<GitBranch className="h-8 w-8 text-green-600" />}
          title="Family Tree"
          description="Visualisasi pohon keluarga interaktif dengan D3.js"
          to="/tree"
        />
        <FeatureCard
          icon={<Calculator className="h-8 w-8 text-amber-600" />}
          title="Partuturan"
          description="Hitung hubungan kekerabatan otomatis (Tulang, Namboru, Bere)"
          to="/partuturan"
        />
        <FeatureCard
          icon={<BookOpen className="h-8 w-8 text-purple-600" />}
          title="Dokumentasi"
          description="18 dokumen lengkap tentang sistem dan budaya Batak"
          to="#"
          external
        />
      </div>

      {/* Stats Section */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <h2 className="text-2xl font-bold mb-4">Statistik Sistem</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <StatCard label="Persons" value="0" />
          <StatCard label="Marga" value="100+" />
          <StatCard label="Sub-Suku" value="6" />
          <StatCard label="Business Rules" value="100+" />
        </div>
      </div>

      {/* Cultural Note */}
      <div className="bg-amber-50 border-l-4 border-amber-500 p-6 rounded-r-lg">
        <h3 className="text-lg font-semibold text-amber-900 mb-2">
          Marsipature Hutanabe
        </h3>
        <p className="text-amber-800">
          "Marsipature Hutanabe, Mardongan Tubu, Marhula-hula, Marboru, dalam Era Digital."
          Sistem ini didesain untuk melestarikan dan mengembangkan kekerabatan Batak
          dengan memanfaatkan teknologi modern.
        </p>
      </div>
    </div>
  )
}

interface FeatureCardProps {
  icon: React.ReactNode
  title: string
  description: string
  to: string
  external?: boolean
}

const FeatureCard: React.FC<FeatureCardProps> = ({ icon, title, description, to, external }) => {
  const content = (
    <div className="bg-white rounded-xl shadow-md p-6 hover:shadow-lg transition-shadow cursor-pointer">
      <div className="mb-4">{icon}</div>
      <h3 className="text-lg font-semibold mb-2">{title}</h3>
      <p className="text-gray-600">{description}</p>
    </div>
  )

  if (external) {
    return (
      <a href={to} target="_blank" rel="noopener noreferrer">
        {content}
      </a>
    )
  }

  return <Link to={to}>{content}</Link>
}

interface StatCardProps {
  label: string
  value: string
}

const StatCard: React.FC<StatCardProps> = ({ label, value }) => (
  <div className="text-center p-4 bg-gray-50 rounded-lg">
    <div className="text-3xl font-bold text-blue-600">{value}</div>
    <div className="text-gray-600">{label}</div>
  </div>
)

export default HomePage
